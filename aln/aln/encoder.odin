package aln

import "core:fmt"
import "core:c"
import "core:mem"
import "core:strings"

// RULE: No public API functions should use any C types (like cstring or c.int)

@(private="file")
OutputStream :: struct {
	st:            ^AVStream,
	enc:           ^AVCodecContext,
	next_pts:      i64,
	samples_count: c.int,
	frame:         ^AVFrame,
	tmp_frame:     ^AVFrame,
	tmp_pkt:       ^AVPacket,
	sws_ctx:       ^SwsContext,
}

@(private="file")
EncoderConfig :: struct {
	width, height: c.int, 
	frame_rate:    c.int,
	bit_rate:      i64,
	encoder_id:    AVCodecID,
	src_pix_fmt:   AVPixelFormat,
	needs_alpha:   c.int,
	profile:       AVProfileID,
}

ENCODER_MAX_DATA_BUFFERS :: AV_NUM_DATA_POINTERS

#assert(size_of(i32) == size_of(c.int))
EncoderWriteFrameCallback :: proc(
	frame_data: [ENCODER_MAX_DATA_BUFFERS][^]u8, frame_linesize: [ENCODER_MAX_DATA_BUFFERS]i32, 
	width, height, frame_index, frame_rate: uint,
) -> bool
EncoderIsFrameCallback :: proc(frame_index, frame_rate: uint) -> bool

encode :: proc(
	filepath:         string, 
	width, height:    uint,
	frame_rate:       uint, 
	bit_rate:         uint, 
	write_frame:      EncoderWriteFrameCallback, 
	is_frame:         EncoderIsFrameCallback,
	src_pixel_format: PixelFormat, 
	profile:          ProfileID = .UNKNOWN,
	encoder_id:       CodecID = .NONE,
	needs_alpha:      bool = false,
	allocator := context.allocator,
) -> bool {
	context.allocator = allocator
	
	c_filepath := strings.clone_to_cstring(filepath)
	defer delete(c_filepath)
	
	return encode_impl(c_filepath, EncoderConfig {
		width = c.int(width), height = c.int(height),
		frame_rate = c.int(frame_rate),
		bit_rate = i64(bit_rate),
		encoder_id = AVCodecID(encoder_id),
		src_pix_fmt = AVPixelFormat(src_pixel_format),
		needs_alpha = 1 if needs_alpha else 0,
		profile = AVProfileID(profile),
	}, write_frame, is_frame)
}

@(private="file")
encode_impl :: proc(
	filepath: cstring, conf: EncoderConfig, 
	write_frame: EncoderWriteFrameCallback, is_frame: EncoderIsFrameCallback, 
) -> bool {
	fmt.printfln("\x1b[33m[ENCODING '%s']\x1b[0m", filepath)

	if ok := init_dll(); !ok {
		return false
	}

	video_st: OutputStream
	oc: ^AVFormatContext
	opt: ^AVDictionary
	
	encoder_string: cstring = nil
	if conf.encoder_id != .AV_CODEC_ID_NONE {
		encoder_string = avcodec_get_name(conf.encoder_id)
	}

	if err := avformat_alloc_output_context2(&oc, nil, encoder_string, filepath); err != nil {
		#partial switch err {
		case .AVERROR_EINVAL:
			fmt.eprintln("Could not deduce output format from file extension: using MPEG.")
			err = avformat_alloc_output_context2(&oc, nil, "mpeg", filepath)
			if err != nil {
				fmt.eprintfln("Failed to create output context: %s", av_err2str(err))
				return false
			}
		case:
			fmt.eprintfln("Failed to create output context: %s", av_err2str(err))
			return false
		}
	}
	defer avformat_free_context(oc)

	ofmt := oc.oformat
	video_codec: ^AVCodec
	
	if ofmt.video_codec != .AV_CODEC_ID_NONE {
		add_stream(&video_st, oc, &video_codec, ofmt.video_codec, conf) or_return
	} else {
		fmt.eprintln("Format has no video codec, cannot encode video.")
		return false
	}

	if !open_video(oc, video_codec, &video_st, opt, conf.src_pix_fmt) {
		return false
	}
	defer close_stream(&video_st)

	av_dump_format(oc, 0, filepath, 1)

	if .AVFMT_NOFILE not_in ofmt.flags {
		if err := avio_open(&oc.pb, filepath, {.AVIO_FLAG_WRITE}); err != nil {
			fmt.eprintfln("Could not open '%s': %s", filepath, av_err2str(err))
			return false
		}
	}
	defer if .AVFMT_NOFILE not_in ofmt.flags do avio_closep(&oc.pb)

	if err := avformat_write_header(oc, &opt); err != nil {
		fmt.eprintfln("Error occurred while writing header: %s", av_err2str(err))
		return false
	}

	for {
		eof, ok := write_video_frame(oc, &video_st, conf, write_frame, is_frame)
		if !ok do return false
		if eof do break
	}

	av_write_trailer(oc)
	
	return true
}

