//+private
package aln

import "core:fmt"
import "core:c"
import "core:os"
import "core:dynlib"
import "core:sys/windows"
import "core:unicode/utf16"
import "core:path/filepath"
import "core:path/slashpath"
import "base:intrinsics"
import "base:runtime"
import "core:mem"
import "core:slice"
import "core:strings"

AVClass :: struct {}

AVDictionary :: struct {}

AVCodecParameters :: struct {
	codec_type:          AVMediaType,
	codec_id:            AVCodecID,
	codec_tag:           u32,
	extradata:           [^]u8,
	extradata_size:      c.int,
	coded_side_data:     [^]AVPacketSideData,
	nb_coded_side_data:  c.int,
	using _format_union: struct #raw_union {
		format:     c.int,
		pix_fmt:    AVPixelFormat,
		sample_fmt: AVSampleFormat,
	},
}

AVCodecTag :: struct {
	id:  AVCodecID,
	tag: c.uint,
}

AVOutputFormatFlagBits :: enum {
	AVFMT_NOFILE,
	AVFMT_NEED_NUMBER,
	AVFMT_EXPERIMENTAL,
	AVFMT_SHOW_IDS,
	AVFMT_GLOBALHEADER = 6,
	AVFMT_NOTIMESTAMPS,
	AVFMT_GENERIC_INDEX,
	AVFMT_IS_DISCONT,
	AVFMT_VARIABLE_FPS,
	AVFMT_NODIMENSIONS,
	AVFMT_NOSTREAMS,
	AVFMT_NOBINSEARCH,
	AVFMT_NOGENSEARCH,
	AVFMT_NO_BYTE_SEEK,
	AVFMT_ALLOW_FLUSH, // deprecated, just send a NULL packet to flush a muxer
	AVFMT_TS_NONSTRICT,
	AVFMT_TS_NEGATIVE,
	AVFMT_SEEK_TO_PTS = 26,
}
AVOutputFormatFlags :: bit_set[AVOutputFormatFlagBits; c.int]

AVOutputFormat :: struct {
	name:           cstring,
	long_name:      cstring,
	mime_type:      cstring,
	extensions:     cstring,
	audio_codec:    AVCodecID,
	video_codec:    AVCodecID,
	subtitle_codec: AVCodecID,
	flags:          AVOutputFormatFlags,
	codec_tag:      [^]^AVCodecTag,
	priv_class:     ^AVClass,
}

AVInputFormat :: struct {
	name:       cstring,
	long_name:  cstring,
	flags:      c.int, // TODO: make bit_set
	extensions: cstring,
	codec_tag:  [^]^AVCodecTag,
	priv_class: ^AVClass,
	mime_type:  cstring,
}

AVStream :: struct {
	av_class:            ^AVClass,
	index:               c.int,
	id:                  c.int,
	codecpar:            ^AVCodecParameters,
	priv_data:           rawptr,
	time_base:           AVRational,
	start_time:          i64,
	duration:            i64,
	nb_frames:           i64,
	disposition:         c.int, // TODO: make bit_set
	discard:             AVDiscard,
	sample_aspect_ratio: AVRational,
	metadata:            ^AVDictionary,
	avg_frame_rate:      AVRational,
	attached_pic:        AVPacket,
	side_data:           [^]AVPacketSideData,
	nb_side_data:        c.int,
	event_flags:         c.int, // TODO: make bit_set
	r_frame_rate:        AVRational,
	pts_wrap_bits:       c.int,
}

AVStreamGroupParamsType :: distinct c.int // TODO: define enum

AVStreamGroupTileGrid :: struct {}
AVIAMFAudioElement :: struct {}
AVIAMFMixPresentation :: struct {}

AVStreamGroup :: struct {
	av_class:  ^AVClass,
	priv_data: rawptr,
	index:     c.uint,
	id:        i64,
	type:      AVStreamGroupParamsType,
	params:    struct #raw_union {
		iamf_audio_element:    ^AVIAMFAudioElement,
		iamf_mix_presentation: ^AVIAMFMixPresentation,
		tile_grid:             ^AVStreamGroupTileGrid,
	},
	metadata:    ^AVDictionary,
	nb_streams:  c.uint,
	streams:     [^]^AVStream,
	disposition: c.int, // TODO: make bit_set
}

AVIOInterruptCB :: struct {
	callback: proc "c" (_: rawptr) -> c.int,
	opaque:   rawptr,
}

AVIODataMarkerType :: distinct c.int // TODO: define enum

AVIOContext :: struct {
	av_class:        ^AVClass,
	buffer:          [^]u8,
	buffer_size:     c.int,
	buf_ptr:         ^u8,
	buf_end:         ^u8,
	opaque:          rawptr,
	read_packet:     proc "c" (opaque: rawptr, buf: [^]u8, buf_size: c.int) -> AVError,
	write_packet:    proc "c" (opaque: rawptr, buf: [^]u8, buf_size: c.int) -> AVError,
	seek:            proc "c" (opaque: rawptr, offset: i64, whence: c.int) -> i64,
	pos:             i64,
	eof_reached:     c.int,
	error:           c.int,
	write_flag:      c.int,
	max_packet_size: c.int,
	min_packet_size: c.int,
	checksum:        c.ulong,
	checksum_ptr:    [^]u8,
	update_checksum: proc "c" (checksum: c.ulong, buf: [^]u8, size: c.uint) -> c.ulong,
	read_pause:      proc "c" (opaque: rawptr, pause: c.int) -> AVError,
	read_seek:       proc "c" (
		opaque: rawptr,
		stream_index: c.int,
		timestamp: i64,
		flags: c.int,
	) -> i64,
	seekable:           c.int, // TODO: make bit_set
	direct:             c.int,
	protocol_whitelist: cstring,
	protocol_blacklist: cstring,
	write_data_type:    proc "c" (
		opaque: rawptr,
		buf: [^]u8,
		buf_size: c.int,
		type: AVIODataMarkerType,
		time: i64,
	) -> AVError,
	ignore_boundary_point: c.int,
	buf_ptr_max:           ^u8,
	bytes_read:            i64,
	bytes_written:         i64,
}

AVProgram :: struct {
	id:                c.int,
	flags:             c.int,
	discard:           AVDiscard,
	stream_index:      [^]c.uint,
	nb_stream_indexes: c.int,
	metadata:          ^AVDictionary,
	program_num:       c.int,
	pmt_pid:           c.int,
	pcr_pid:           c.int,
	pmt_version:       c.int,

	// There are things below this, but they are not part of the public API.
}

AVChapter :: struct {
	id:         i64,
	time_base:  AVRational,
	start, end: i64,
	metadata:   ^AVDictionary,
}

av_format_control_message :: proc "c" (
	s:         ^AVFormatContext,
	type:      c.int,
	data:      rawptr,
	data_size: c.size_t,
) -> AVError

AVOpenCallback :: proc "c" (
	s:       ^AVFormatContext,
	pb:      ^^AVIOContext,
	url:     cstring,
	flags:   c.int,
	int_cb:  ^AVIOInterruptCB,
	options: ^^AVDictionary,
) -> AVError

AVDurationEstimationMethod :: distinct c.int // TODO: define enum

