package main

import "aln:aln"

import "core:c"
import "core:fmt"
import "core:os"

STREAM_DURATION :: 10
STREAM_FRAME_RATE :: 25
STREAM_PIX_FMT :: aln.AVPixelFormat.AV_PIX_FMT_YUV420P

OutputStream :: struct {
	st:               ^aln.AVStream,
	enc:              ^aln.AVCodecContext,
	next_pts:         i64,
	samples_count:    c.int,
	frame:            ^aln.AVFrame,
	tmp_frame:        ^aln.AVFrame,
	tmp_pkt:          ^aln.AVPacket,
	sws_ctx:          ^aln.SwsContext,
}

log_packet :: proc(fmt_ctx: ^aln.AVFormatContext, pkt: ^aln.AVPacket) {
	time_base := &fmt_ctx.streams[pkt.stream_index].time_base
	fmt.printfln(
		"pts:%s pts_time:%s dts:%s dts_time:%s duration:%s duration_time:%s stream_index:%d",
		aln.av_ts2str(pkt.pts), aln.av_ts2timestr(pkt.pts, time_base),
		aln.av_ts2str(pkt.dts), aln.av_ts2timestr(pkt.dts, time_base),
		aln.av_ts2str(pkt.duration), aln.av_ts2timestr(pkt.duration, time_base),
		pkt.stream_index)
}

write_frame :: proc(
	fmt_ctx: ^aln.AVFormatContext, ctx: ^aln.AVCodecContext,
	st: ^aln.AVStream, frame: ^aln.AVFrame, pkt: ^aln.AVPacket,
) -> (eof: bool, ok: bool) {
	if err := aln.avcodec_send_frame(ctx, frame); err != nil {
		fmt.eprintfln("Error sending a frame to the encoder: %s", aln.av_err2str(err))
		return false, false
	}

	for {
		if err := aln.avcodec_receive_packet(ctx, pkt); err != nil {
			#partial switch err {
			case .AVERROR_EAGAIN:
				return false, true
			case .AVERROR_EOF:
				return true, true
			case:
				fmt.eprintfln("Error encoding a frame: %s", aln.av_err2str(err))
				return false, false
			}
		}

		aln.av_packet_rescale_ts(pkt, ctx.time_base, st.time_base)
		pkt.stream_index = st.index

		// log_packet(fmt_ctx, pkt)
		if err := aln.av_interleaved_write_frame(fmt_ctx, pkt); err != nil {
			fmt.eprintfln("Error while writing output packet: %s", aln.av_err2str(err))
			return false, false
		}
	}
}