@(private="file")
add_stream :: proc(
	ost: ^OutputStream, oc: ^AVFormatContext, 
	codec: ^^AVCodec, codec_id: AVCodecID,
	conf: EncoderConfig,
) -> (ok: bool) {
	codec^ = avcodec_find_encoder(codec_id)
	if codec^ == nil {
		fmt.eprintfln("Could not find encoder for '%s'", avcodec_get_name(codec_id))
		return false
	}

	ost.tmp_pkt = av_packet_alloc()
	if ost.tmp_pkt == nil {
		fmt.eprintln("Could not allocate AVPacket")
		return false
	}
	defer if !ok do av_packet_free(&ost.tmp_pkt)

	ost.st = avformat_new_stream(oc, nil)
	if ost.st == nil {
		fmt.eprintln("Could not allocate stream")
		return false
	}
	ost.st.id = c.int(oc.nb_streams-1)

	ctx := avcodec_alloc_context3(codec^)
	if ctx == nil {
		fmt.eprintln("Could not allocate encoding context")
		return false
	}
	defer if !ok do avcodec_free_context(&ctx)
	
	ost.enc = ctx

	if codec^.type != .AVMEDIA_TYPE_VIDEO {
		fmt.eprintln("Codec isn't a Video Codec")
		return false
	}

	ctx.codec_id = codec_id
	ctx.bit_rate = conf.bit_rate
	
	ctx.width = conf.width
	ctx.height = conf.height
	
	ost.st.time_base = { num = 1, den = conf.frame_rate }
	ctx.time_base = ost.st.time_base

	ctx.profile = conf.profile

	ctx.gop_size = 10
	ctx.max_b_frames = 1
	ctx.pix_fmt = avcodec_find_best_pix_fmt_of_list(codec^.pix_fmts, conf.src_pix_fmt, conf.needs_alpha, nil)
	if ctx.codec_id == .AV_CODEC_ID_MPEG2VIDEO {
		ctx.max_b_frames = 2
	}
	if ctx.codec_id == .AV_CODEC_ID_MPEG1VIDEO {
		ctx.mb_decision = 2
	}

	if .AVFMT_GLOBALHEADER in oc.oformat.flags {
		ctx.flags |= {.AV_CODEC_FLAG_GLOBAL_HEADER}
	}
	return true
}

@(private="file")
open_video :: proc(
	oc: ^AVFormatContext, codec: ^AVCodec, 
	ost: ^OutputStream, opt_arg: ^AVDictionary,
	src_pix_fmt: AVPixelFormat,
) -> (ok: bool) {
	opt: ^AVDictionary
	if err := av_dict_copy(&opt, opt_arg, {}); err != nil {
		fmt.eprintfln("Couldn't copy options dictionary: %s", av_err2str(err))
		return false
	}
	defer av_dict_free(&opt)

	ctx := ost.enc

	if err := avcodec_open2(ctx, codec, &opt); err != nil {
		fmt.eprintfln("Could not open video codec: %s", av_err2str(err))
		return false
	}
	
	ost.frame = alloc_frame(ctx.pix_fmt, ctx.width, ctx.height) or_return
	defer if !ok do av_frame_free(&ost.frame)

	ost.tmp_frame = nil
	if ctx.pix_fmt != src_pix_fmt {
		ost.tmp_frame = alloc_frame(src_pix_fmt, ctx.width, ctx.height) or_return
	}
	defer if !ok do av_frame_free(&ost.tmp_frame)

	if err := avcodec_parameters_from_context(ost.st.codecpar, ctx); err != nil {
		fmt.eprintfln("Could not copy the stream parameters: %s", av_err2str(err))
		return false
	}
	return true
}

@(private="file")
alloc_frame :: proc(pix_fmt: AVPixelFormat, width, height: c.int) -> (frame: ^AVFrame, ok: bool) {
	frame = av_frame_alloc()
	if frame == nil {
		fmt.eprintln("Could not allocate video frame")
		return nil, false
	}
	defer if !ok do av_frame_free(&frame)

	frame.pix_fmt = pix_fmt
	frame.width = width
	frame.height = height

	if err := av_frame_get_buffer(frame, 0); err != nil {
		fmt.eprintfln("Could not allocate frame data: %s", av_err2str(err))
		return nil, false
	}
	
	return frame, true
}