AVFormatContext :: struct {
	av_class:                        ^AVClass,
	iformat:                         ^AVInputFormat,
	oformat:                         ^AVOutputFormat,
	priv_data:                       rawptr,
	pb:                              ^AVIOContext,
	ctx_flags:                       c.int, // TODO: make bit_set
	nb_streams:                      c.uint,
	streams:                         [^]^AVStream,
	nb_stream_groups:                c.uint,
	stream_groups:                   [^]^AVStreamGroup,
	nb_chapters:                     c.uint,
	chapters:                        [^]^AVChapter,
	url:                             cstring,
	start_time:                      i64,
	duration:                        i64,
	bit_rate:                        i64,
	packet_size:                     c.uint,
	max_delay:                       c.int,
	flags:                           c.int, // TODO: make bit_set
	probesize:                       c.int,
	max_analyze_duration:            i64,
	key:                             [^]u8,
	keylen:                          c.int,
	nb_programs:                     c.uint,
	programs:                        [^]^AVProgram,
	video_codec_id:                  AVCodecID,
	audio_codec_id:                  AVCodecID,
	subtitle_codec_id:               AVCodecID,
	data_codec_id:                   AVCodecID,
	metadata:                        ^AVDictionary,
	start_time_realtime:             i64,
	fps_probe_size:                  c.int,
	error_recognition:               c.int,
	interrupt_callback:              AVIOInterruptCB,
	debug:                           c.int,
	max_streams:                     c.int,
	max_index_size:                  c.uint,
	max_picture_buffer:              c.uint,
	max_interleave_delta:            i64,
	max_ts_probe:                    c.int,
	max_chunk_duration:              c.int,
	max_chunk_size:                  c.int,
	max_probe_packets:               c.int,
	strict_std_compliance:           c.int,
	event_flags:                     c.int, // TODO: make bit_set
	avoid_negative_ts:               c.int, // TODO: make enum
	audio_preload:                   c.int,
	use_wallclock_as_timestamps:     c.int,
	skip_estimate_duration_from_pts: c.int,
	avio_flags:                      c.int, // TODO: make bit_set
	duration_estimation_method:      AVDurationEstimationMethod,
	skip_initial_bytes:              i64,
	correct_ts_overflow:             c.uint,
	seek2any:                        c.int,
	flush_packets:                   c.int,
	probe_score:                     c.int,
	format_probesize:                c.int,
	codec_whitelist:                 cstring,
	format_whitelist:                cstring,
	protocol_whitelist:              cstring,
	protocol_blacklist:              cstring,
	io_respositioned:                c.int,
	video_codec:                     ^AVCodec,
	audio_codec:                     ^AVCodec,
	subtitle_codec:                  ^AVCodec,
	data_codec:                      ^AVCodec,
	metadata_header_padding:         c.int,
	opaque:                          rawptr,
	control_message_cb:              av_format_control_message,
	output_ts_offset:                i64,
	dump_separator:                  cstring,
	io_open:                         proc "c" (
		s: ^AVFormatContext,
		pb: ^^AVIOContext,
		url: cstring,
		flags: c.int,
		options: ^^AVDictionary,
	) -> AVError,
	io_close2:          proc "c" (s: ^AVFormatContext, pb: ^AVIOContext) -> AVError,
	duration_probesize: i64,
}

AVCodecInternal :: struct {}
AVCodecDescriptor :: struct {}

AVPacketSideData :: struct {}
AVFrameSideData :: struct {}

AV_NUM_DATA_POINTERS :: 8

AVBuffer :: struct {}
AVBufferRef :: struct {
	buffer: ^AVBuffer,
	data:   [^]u8,
	size:   c.size_t,
}

RcOverride :: struct {
	start_frame:    c.int,
	end_frame:      c.int,
	qscale:         c.int,
	quality_factor: c.float,
}

AVHWAccel :: struct {
	name:         cstring,
	type:         AVMediaType,
	id:           AVCodecID,
	pix_fmt:      AVPixelFormat,
	capabilities: c.int, // TODO: make bit_set
}

AVCodecFlagBits :: enum {
	AV_CODEC_FLAG_UNALIGNED,
	AV_CODEC_FLAG_QSCALE,
	AV_CODEC_FLAG_4MV,
	AV_CODEC_FLAG_DROPCHANGED, // deprecated
	AV_CODEC_FLAG_RECON_FRAME,
	AV_CODEC_FLAG_COPY_OPAQUE,
	AV_CODEC_FLAG_FRAME_DURATION,
	AV_CODEC_FLAG_PASS1,
	AV_CODEC_FLAG_PASS2,
	AV_CODEC_FLAG_LOOP_FILTER,
	AV_CODEC_FLAG_GRAY = 13,
	AV_CODEC_FLAG_PSNR = 15,
	AV_CODEC_FLAG_INTERLACED_DCT = 18,
	AV_CODEC_FLAG_LOW_DELAY,
	AV_CODEC_FLAG_GLOBAL_HEADER  = 22,
	AV_CODEC_FLAG_BITEXACT,
	AV_CODEC_FLAG_AC_PRED,
	AV_CODEC_FLAG_INTERLACED_ME = 29,
	AV_CODEC_FLAG_CLOSE_GOP     = 31,
}

AVCodecFlags :: bit_set[AVCodecFlagBits; c.int]