add_stream :: proc(
	ost: ^OutputStream, oc: ^aln.AVFormatContext, 
	codec: ^^aln.AVCodec, codec_id: aln.AVCodecID,
) -> (ok: bool) {
	codec^ = aln.avcodec_find_encoder(codec_id)
	if codec^ == nil {
		fmt.eprintfln("Could not find encoder for '%s'", aln.avcodec_get_name(codec_id))
		return false
	}

	ost.tmp_pkt = aln.av_packet_alloc()
	if ost.tmp_pkt == nil {
		fmt.eprintln("Could not allocate aln.AVPacket")
		return false
	}
	defer if !ok do aln.av_packet_free(&ost.tmp_pkt)

	ost.st = aln.avformat_new_stream(oc, nil)
	if ost.st == nil {
		fmt.eprintln("Could not allocate stream")
		return false
	}
	ost.st.id = c.int(oc.nb_streams-1)

	ctx := aln.avcodec_alloc_context3(codec^)
	if ctx == nil {
		fmt.eprintln("Could not allocate encoding context")
		return false
	}
	defer if !ok do aln.avcodec_free_context(&ctx)
	
	ost.enc = ctx

	if codec^.type != .AVMEDIA_TYPE_VIDEO {
		fmt.eprintln("Codec isn't a Video Codec")
		return false
	}

	ctx.codec_id = codec_id
	ctx.bit_rate = 400000
	
	ctx.width = 352
	ctx.height = 288
	
	ost.st.time_base = { num = 1, den = STREAM_FRAME_RATE }
	ctx.time_base = ost.st.time_base

	ctx.gop_size = 12
	ctx.pix_fmt = STREAM_PIX_FMT
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

alloc_frame :: proc(pix_fmt: aln.AVPixelFormat, width, height: c.int) -> (frame: ^aln.AVFrame, ok: bool) {
	frame = aln.av_frame_alloc()
	if frame == nil {
		fmt.eprintln("Could not allocate video frame")
		return nil, false
	}
	defer if !ok do aln.av_frame_free(&frame)

	frame.pix_fmt = pix_fmt
	frame.width = width
	frame.height = height

	if err := aln.av_frame_get_buffer(frame, 0); err != nil {
		fmt.eprintfln("Could not allocate frame data: %s", aln.av_err2str(err))
		return nil, false
	}
	
	return frame, true
}

open_video :: proc(
	oc: ^aln.AVFormatContext, codec: ^aln.AVCodec, 
	ost: ^OutputStream, opt_arg: ^aln.AVDictionary,
) -> (ok: bool) {
	opt: ^aln.AVDictionary
	if err := aln.av_dict_copy(&opt, opt_arg, {}); err != nil {
		fmt.eprintfln("Couldn't copy options dictionary: %s", aln.av_err2str(err))
		return false
	}
	defer aln.av_dict_free(&opt)

	ctx := ost.enc

	if err := aln.avcodec_open2(ctx, codec, &opt); err != nil {
		fmt.eprintln("Could not open video codec: %s", aln.av_err2str(err))
		return false
	}
	
	ost.frame = alloc_frame(ctx.pix_fmt, ctx.width, ctx.height) or_return
	defer if !ok do aln.av_frame_free(&ost.frame)

	ost.tmp_frame = nil
	if ctx.pix_fmt != .AV_PIX_FMT_YUV420P {
		ost.tmp_frame = alloc_frame(.AV_PIX_FMT_YUV420P, ctx.width, ctx.height) or_return
	}
	defer if !ok do aln.av_frame_free(&ost.tmp_frame)

	if err := aln.avcodec_parameters_from_context(ost.st.codecpar, ctx); err != nil {
		fmt.eprintfln("Could not copy the stream parameters: %s", aln.av_err2str(err))
		return false
	}
	return true
}

fill_yuv_image :: proc(pict: ^aln.AVFrame, frame_index, width, height: c.int) {
	i := frame_index

	// Y channel
	for y in 0 ..< height {
		for x in 0 ..< width {
			pict.data[0][y * pict.linesize[0] + x] = u8(x + y + i * 3)
		}
	}

	// Cb and Cr channels
	for y in 0 ..< height / 2 {
		for x in 0 ..< width / 2 {
			pict.data[1][y * pict.linesize[1] + x] = u8(128 + y + i * 2)
			pict.data[2][y * pict.linesize[2] + x] = u8(64 + x + i * 5)
		}
	}
}

get_video_frame :: proc(ost: ^OutputStream) -> (frame: ^aln.AVFrame, ok: bool) {
	ctx := ost.enc

	if aln.av_compare_ts(
		ost.next_pts, ctx.time_base, 
		STREAM_DURATION, aln.AVRational { num = 1, den = 1 }) > 0 {
		return nil, true
	}

	if err := aln.av_frame_make_writable(ost.frame); err != nil {
		fmt.eprintfln("Could not make the frame writable: %s", aln.av_err2str(err))
		return nil, false
	}

	if ctx.pix_fmt != .AV_PIX_FMT_YUV420P {
		if ost.sws_ctx == nil {
			ost.sws_ctx = aln.sws_getContext(
				ctx.width, ctx.height, // src frame
				.AV_PIX_FMT_YUV420P, 
				ctx.width, ctx.height, // dst frame
				ctx.pix_fmt, 
				{.SWS_BICUBIC}, nil, nil, nil) // other
			if ost.sws_ctx == nil {
				fmt.eprintln("Could not initialize conversion context")
				return nil, false
			}
			fill_yuv_image(ost.tmp_frame, i32(ost.next_pts), ctx.width, ctx.height)
			aln.sws_scale(
				ost.sws_ctx, 
				&ost.tmp_frame.data, &ost.tmp_frame.linesize, 0, ctx.height, 
				&ost.frame.data, &ost.frame.linesize)
		}
	} else {
		fill_yuv_image(ost.frame, i32(ost.next_pts), ctx.width, ctx.height)
	}
	
	ost.next_pts += 1
	ost.frame.pts = ost.next_pts
	return ost.frame, true
}

write_video_frame :: proc(oc: ^aln.AVFormatContext, ost: ^OutputStream) -> (eof: bool, ok: bool) {
	frame := get_video_frame(ost) or_return
	return write_frame(oc, ost.enc, ost.st, frame, ost.tmp_pkt)
}

close_stream :: proc(ost: ^OutputStream) {
	aln.avcodec_free_context(&ost.enc)
	aln.av_frame_free(&ost.frame)
	aln.av_frame_free(&ost.tmp_frame)
	aln.av_packet_free(&ost.tmp_pkt)
	aln.sws_freeContext(ost.sws_ctx)
}

main :: proc() {
	err := run()
	if err != 0 do os.exit(err)
}

// This way the defers will actually happen before exiting the program when an error occurs
run :: proc() -> int {
	if ok := aln.init_dll(); !ok {
		return 1
	}

	video_st: OutputStream
	oc: ^aln.AVFormatContext
	opt: ^aln.AVDictionary

	filename :: "test.mp4"

	if err := aln.avformat_alloc_output_context2(&oc, nil, nil, filename); err != nil {
		#partial switch err {
		case .AVERROR_EINVAL:
			fmt.eprintln("Could not deduce output format from file extension: using MPEG.")
			err = aln.avformat_alloc_output_context2(&oc, nil, "mpeg", filename)
			if err != nil {
				fmt.eprintfln("Failed to create output context: %s", aln.av_err2str(err))
				return 1
			}
		case:
			fmt.eprintfln("Failed to create output context: %s", aln.av_err2str(err))
			return 1
		}
	}
	defer aln.avformat_free_context(oc)
	
	ofmt := oc.oformat
	video_codec: ^aln.AVCodec
	
	if ofmt.video_codec != .AV_CODEC_ID_NONE {
		if !add_stream(&video_st, oc, &video_codec, ofmt.video_codec) {
			return 1
		}
	} else {
		fmt.eprintln("Format has no video codec, cannot encode video.")
		return 1
	}

	if !open_video(oc, video_codec, &video_st, opt) {
		return 1
	}
	defer close_stream(&video_st)

	aln.av_dump_format(oc, 0, filename, 1)

	if .AVFMT_NOFILE not_in ofmt.flags {
		if err := aln.avio_open(&oc.pb, filename, {.AVIO_FLAG_WRITE}); err != nil {
			fmt.eprintfln("Could not open '%s': %s", filename, aln.av_err2str(err))
			return 1
		}
	}
	defer if .AVFMT_NOFILE not_in ofmt.flags do aln.avio_closep(&oc.pb)

	if err := aln.avformat_write_header(oc, &opt); err != nil {
		fmt.eprintfln("Error occurred while writing header: %s", aln.av_err2str(err))
		return 1
	}

	for {
		eof, ok := write_video_frame(oc, &video_st)
		if !ok do return 1
		if eof do break
	}

	aln.av_write_trailer(oc)
	
	return 0
}