@(private="file")
close_stream :: proc(ost: ^OutputStream) {
	avcodec_free_context(&ost.enc)
	av_frame_free(&ost.frame)
	av_frame_free(&ost.tmp_frame)
	av_packet_free(&ost.tmp_pkt)
	sws_freeContext(ost.sws_ctx)
}

@(private="file")
get_video_frame :: proc(
	ost: ^OutputStream, 
	conf: EncoderConfig, 
	write_frame: EncoderWriteFrameCallback, is_frame: EncoderIsFrameCallback,
) -> (frame: ^AVFrame, ok: bool) {
	ctx := ost.enc

	if !is_frame(uint(ost.next_pts), uint(conf.frame_rate)) {
		return nil, true
	}

	if err := av_frame_make_writable(ost.frame); err != nil {
		fmt.eprintfln("Could not make the frame writable: %s", av_err2str(err))
		return nil, false
	}

	if ctx.pix_fmt != conf.src_pix_fmt {
		if ost.sws_ctx == nil {
			ost.sws_ctx = sws_getContext(
				ctx.width, ctx.height, // src frame
				conf.src_pix_fmt, 
				ctx.width, ctx.height, // dst frame
				ctx.pix_fmt, 
				{.SWS_BICUBIC}, nil, nil, nil) // other
			if ost.sws_ctx == nil {
				fmt.eprintln("Could not initialize conversion context")
				return nil, false
			}
		}
		write_frame(
			ost.tmp_frame.data, cast([ENCODER_MAX_DATA_BUFFERS]i32)ost.tmp_frame.linesize, 
			uint(ctx.width), uint(ctx.height), 
			uint(ost.next_pts), uint(conf.frame_rate)) or_return
		sws_scale(
			ost.sws_ctx,
			&ost.tmp_frame.data, &ost.tmp_frame.linesize, 0, ctx.height,
			&ost.frame.data, &ost.frame.linesize)
	} else {
		write_frame(
			ost.frame.data, cast([ENCODER_MAX_DATA_BUFFERS]i32)ost.frame.linesize, 
			uint(ctx.width), uint(ctx.height), 
			uint(ost.next_pts), uint(conf.frame_rate)) or_return
	}
	
	ost.next_pts += 1
	ost.frame.pts = ost.next_pts
	return ost.frame, true
}

@(private="file")
write_video_frame :: proc(
	oc: ^AVFormatContext, ost: ^OutputStream, 
	conf: EncoderConfig, 
	write_frame: EncoderWriteFrameCallback, is_frame: EncoderIsFrameCallback,
) -> (eof: bool, ok: bool) {
	frame := get_video_frame(ost, conf, write_frame, is_frame) or_return
	return send_frame(oc, ost.enc, ost.st, frame, ost.tmp_pkt)
}

@(private="file")
send_frame :: proc(
	fmt_ctx: ^AVFormatContext, ctx: ^AVCodecContext,
	st: ^AVStream, frame: ^AVFrame, pkt: ^AVPacket,
) -> (eof: bool, ok: bool) {
	if err := avcodec_send_frame(ctx, frame); err != nil {
		fmt.eprintfln("Error sending a frame to the encoder: %s", av_err2str(err))
		return false, false
	}

	for {
		if err := avcodec_receive_packet(ctx, pkt); err != nil {
			#partial switch err {
			case .AVERROR_EAGAIN:
				return false, true
			case .AVERROR_EOF:
				return true, true
			case:
				fmt.eprintfln("Error encoding a frame: %s", av_err2str(err))
				return false, false
			}
		}

		av_packet_rescale_ts(pkt, ctx.time_base, st.time_base)
		pkt.stream_index = st.index

		// log_packet(fmt_ctx, pkt)
		if err := av_interleaved_write_frame(fmt_ctx, pkt); err != nil {
			fmt.eprintfln("Error while writing output packet: %s", av_err2str(err))
			return false, false
		}
	}
}

@(private="file")
log_packet :: proc(fmt_ctx: ^AVFormatContext, pkt: ^AVPacket) {
	time_base := &fmt_ctx.streams[pkt.stream_index].time_base
	fmt.printfln(
		"pts:%s pts_time:%s dts:%s dts_time:%s duration:%s duration_time:%s stream_index:%d",
		av_ts2str(pkt.pts), av_ts2timestr(pkt.pts, time_base),
		av_ts2str(pkt.dts), av_ts2timestr(pkt.dts, time_base),
		av_ts2str(pkt.duration), av_ts2timestr(pkt.duration, time_base),
		pkt.stream_index)
}