AVCodecContext :: struct {
	class:                       ^AVClass,
	log_level_offset:            c.int,
	codec_type:                  AVMediaType,
	codec:                       ^AVCodec,
	codec_id:                    AVCodecID,
	codec_tag:                   c.uint,
	priv_data:                   rawptr,
	internal:                    ^AVCodecInternal,
	opaque:                      rawptr,
	bit_rate:                    i64,
	flags:                       AVCodecFlags,
	flags2:                      c.int, // TODO: make bit_set
	extradata:                   [^]u8,
	extradata_size:              c.int,
	time_base:                   AVRational,
	pkt_timebase:                AVRational,
	framerate:                   AVRational,
	ticks_per_frame:             c.int,
	delay:                       c.int,
	width, height:               c.int,
	coded_width:                 c.int,
	coded_height:                c.int,
	sample_aspect_ratio:         AVRational,
	pix_fmt:                     AVPixelFormat,
	color_primaries:             c.int,
	color_trc:                   AVColorTransferCharacteristic,
	colorspace:                  AVColorSpace,
	color_range:                 AVColorRange,
	chroma_sample_location:      AVChromaLocation,
	field_order:                 AVFieldOrder,
	refs:                        c.int,
	has_b_frames:                c.int,
	slice_flags:                 c.int, // TODO: make bit_set
	draw_horiz_band:             proc "c" (
		s: ^AVCodecContext,
		src: ^AVFrame,
		offset: [AV_NUM_DATA_POINTERS]c.int,
		y: c.int,
		type: c.int,
		height: c.int,
	),
	get_format:                  proc "c" (
		s: ^AVCodecContext,
		fmt: ^AVPixelFormat,
	) -> AVPixelFormat,
	max_b_frames:                c.int,
	b_quant_factor:              c.float,
	i_quant_offset:              c.float,
	lumi_masking:                c.float,
	temporal_cmplx_masking:      c.float,
	spatial_cmplx_masking:       c.float,
	p_masking:                   c.float,
	dark_masking:                c.float,
	nsse_weight:                 c.int,
	me_cmp:                      c.int,
	me_sub_cmp:                  c.int,
	mb_cmp:                      c.int,
	ildct_cmp:                   c.int,
	dia_size:                    c.int,
	last_predictor_count:        c.int,
	me_pre_cmp:                  c.int,
	pre_dia_size:                c.int,
	me_subpel_quality:           c.int,
	me_range:                    c.int,
	mb_decision:                 c.int,
	intra_matrix:                ^u16,
	inter_matrix:                ^u16,
	chroma_intra_matrix:         ^u16,
	intra_dc_precision:          c.int,
	mb_lmin:                     c.int,
	mb_lmax:                     c.int,
	bidir_refine:                c.int,
	keyint_min:                  c.int,
	gop_size:                    c.int,
	mv0_threshold:               c.int,
	slices:                      c.int,
	sample_rate:                 c.int,
	sample_format:               AVSampleFormat,
	ch_layout:                   AVChannelLayout,
	frame_size:                  c.int,
	block_align:                 c.int,
	cutoff:                      c.int,
	audio_service_type:          AVAudioServiceType,
	request_sample_fmt:          AVSampleFormat,
	initial_padding:             c.int,
	trailing_padding:            c.int,
	seek_preroll:                c.int,
	get_buffer2:                 proc "c" (s: ^AVCodecContext, frame: ^AVFrame, flags: c.int) -> AVError,
	bit_rate_tolerance:          c.int,
	global_quality:              c.int,
	compression_level:           c.int,
	qcompress:                   c.float,
	qmin:                        c.int,
	qmax:                        c.int,
	max_qdiff:                   c.int,
	rc_buffer_size:              c.int,
	rc_override_count:           c.int,
	rc_override:                 [^]RcOverride,
	rc_max_rate:                 i64,
	rc_min_rate:                 i64,
	rc_max_available_vbv_use:    c.float,
	rc_min_available_vbv_use:    c.float,
	rc_initial_buffer_occupancy: c.int,
	trellis:                     c.int,
	stats_out:                   cstring,
	stats_in:                    cstring,
	workaround_bugs:             c.int, // TODO: make bit_set
	strict_std_compliance:       c.int,
	error_concealment:           c.int, // TODO: make bit_set
	debug:                       c.int, // TODO: make bit_set
	err_recognition:             c.int, // TODO: make bit_set
	hw_accel:                    ^AVHWAccel,
	hwaccel_context:             rawptr,
	hw_frames_ctx:               ^AVBufferRef,
	hw_device_ctx:               ^AVBufferRef,
	hwaccel_flags:               c.int, // TODO: make bit_set
	extra_hw_frames:             c.int,
	error:                       [AV_NUM_DATA_POINTERS]u64,
	dct_algo:                    c.int, // TODO: make enum
	idct_algo:                   c.int, // TODO: make enum
	bits_per_coded_sample:       c.int,
	bits_per_raw_sample:         c.int,
	thread_count:                c.int,
	thread_type:                 c.int, // TODO: make enum
	active_thread_type:          c.int,
	execute:                     proc "c" (
		ctx: ^AVCodecContext,
		func: proc "c" (c2: ^AVCodecContext, arg: rawptr) -> AVError,
		arg2: rawptr,
		ret: ^c.int,
		count: c.int,
		size: c.int,
	) -> AVError,
	execute2: proc "c" (
		ctx: ^AVCodecContext,
		func: proc "c" (c2: ^AVCodecContext, arg: rawptr, jobnr: c.int, threadnr: c.int) -> AVError,
		arg2: rawptr,
		ret: ^c.int,
		count: c.int,
	) -> AVError,
	profile:                    AVProfileID,
	level:                      c.int, // TODO: make enum
	properties:                 c.uint, // TODO: make bit_set
	skip_loop_filter:           AVDiscard,
	skip_idct:                  AVDiscard,
	skip_frame:                 AVDiscard,
	skip_alpha:                 c.int,
	skip_top:                   c.int,
	skip_bottom:                c.int,
	lowres:                     c.int,
	codec_descriptor:           ^AVCodecDescriptor,
	sub_charenc:                cstring,
	sub_charenc_mode:           c.int, // TODO: make enum
	subtitle_header_size:       c.int,
	subtitle_header:            [^]u8,
	dump_separator:             cstring,
	codec_whitelist:            cstring,
	coded_side_data:            ^AVPacketSideData,
	nb_coded_side_data:         c.int,
	export_side_data:           c.int,
	max_pixels:                 i64,
	apply_cropping:             c.int,
	discard_damaged_percentage: c.int,
	max_samples:                i64,
	get_encode_buffer:          proc "c" (
		s: ^AVCodecContext,
		pkt: ^AVPacket,
		flags: c.int, // TODO: make bit_set
	) -> AVError,
	frame_num:                  i64,
	side_data_prefer_packet:    [^]c.int,
	nb_side_data_prefer_packet: c.uint,
	decoded_side_data:          [^]^AVFrameSideData,
	nb_decoded_side_data:       c.int,
}

AVFrame :: struct {
	data:                [AV_NUM_DATA_POINTERS][^]u8,
	linesize:            [AV_NUM_DATA_POINTERS]c.int,
	extended_data:       [^][^]u8,
	width, height:       c.int,
	nb_samples:          c.int,
	using _format_union: struct #raw_union {
		format:     c.int,
		pix_fmt:    AVPixelFormat,
		sample_fmt: AVSampleFormat,
	},
	key_frame:             c.int,
	pict_type:             AVPictureType,
	sample_aspect_ratio:   AVRational,
	pts:                   i64,
	pkt_dls:               i64,
	time_base:             AVRational,
	quality:               c.int,
	opaque:                rawptr,
	repeat_plot:           c.int,
	interlaced_frame:      c.int,
	top_field_first:       c.int,
	palette_has_changed:   c.int,
	sample_rate:           c.int,
	buf:                   [AV_NUM_DATA_POINTERS]^AVBufferRef,
	extended_buf:          [^]^AVBufferRef,
	nb_extended_buf:       c.int,
	side_data:             [^]^AVFrameSideData,
	nb_side_data:          c.int,
	flags:                 c.int, // TODO: make bit_set
	color_range:           AVColorRange,
	color_primaries:       AVColorPrimaries,
	color_trc:             AVColorTransferCharacteristic,
	colorspace:            AVColorSpace,
	chroma_location:       AVChromaLocation,
	best_effort_timestamp: i64,
	pkt_pos:               i64,
	metadata:              ^AVDictionary,
	decode_error_flags:    c.int, // TODO: make bit_set
	hw_frames_ctx:         ^AVBufferRef,
	opaque_ref:            ^AVBufferRef,
	crop_top:              c.size_t,
	crop_bottom:           c.size_t,
	crop_left:             c.size_t,
	crop_right:            c.size_t,
	private_ref:           ^AVBufferRef,
	ch_layout:             AVChannelLayout,
	duration:              i64,
}

