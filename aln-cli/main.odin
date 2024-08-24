package main

import "aln:aln"

import "core:c"
import "core:fmt"
import "core:os"

test_encode_write_yuv_image :: proc(
	frame_data: [aln.ENCODER_MAX_DATA_BUFFERS][^]u8, frame_linesize: [aln.ENCODER_MAX_DATA_BUFFERS]i32, 
	width, height, frame_index, frame_rate: uint,
) -> bool {
	i := frame_index

	// Y channel
	for y in 0 ..< height {
		for x in 0 ..< width {
			frame_data[0][y * uint(frame_linesize[0]) + x] = u8(x + y + i * 3)
		}
	}

	// Cb and Cr channels
	for y in 0 ..< height / 2 {
		for x in 0 ..< width / 2 {
			frame_data[1][y * uint(frame_linesize[1]) + x] = u8(128 + y + i * 2)
			frame_data[2][y * uint(frame_linesize[2]) + x] = u8(64 + x + i * 5)
		}
	}
	return true
}

test_encode_is_frame :: proc(frame_index, frame_rate: uint) -> bool {
	return frame_index <= frame_rate * 10 // Lasts for 10 seconds
}

main :: proc() {
	err := run()
	if err != 0 do os.exit(err)
}

run :: proc() -> int {
	aln.encode("test.mp4", 
		width = 352, height = 288, 
		frame_rate = 25, bit_rate = 40000000, 
		write_frame = test_encode_write_yuv_image, is_frame = test_encode_is_frame, 
		profile = .UNKNOWN,
		encoder_id = .NONE,
		src_pixel_format = .YUV420P, needs_alpha = false)
	return 0
}