AVPacket :: struct {
	buf:             ^AVBufferRef,
	pts:             i64,
	dts:             i64,
	data:            [^]u8,
	size:            c.int,
	stream_index:    c.int,
	side_data:       [^]AVPacketSideData,
	side_data_elems: c.int,
	duration:        i64,
	pos:             i64,
	opaque:          rawptr,
	opaque_ref:      ^AVBufferRef,
	time_base:       AVRational,
}

AVMediaType :: enum c.int {
    AVMEDIA_TYPE_UNKNOWN = -1,  ///< Usually treated as AVMEDIA_TYPE_DATA
    AVMEDIA_TYPE_VIDEO,
    AVMEDIA_TYPE_AUDIO,
    AVMEDIA_TYPE_DATA,          ///< Opaque data information usually continuous
    AVMEDIA_TYPE_SUBTITLE,
    AVMEDIA_TYPE_ATTACHMENT,    ///< Opaque data information usually sparse
    AVMEDIA_TYPE_NB,
}

// TODO: Define enums

AVColorPrimaries              :: distinct c.int
AVColorTransferCharacteristic :: distinct c.int
AVColorSpace                  :: distinct c.int
AVColorRange                  :: distinct c.int
AVChromaLocation              :: distinct c.int
AVFieldOrder                  :: distinct c.int
AVSampleFormat                :: distinct c.int
AVChannel                     :: distinct c.int
AVChannelOrder                :: distinct c.int
AVAudioServiceType            :: distinct c.int
AVPictureType                 :: distinct c.int
AVDiscard                     :: distinct c.int

AVRational :: struct {
	num: c.int, // Numerator
	den: c.int, // Denominator
}

AVProfile :: struct {
	profile: c.int,
	name:    cstring,
}

AVChannelCustom :: struct {
	id:     AVChannel,
	name:   [16]u8,
	opaque: rawptr,
}

AVChannelLayout :: struct {
	order:       AVChannelOrder,
	nb_channels: c.int,
	u:           struct #raw_union {
		mask: u64,
		_map: ^AVChannelCustom,
	},
	opaque: rawptr,
}

AVCodec :: struct {
	name:                  cstring,
	long_name:             cstring,
	type:                  AVMediaType,
	id:                    AVCodecID,
	capabilities:          c.int,
	max_lowres:            u8,
	supported_framerates:  [^]AVRational,
	pix_fmts:              [^]AVPixelFormat,
	supported_samplerates: [^]c.int,
	sample_fmts:           [^]AVSampleFormat,
	priv_class:            ^AVClass,
	profiles:              [^]AVProfile,
	wrapper_name:          cstring,
	ch_layouts:            ^AVChannelLayout,
}

AVError :: enum c.int {
	AVERROR_EAGAIN            = -11,
	AVERROR_EINVAL            = -22,
	AVERROR_EOF               = -transmute(c.int)(u32('E')  | (u32('O') << 8) | (u32('F') << 16) | (u32(' ') << 24)),
	AVERROR_ENCODER_NOT_FOUND = -transmute(c.int)(u32(0xF8) | (u32('E') << 8) | (u32('N') << 16) | (u32('C') << 24)),
	AVERROR_MUXER_NOT_FOUND   = -transmute(c.int)(u32(0xF8) | (u32('M') << 8) | (u32('U') << 16) | (u32('X') << 24)),
	AVERROR_INVALIDDATA       = -transmute(c.int)(u32('I')  | (u32('N') << 8) | (u32('D') << 16) | (u32('A') << 24)),
}

AVIOFlagBits :: enum {
	AVIO_FLAG_READ,
	AVIO_FLAG_WRITE,
	AVIO_FLAG_NONBLOCK = 4,
	AVIO_FLAG_DIRECT   = 8,
}
AVIOFlags :: bit_set[AVIOFlagBits; c.int]

AVDictionaryFlagBits :: enum {
	AV_DICT_MATCH_CASE,
	AV_DICT_IGNORE_SUFFIX,
	AV_DICT_DONT_STRDUP_KEY,
	AV_DICT_DONT_STRDUP_VAL,
	AV_DICT_DONT_OVERWRITE,
	AV_DICT_APPEND,
	AV_DICT_MULTIKEY,
}
AVDictionaryFlags :: bit_set[AVDictionaryFlagBits; c.int]

SwsContext :: struct {}
SwsFilter :: struct {}

SwsFlagBits :: enum {
	SWS_FAST_BILINEAR,
	SWS_BILINEAR,
	SWS_BICUBIC,
	SWS_X,
	SWS_POINT,
	SWS_AREA,
	SWS_BICUBLIN,
	SWS_GAUSS,
	SWS_SINC,
	SWS_LANCZOS,
	SWS_SPLINE,
	SWS_PRINT_INFO = 13,
	SWS_FULL_CHR_H_INT,
	SWS_FULL_CHR_H_INP,
	SWS_DIRECT_BGR,
	SWS_ACCURATE_RND    = 19,
	SWS_BITEXACT,
	SWS_ERROR_DIFFUSION = 24,
}
SwsFlags :: bit_set[SwsFlagBits; c.int]

LossFlagBits :: enum {
	FF_LOSS_RESOLUTION,        /**< loss due to resolution change */
	FF_LOSS_DEPTH,             /**< loss due to color depth change */
	FF_LOSS_COLORSPACE,        /**< loss due to color space conversion */
	FF_LOSS_ALPHA,             /**< loss of alpha bits */
	FF_LOSS_COLORQUANT,        /**< loss due to color quantization */
	FF_LOSS_CHROMA,            /**< loss of chroma (e.g. RGB to gray conversion) */
	FF_LOSS_EXCESS_RESOLUTION, /**< loss due to unneeded extra resolution */
	FF_LOSS_EXCESS_DEPTH,      /**< loss due to unneeded extra color depth */
}
LossFlags :: bit_set[LossFlagBits; c.int]

// TODO: maybe mostly unify this logic and make it cross-platform eventually 
// to allow auto-downloading on other platforms like MacOS and Linux?
// This would ensure that the correct version of FFMPEG is available.
when ODIN_OS == .Windows {
    avcodec_find_encoder:            proc "c" (id: AVCodecID) -> ^AVCodec
    avcodec_find_encoder_by_name:    proc "c" (name: cstring) -> ^AVCodec
    avcodec_alloc_context3:          proc "c" (codec: ^AVCodec) -> ^AVCodecContext
	avcodec_free_context:            proc "c" (avctx: ^^AVCodecContext)
    avcodec_get_name:                proc "c" (id: AVCodecID) -> cstring
	av_packet_alloc:                 proc "c" () -> ^AVPacket
	av_packet_free:                  proc "c" (pkt: ^^AVPacket)
    av_opt_set:                      proc "c" (obj: rawptr, name: cstring, val: cstring, search_flags: c.int) -> AVError
    avcodec_open2:                   proc "c" (avctx: ^AVCodecContext, codec: ^AVCodec, options: ^^AVDictionary) -> AVError
	av_strerror:                     proc "c" (errnum: AVError, errbuf: [^]u8, errbuf_size: c.size_t) -> c.int
    av_frame_alloc:                  proc "c" () -> ^AVFrame
	av_frame_free:                   proc "c" (frame: ^^AVFrame)
    av_frame_get_buffer:             proc "c" (frame: ^AVFrame, align: c.int) -> AVError
    av_frame_make_writable:          proc "c" (frame: ^AVFrame) -> AVError
    avcodec_send_frame:              proc "c" (avctx: ^AVCodecContext, frame: ^AVFrame) -> AVError
    avcodec_receive_packet:          proc "c" (avctx: ^AVCodecContext, pkt: ^AVPacket) -> AVError
	av_packet_unref:                 proc "c" (pkt: ^AVPacket)
    avformat_alloc_output_context2:  proc "c" (ctx: ^^AVFormatContext, oformat: ^AVOutputFormat, format_name: cstring, filename: cstring) -> AVError
	avformat_free_context:           proc "c" (ctx: ^AVFormatContext)
    avio_open:                       proc "c" (s: ^^AVIOContext, url: cstring, flags: AVIOFlags) -> AVError
    avformat_write_header:           proc "c" (s: ^AVFormatContext, options: ^^AVDictionary) -> AVError
    av_compare_ts:                   proc "c" (ts_a: i64, tb_a: AVRational, ts_b: i64, tb_b: AVRational) -> c.int
	av_write_trailer:                proc "c" (s: ^AVFormatContext) -> AVError
	avio_closep:                     proc "c" (s: ^^AVIOContext) -> AVError
	av_dump_format:                  proc "c" (ic: ^AVFormatContext, index: c.int, url: cstring, is_output: c.int)
    av_dict_set:                     proc "c" (pm: ^^AVDictionary, key: cstring, value: cstring, flags: AVDictionaryFlags) -> AVError
    av_dict_copy:                    proc "c" (dst: ^^AVDictionary, src: ^AVDictionary, flags: AVDictionaryFlags) -> AVError
	av_dict_free:                    proc "c" (m: ^^AVDictionary)
    avcodec_parameters_from_context: proc "c" (par: ^AVCodecParameters, codec: ^AVCodecContext) -> AVError
    avformat_new_stream:             proc "c" (s: ^AVFormatContext, c: ^AVCodec) -> ^AVStream
	av_packet_rescale_ts:            proc "c" (pkt: ^AVPacket, tb_src: AVRational, tb_dst: AVRational)
    av_interleaved_write_frame:      proc "c" (s: ^AVFormatContext, pkt: ^AVPacket) -> AVError
    sws_getContext: proc "c" (
	 	srcW: c.int, srcH: c.int, srcFormat: AVPixelFormat,
	 	dstW: c.int, dstH: c.int, dstFormat: AVPixelFormat,
	 	flags: SwsFlags, 
	 	srcFilter: ^SwsFilter, dstFilter: ^SwsFilter,
	 	param: [^]f64,
	 ) -> ^SwsContext
	sws_scale: proc "c" (
	 	ctx: ^SwsContext, srcSlice: ^[AV_NUM_DATA_POINTERS][^]u8, 
	 	srcStride: ^[AV_NUM_DATA_POINTERS]c.int, srcSliceY: c.int, srcSliceH: c.int,
	 	dst: ^[AV_NUM_DATA_POINTERS][^]u8, dstStride: ^[AV_NUM_DATA_POINTERS]c.int,
	 ) -> c.int
	sws_freeContext:         proc "c" (swsContext: ^SwsContext)
    av_ts_make_time_string2: proc "c" (buf: [^]u8, ts: i64, tb: AVRational) -> cstring
	avcodec_find_best_pix_fmt_of_list: proc "c" (
    	pix_fmt_list: ^AVPixelFormat, src_pix_fmt: AVPixelFormat,
    	has_alpha: c.int, loss_ptr: ^LossFlags,
    ) -> AVPixelFormat

	ffmpeg_downloaded_license_name :: "FFMPEG-DOWNLOADED-LICENSE"

	/*
	 * To comply with LGPL, we are writing our own binding code on Windows, 
	 * as the wrapper libraries could be considered "object code" from a GPL licensed product.
	 *
	 * On top of that we also support an auto-downloader for FFMPEG,
	 * which allows us to keep the repository mostly clean of (especially big) binaries, as well as just allowing auto-updating
	 * and ease-of-use on Windows. Plus, there could also be use of the animation library
	 * without encoding video, which perhaps could just avoid download FFMPEG at all if you don't
	 * end up using it during the use of the library.
	 *  
	 * TODO: Is auto-downloading GPL versions of FFMPEG against the license?
	 * If it is, it's relatively easy to just allow users to download it themselves if they desire.
	 * Just obviously they CANNOT distribute the binaries with the GPL FFMPEG.
	 */
	@(private, require_results)
	init_dll :: proc() -> bool {
		fmt.println("\x1b[35m[INITIALIZING DLLS]\x1b[0m")
	
		exe_dir: string
		{
			buf: [windows.MAX_PATH_WIDE]u16
			windows.GetModuleFileNameW(nil, &buf[0], len(buf))
			
			u8buf: [windows.MAX_PATH_WIDE]u8
			n := utf16.decode_to_utf8(u8buf[:], buf[:])
			exe_dir = filepath.dir(string(u8buf[:n]))
		}
		defer delete(exe_dir)

		avcodec_filename :: "avcodec-61.dll"
		avutil_filename :: "avutil-59.dll"
		avformat_filename :: "avformat-61.dll"
		swscale_filename :: "swscale-8.dll"
		swresample_filename :: "swresample-5.dll"

		couldnt_find_ffmpeg: bool
		
		avcodec_path := filepath.join({ exe_dir, avcodec_filename })
		defer delete(avcodec_path)
		if !os.is_file(avcodec_path) {
			couldnt_find_ffmpeg = true
		}

		avutil_path := filepath.join({ exe_dir, avutil_filename })
		defer delete(avutil_path)
		if !os.is_file(avutil_path) {
			couldnt_find_ffmpeg = true
		} 

		avformat_path := filepath.join({ exe_dir, avformat_filename })
		defer delete(avformat_path)
		if !os.is_file(avformat_path) {
			couldnt_find_ffmpeg = true
		}

		swscale_path := filepath.join({ exe_dir, swscale_filename })
		defer delete(swscale_path)
		if !os.is_file(swscale_path) {
			couldnt_find_ffmpeg = true
		}

		swresample_path := filepath.join({ exe_dir, swresample_filename })
		defer delete(swresample_path)
		if !os.is_file(swresample_path) {
			couldnt_find_ffmpeg = true
		}

		default_ffmpeg_url :: "https://github.com/BtbN/FFmpeg-Builds/releases/download/autobuild-2024-04-28-12-48/ffmpeg-N-115020-ga9a69a5a31-win64-lgpl-shared.zip"
		
		if couldnt_find_ffmpeg {
			if ok := download_ffmpeg(
				default_ffmpeg_url,
				{ avcodec_filename, avcodec_path, {.ZIP_FL_NODIR} },
				{ avutil_filename, avutil_path, {.ZIP_FL_NODIR} },
				{ avformat_filename, avformat_path, {.ZIP_FL_NODIR} },
				{ swscale_filename, swscale_path, {.ZIP_FL_NODIR} },
				{ swresample_filename, swresample_path, {.ZIP_FL_NODIR} },
				{ "LICENSE.txt", ffmpeg_downloaded_license_name, {.ZIP_FL_NODIR} },
			); !ok {
				return false
			}
		} else {
			fmt.println("\x1b[92m[SUCCESS]\x1b[0m")
			fmt.printfln(" - Found \x1b[35mavcodec\x1b[0m at \x1b[92m'%s'\x1b[0m",  avcodec_path)
			fmt.printfln(" - Found \x1b[35mavutil\x1b[0m at \x1b[92m'%s'\x1b[0m",   avutil_path)
			fmt.printfln(" - Found \x1b[35mavformat\x1b[0m at \x1b[92m'%s'\x1b[0m", avformat_path)
			fmt.printfln(" - Found \x1b[35mswscale\x1b[0m at \x1b[92m'%s'\x1b[0m",  swscale_path)
		}

		load_symbol :: #force_inline proc(lib: dynlib.Library, symbol: string, func: ^$T) -> bool {
			rawp, found := dynlib.symbol_address(lib, symbol)
			func^ = cast(T)rawp
			if !found do fmt.eprintfln("\x1b[91mERROR:\x1b[0m Couldn't load symbol '%s'", symbol)
			return found
		}

		ok: bool
		
		avcodec: dynlib.Library
		avcodec, ok = dynlib.load_library(avcodec_path)
		if !ok {
			fmt.eprintfln("\x1b[91mERROR:\x1b[0m Couldn't load \x1b[35mavcodec\x1b[0m, %s '%s'", avcodec_path, dynlib.last_error())
			return false
		}

		fmt.println("\x1b[35m[avcodec]\x1b[0m")
		ok &&= load_symbol(avcodec, "avcodec_find_encoder",              &avcodec_find_encoder)
		ok &&= load_symbol(avcodec, "avcodec_find_encoder_by_name",      &avcodec_find_encoder_by_name)
		ok &&= load_symbol(avcodec, "avcodec_alloc_context3",            &avcodec_alloc_context3)
		ok &&= load_symbol(avcodec, "avcodec_free_context",              &avcodec_free_context)
		ok &&= load_symbol(avcodec, "avcodec_get_name",                  &avcodec_get_name)
		ok &&= load_symbol(avcodec, "avcodec_open2",                     &avcodec_open2)
		ok &&= load_symbol(avcodec, "avcodec_send_frame",                &avcodec_send_frame)
		ok &&= load_symbol(avcodec, "avcodec_parameters_from_context",   &avcodec_parameters_from_context)
		ok &&= load_symbol(avcodec, "avcodec_receive_packet",            &avcodec_receive_packet)
		ok &&= load_symbol(avcodec, "avcodec_find_best_pix_fmt_of_list", &avcodec_find_best_pix_fmt_of_list)
		ok &&= load_symbol(avcodec, "av_packet_alloc",                   &av_packet_alloc)
		ok &&= load_symbol(avcodec, "av_packet_free",                    &av_packet_free)
		ok &&= load_symbol(avcodec, "av_packet_unref",                   &av_packet_unref)
		ok &&= load_symbol(avcodec, "av_packet_rescale_ts",              &av_packet_rescale_ts)
		if !ok {
			return false
		}
		fmt.println(" - \x1b[92mLoaded symbols\x1b[0m")

		avutil: dynlib.Library
		avutil, ok = dynlib.load_library(avutil_path)
		if !ok {
			fmt.eprintfln("\x1b[91mERROR:\x1b[0m Couldn't load \x1b[35mavutil\x1b[0m, '%s'", dynlib.last_error())
			return false
		}

		fmt.println("\x1b[35m[avutil]\x1b[0m")
		ok &&= load_symbol(avutil, "av_opt_set",              &av_opt_set)
		ok &&= load_symbol(avutil, "av_strerror",             &av_strerror)
		ok &&= load_symbol(avutil, "av_frame_alloc",          &av_frame_alloc)
		ok &&= load_symbol(avutil, "av_frame_free",           &av_frame_free)
		ok &&= load_symbol(avutil, "av_frame_get_buffer",     &av_frame_get_buffer)
		ok &&= load_symbol(avutil, "av_frame_make_writable",  &av_frame_make_writable)
		ok &&= load_symbol(avutil, "av_compare_ts",           &av_compare_ts)
		ok &&= load_symbol(avutil, "av_dict_set",             &av_dict_set)
		ok &&= load_symbol(avutil, "av_dict_copy",            &av_dict_copy)
		ok &&= load_symbol(avutil, "av_dict_free",            &av_dict_free)
		ok &&= load_symbol(avutil, "av_ts_make_time_string2", &av_ts_make_time_string2)
		if !ok {
			return false
		}
		fmt.println(" - \x1b[92mLoaded symbols\x1b[0m")

		avformat: dynlib.Library
		avformat, ok = dynlib.load_library(avformat_path)
		if !ok {
			fmt.eprintfln("\x1b[91mERROR:\x1b[0m Couldn't load \x1b[35mavformat\x1b[0m, '%s'", dynlib.last_error())
			return false
		}
		
		fmt.println("\x1b[35m[avformat]\x1b[0m")
		ok &&= load_symbol(avformat, "avformat_alloc_output_context2", &avformat_alloc_output_context2)
		ok &&= load_symbol(avformat, "avformat_free_context",          &avformat_free_context)
		ok &&= load_symbol(avformat, "avio_open",                      &avio_open)
		ok &&= load_symbol(avformat, "avformat_write_header",          &avformat_write_header)
		ok &&= load_symbol(avformat, "av_write_trailer",               &av_write_trailer)
		ok &&= load_symbol(avformat, "avio_closep",                    &avio_closep)
		ok &&= load_symbol(avformat, "av_dump_format",                 &av_dump_format)
		ok &&= load_symbol(avformat, "avformat_new_stream",            &avformat_new_stream)
		ok &&= load_symbol(avformat, "av_interleaved_write_frame",     &av_interleaved_write_frame)
		if !ok {
			return false
		}
		fmt.println(" - \x1b[92mLoaded symbols\x1b[0m")
		
		swscale: dynlib.Library
		swscale, ok = dynlib.load_library(swscale_path)
		if !ok {
			fmt.eprintfln("\x1b[91mERROR:\x1b[0m Couldn't load \x1b[35mswscale\x1b[0m, '%s'", dynlib.last_error())
		}

		fmt.println("\x1b[35m[swscale]\x1b[0m")
		ok &&= load_symbol(swscale, "sws_getContext",  &sws_getContext)
		ok &&= load_symbol(swscale, "sws_scale",       &sws_scale)
		ok &&= load_symbol(swscale, "sws_freeContext", &sws_freeContext)
		if !ok {
			return false
		}
		fmt.println(" - \x1b[92mLoaded symbols\x1b[0m")
		return true
	}
	
	// Download FFMPEG using libcurl and extract the specified files
	@(private="file")
	download_ffmpeg :: proc(
		ffmpeg_url: cstring,
		files_to_extract: ..struct {
			zip_path: cstring,
			output_path: string,
			flags: ZipFlags,
		},
	) -> bool {
		fmt.println("\x1b[95m[DOWNLOADING FFMPEG]\x1b[0m")
		fmt.printfln(" - Downloading from %s", ffmpeg_url)
		if err := curl_global_init(CURL_GLOBAL_DEFAULT); err != .CURLE_OK {
			fmt.eprintfln("\x1b[91mERROR:\x1b[0m Couldn't globally init libcurl, %s", curl_easy_strerror(err))
			return false
		}
		defer curl_global_cleanup()

		curl := curl_easy_init()
		if curl == nil {
			fmt.eprintln("\x1b[91mERROR:\x1b[0m Couldn't initialize libcurl")
			return false
		}
		defer curl_easy_cleanup(curl)

		file_data := make([dynamic]u8)
		defer delete(file_data)
		reserve(&file_data, mem.Megabyte * 60) // reserve 60MBs of space, which is about the expected size.
		
		curl_easy_setopt(curl, .CURLOPT_URL, cstring(ffmpeg_url))
		curl_easy_setopt(curl, .CURLOPT_NOPROGRESS, c.long(0))
		curl_easy_setopt(curl, .CURLOPT_FOLLOWLOCATION, c.long(1))
		curl_easy_setopt(curl, .CURLOPT_WRITEDATA, &file_data)
		curl_easy_setopt(curl, .CURLOPT_WRITEFUNCTION, curl_write_data)

		if err := curl_easy_perform(curl); err != nil {
			fmt.eprintfln("\x1b[91mERROR:\x1b[0m Failed to download FFMPEG, %s", curl_easy_strerror(err))
			return false
		}
		
		zip_err: ZipError
		defer zip_error_fini(&zip_err)
		
		zip_src := zip_source_buffer_create(raw_data(file_data), u64(len(file_data)), 0, &zip_err)
		if zip_err.zip_err != .ZIP_ER_OK {
			fmt.eprintfln("\x1b[91mERROR:\x1b[0m Couldn't create Zip source, %s", zip_error_strerror(&zip_err))
			return false
		}

		zip := zip_open_from_source(zip_src, {.ZIP_RDONLY}, &zip_err)
		if zip_err.zip_err != .ZIP_ER_OK {
			fmt.eprintfln("\x1b[91mERROR:\x1b[0m Couldn't open Zip, %s", zip_error_strerror(&zip_err))
			return false
		}
		defer zip_close(zip)

		for file in files_to_extract {
			extract_file_from_zip(zip, file.zip_path, file.output_path, file.flags) or_return
		}
		fmt.println(" - \x1b[92mExtracted all DLLs\x1b[0m")
		fmt.println("\x1b[33;1mNOTICE: PLEASE READ THE " + ffmpeg_downloaded_license_name + " FILE; WHICH HAS APPEARED IN YOUR CURRENT DIRECTORY, FOR ANY LICENSING INFORMATION. WE (THE SOFTWARE DEVELOPERS) ACCEPT NO LEGAL LIABILITY FOR ANY LICENSE INFRACTION CAUSED BY THIRD-PARTIES USING OUR SOFTWARE; WHICH ADHERES TO THE TERMS OF THE LGPL LICENSE OF FFMPEG WHICH APPLIES TO SOFTWARE THAT IS ONLY BINDING DYNAMICALLY TO THE API INTERFACE, AND IS NOT STATICALLY LINKING WITH ANY \"OBJECT CODE\". SEE THE LGPL AND GPL LICENSES DISTRIBUTED WITH THE PRIMARY COMMAND-LINE EXECUTABLE, OR FROM THESE LINKS: https://www.gnu.org/licenses/lgpl-3.0.en.html, https://www.gnu.org/licenses/gpl-3.0.en.html, FOR MORE DETAILS.\x1b[0m")
		fmt.println("FFMPEG Source Code can be found here: https://git.ffmpeg.org/ffmpeg.git")
		return true
	}

	@(private="file")
	curl_write_data :: proc "c" (ptr: [^]u8, obj_size, count: c.size_t, file_data: ^[dynamic]u8) -> c.size_t {
		context = runtime.default_context()
		
		byte_count := int(obj_size * count)
		start := len(file_data)
		resize(file_data, start + byte_count)

		dst_slice := file_data[start:][:byte_count]
		src_slice := ptr[:byte_count]
		
		mem.copy_non_overlapping(raw_data(dst_slice), raw_data(src_slice), byte_count)
		return c.size_t(byte_count)
	}

	@(private="file")
	extract_file_from_zip :: proc(zip: ^Zip, file_path: cstring, output_file_path: string, flags: ZipFlags) -> bool {
		zip_file_index: u64
		if idx := zip_name_locate(zip, file_path, flags); idx < 0 {
			base_file_name := slashpath.base(string(file_path))
			defer delete(base_file_name)
			
			fmt.eprintfln("\x1b[91mERROR:\x1b[0m Failed to locate Zip path for '%s', %s", base_file_name, zip_strerror(zip))
			return false
		} else {
			zip_file_index = u64(idx)
		}

		zip_file_stat: ZipStat
		if err := zip_stat_index(zip, zip_file_index, {}, &zip_file_stat); err != .ZIP_ER_OK {
			zip_err: ZipError
			zip_error_init_with_code(&zip_err, err)
			defer zip_error_fini(&zip_err)
		
			base_file_name := slashpath.base(string(file_path))
			defer delete(base_file_name)
		
			fmt.eprintfln("\x1b[91mERROR:\x1b[0m Failed to get Zip file information for '%s', %s", base_file_name, zip_error_strerror(&zip_err))
			return false
		}

		if .ZIP_STAT_SIZE not_in zip_file_stat.valid {
			base_file_name := slashpath.base(string(file_path))
			defer delete(base_file_name)
			
			fmt.eprintfln("\x1b[91mERROR:\x1b[0m Failed to get Zip file size for '%s'", base_file_name)
			return false
		}

		file_size := zip_file_stat.size
		file_data := make([dynamic]u8, int(file_size))
		defer delete(file_data)

		zip_file := zip_fopen_index(zip, zip_file_index, {})
		if zip_file == nil {
			base_file_name := slashpath.base(string(file_path))
			defer delete(base_file_name)

			fmt.eprintfln("\x1b[91mERROR:\x1b[0m Failed to open Zip file '%s' for reading, %s", base_file_name, zip_strerror(zip))
			return false
		}
		defer zip_fclose(zip_file)

		if written := zip_fread(zip_file, raw_data(file_data), file_size); written < 0 {
			base_file_name := slashpath.base(string(file_path))
			defer delete(base_file_name)
			
			fmt.eprintfln("\x1b[91mERROR:\x1b[0m Failed to read Zip file '%s'", base_file_name)
			return false
		} else if written > i64(file_size) {
			panic("\x1b[91mERROR:\x1b[0m POTENTIAL BUFFER OVERFLOW THIS SHOULD NOT HAPPEN, zip_fread said it wrote more than the size of the buffer! Please report / investigate")
		} else if written < i64(file_size) {
			base_file_name := slashpath.base(string(file_path))
			defer delete(base_file_name)
			
			fmt.printfln("\x1b[93mWARNING:\x1b[0m zip_fread wrote %d bytes, less than the supposed total size of the file for '%s' (%d bytes). This could be a bug.", written, base_file_name, file_size)
		}

		if !os.write_entire_file(output_file_path, file_data[:]) {
			base_file_name := slashpath.base(string(file_path))
			defer delete(base_file_name)
			
			fmt.eprintfln("\x1b[91mERROR:\x1b[0m Failed to write output file for '%s'", base_file_name)
			return false
		}
		return true
	}
} else { // when ODIN_OS == .Windows 
	foreign import libav {"system:avcodec", "system:avutil", "system:avformat", "system:swscale"}
	
	@(private, require_results)
	init_dll :: proc() -> bool {
		// Not necessary when not on Windows
	}

	@(default_calling_convention = "c")
	foreign libav {
	    avcodec_find_encoder            :: proc(id: AVCodecID) -> ^AVCodec ---
	    avcodec_find_encoder_by_name    :: proc(name: cstring) -> ^AVCodec ---
	    avcodec_alloc_context3          :: proc(codec: ^AVCodec) -> ^AVCodecContext ---
		avcodec_free_context            :: proc(avctx: ^^AVCodecContext) ---
	    avcodec_get_name                :: proc(id: AVCodecID) -> cstring ---
		av_packet_alloc                 :: proc() -> ^AVPacket ---
		av_packet_free                  :: proc(pkt: ^^AVPacket) ---
	    av_opt_set                      :: proc(obj: rawptr, name: cstring, val: cstring, search_flags: c.int) -> AVError ---
	    avcodec_open2                   :: proc(avctx: ^AVCodecContext, codec: ^AVCodec, options: ^^AVDictionary) -> AVError ---
		av_strerror                     :: proc(errnum: AVError, errbuf: [^]u8, errbuf_size: c.size_t) -> c.int ---
	    av_frame_alloc                  :: proc() -> ^AVFrame ---
		av_frame_free                   :: proc(frame: ^^AVFrame) ---
	    av_frame_get_buffer             :: proc(frame: ^AVFrame, align: c.int) -> AVError ---
	    av_frame_make_writable          :: proc(frame: ^AVFrame) -> AVError ---
	    avcodec_send_frame              :: proc(avctx: ^AVCodecContext, frame: ^AVFrame) -> AVError ---
	    avcodec_receive_packet          :: proc(avctx: ^AVCodecContext, pkt: ^AVPacket) -> AVError ---
		av_packet_unref                 :: proc(pkt: ^AVPacket) ---
	    avformat_alloc_output_context2  :: proc(ctx: ^^AVFormatContext, oformat: ^AVOutputFormat, format_name: cstring, filename: cstring) -> AVError ---
		avformat_free_context           :: proc(ctx: ^AVFormatContext) ---
	    avio_open                       :: proc(s: ^^AVIOContext, url: cstring, flags: AVIOFlags) -> AVError ---
	    avformat_write_header           :: proc(s: ^AVFormatContext, options: ^^AVDictionary) -> AVError ---
	    av_compare_ts                   :: proc(ts_a: i64, tb_a: AVRational, ts_b: i64, tb_b: AVRational) -> c.int ---
		av_write_trailer                :: proc(s: ^AVFormatContext) -> AVError ---
		avio_closep                     :: proc(s: ^^AVIOContext) -> AVError ---
		av_dump_format                  :: proc(ic: ^AVFormatContext, index: c.int, url: cstring, is_output: c.int) ---
	    av_dict_set                     :: proc(pm: ^^AVDictionary, key: cstring, value: cstring, flags: AVDictionaryFlags) -> AVError ---
	    av_dict_copy                    :: proc(dst: ^^AVDictionary, src: ^AVDictionary, flags: AVDictionaryFlags) -> AVError ---
		av_dict_free                    :: proc(m: ^^AVDictionary) ---
	    avcodec_parameters_from_context :: proc(par: ^AVCodecParameters, codec: ^AVCodecContext) -> AVError ---
	    avformat_new_stream             :: proc(s: ^AVFormatContext, c: ^AVCodec) -> ^AVStream ---
		av_packet_rescale_ts            :: proc(pkt: ^AVPacket, tb_src: AVRational, tb_dst: AVRational) ---
	    av_interleaved_write_frame      :: proc(s: ^AVFormatContext, pkt: ^AVPacket) -> AVError ---
	    sws_getContext :: proc(
		 	srcW: c.int, srcH: c.int, srcFormat: AVPixelFormat,
		 	dstW: c.int, dstH: c.int, dstFormat: AVPixelFormat,
		 	flags: SwsFlags, 
		 	srcFilter: ^SwsFilter, dstFilter: ^SwsFilter,
		 	param: [^]f64,
		 ) -> ^SwsContext ---
		sws_scale :: proc(
		 	ctx: ^SwsContext, srcSlice: [^][^]u8, 
		 	srcStride: [^][^]c.int, srcSliceY: c.int, srcSliceH: c.int,
		 	dst: [^][^]u8, dstStride: [^]c.int,
		 ) -> c.int ---
		sws_freeContext         :: proc(swsContext: ^SwsContext) ---
	    av_ts_make_time_string2 :: proc(buf: [^]u8, ts: i64, tb: AVRational) -> cstring ---
	    avcodec_find_best_pix_fmt_of_list :: proc(
	    	pix_fmt_list: ^AVPixelFormat, src_pix_fmt: AVPixelFormat,
	    	has_alpha: c.int, loss_ptr: ^LossFlags,
	    ) -> AVPixelFormat ---
	}
}

AV_ERROR_MAX_STRING_SIZE :: 64

av_make_error_string :: #force_inline proc(errbuf: []u8, errnum: AVError) -> cstring {
	av_strerror(errnum, raw_data(errbuf), len(errbuf))
	return cstring(raw_data(errbuf))
}

av_err2str :: #force_inline proc(errnum: AVError) -> cstring {
	@(thread_local)
	buf: [AV_ERROR_MAX_STRING_SIZE]u8
	buf = {}
	return av_make_error_string(buf[:], errnum)
}

// We can hijack libavcodecs "av_strerror" to convert a lot of Errnos into human-readable strings.
av_errno2str :: #force_inline proc(err: os.Errno) -> cstring {
	return av_err2str(AVError(-c.int(err)))
}

AV_NOPTS_VALUE :: transmute(i64)(u64(0x8000000000000000))

AV_TS_MAX_STRING_SIZE :: 32

av_ts_make_string :: #force_inline proc(buf: []u8, ts: i64) -> cstring {
	if ts == AV_NOPTS_VALUE {
		fmt.bprint(buf, "NOPTS")
	} else {
		fmt.bprintf(buf, "%d", ts)
	}
	return cstring(raw_data(buf))
}

av_ts2str ::#force_inline proc(ts: i64) -> cstring {
	@(thread_local)
	buf: [AV_TS_MAX_STRING_SIZE]u8
	buf = {}
	return av_ts_make_string(buf[:], ts)
}

av_ts_make_time_string :: #force_inline proc(buf: []u8, ts: i64, tb: ^AVRational) -> cstring {
	assert(len(buf) >= AV_TS_MAX_STRING_SIZE)
	return av_ts_make_time_string2(raw_data(buf), ts, tb^)
}

av_ts2timestr :: #force_inline proc(ts: i64, tb: ^AVRational) -> cstring {
	@(thread_local)
	buf: [AV_TS_MAX_STRING_SIZE]u8
	buf = {}
	return av_ts_make_time_string(buf[:], ts, tb)
}

