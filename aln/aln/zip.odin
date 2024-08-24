//+private
package aln

import "core:c"
import "core:c/libc"
import "core:os"

when ODIN_OS == .Windows {
	foreign import libzip {
		"zip/zip.lib",
		"zip/bz2.lib",
		"zip/zstd.lib",
		"zip/zlib.lib",
		"zip/lzma.lib",
	}
}

ZipErrorCode :: enum c.int {
	ZIP_ER_OK              = 0,  /* N No error */
	ZIP_ER_MULTIDISK       = 1,  /* N Multi-disk zip archives not supported */
	ZIP_ER_RENAME          = 2,  /* S Renaming temporary file failed */
	ZIP_ER_CLOSE           = 3,  /* S Closing zip archive failed */
	ZIP_ER_SEEK            = 4,  /* S Seek error */
	ZIP_ER_READ            = 5,  /* S Read error */
	ZIP_ER_WRITE           = 6,  /* S Write error */
	ZIP_ER_CRC             = 7,  /* N CRC error */
	ZIP_ER_ZIPCLOSED       = 8,  /* N Containing zip archive was closed */
	ZIP_ER_NOENT           = 9,  /* N No such file */
	ZIP_ER_EXISTS          = 10, /* N File already exists */
	ZIP_ER_OPEN            = 11, /* S Can't open file */
	ZIP_ER_TMPOPEN         = 12, /* S Failure to create temporary file */
	ZIP_ER_ZLIB            = 13, /* Z Zlib error */
	ZIP_ER_MEMORY          = 14, /* N Malloc failure */
	ZIP_ER_CHANGED         = 15, /* N Entry has been changed */
	ZIP_ER_COMPNOTSUPP     = 16, /* N Compression method not supported */
	ZIP_ER_EOF             = 17, /* N Premature end of file */
	ZIP_ER_INVAL           = 18, /* N Invalid argument */
	ZIP_ER_NOZIP           = 19, /* N Not a zip archive */
	ZIP_ER_INTERNAL        = 20, /* N Internal error */
	ZIP_ER_INCONS          = 21, /* L Zip archive inconsistent */
	ZIP_ER_REMOVE          = 22, /* S Can't remove file */
	ZIP_ER_DELETED         = 23, /* N Entry has been deleted */
	ZIP_ER_ENCRNOTSUPP     = 24, /* N Encryption method not supported */
	ZIP_ER_RDONLY          = 25, /* N Read-only archive */
	ZIP_ER_NOPASSWD        = 26, /* N No password provided */
	ZIP_ER_WRONGPASSWD     = 27, /* N Wrong password provided */
	ZIP_ER_OPNOTSUPP       = 28, /* N Operation not supported */
	ZIP_ER_INUSE           = 29, /* N Resource still in use */
	ZIP_ER_TELL            = 30, /* S Tell error */
	ZIP_ER_COMPRESSED_DATA = 31, /* N Compressed data invalid */
	ZIP_ER_CANCELLED       = 32, /* N Operation cancelled */
	ZIP_ER_DATA_LENGTH     = 33, /* N Unexpected length of data */
	ZIP_ER_NOT_ALLOWED     = 34, /* N Not allowed in torrentzip */
}

ZipError :: struct {
	zip_err: ZipErrorCode,
	sys_err: c.int,
	str:     cstring,
}

Zip :: struct {}
ZipSource :: struct {}
ZipFile :: struct {}

ZipOpenFlagBits :: enum {
	ZIP_CREATE,
	ZIP_EXCL,
	ZIP_CHECKCONS,
	ZIP_TRUNCATE,
	ZIP_RDONLY,
}
ZipOpenFlags :: bit_set[ZipOpenFlagBits; c.int]

ZipFlagBits :: enum {
	ZIP_FL_NOCASE,
	ZIP_FL_NODIR,
	ZIP_FL_COMPRESSED,
	ZIP_FL_UNCHANGED,
	ZIP_FL_ENCRYPTED = 6,
	ZIP_FL_ENC_RAW,
	ZIP_FL_ENC_STRICT,
	ZIP_FL_LOCAL,
	ZIP_FL_CENTRAL,
	ZIP_FL_ENC_UTF_8,
	ZIP_FL_ENC_CP437,
	ZIP_FL_OVERWRITE,
}
ZipFlags :: bit_set[ZipFlagBits; u32]
ZIP_FL_ENC_GUESS :: ZipFlags {}

ZipStatValidFlagBits :: enum {
	ZIP_STAT_NAME,
	ZIP_STAT_INDEX,
	ZIP_STAT_SIZE,
	ZIP_STAT_COMP_SIZE,
	ZIP_STAT_MTIME,
	ZIP_STAT_CRC,
	ZIP_STAT_COMP_METHOD,
	ZIP_STAT_ENCRYPTION_METHOD,
	ZIP_STAT_FLAGS,
}
ZipStatValidFlags :: bit_set[ZipStatValidFlagBits; u64]

ZipStat :: struct {
	valid:             ZipStatValidFlags,
	name:              cstring,
	index:             u64,
	size:              u64,
	comp_size:         u64,
	mtime:             libc.time_t,
	crc:               u32,
	comp_method:       u16,
	encryption_method: u16,
	flags:             u32, // reserved for future use
}

@(default_calling_convention="c")
foreign libzip {
	zip_source_buffer_create :: proc(
		data: rawptr, len: u64, 
		freep: c.int, 
		error: ^ZipError,
	) -> ^ZipSource ---
	zip_open_from_source :: proc(
		zs: ^ZipSource, flags: ZipOpenFlags, 
		ze: ^ZipError,
	) -> ^Zip ---
	zip_close                :: proc(archive: ^Zip) -> c.int ---
	zip_get_error            :: proc(archive: ^Zip) -> ^ZipError ---
	zip_strerror             :: proc(archive: ^Zip) -> cstring ---
	zip_error_strerror       :: proc(ze: ^ZipError) -> cstring ---
	zip_fopen                :: proc(archive: ^Zip, fname: cstring, flags: ZipFlags) -> ^ZipFile ---
	zip_fopen_index          :: proc(archive: ^Zip, index: u64, flags: ZipFlags) -> ^ZipFile ---
	zip_fread                :: proc(file: ^ZipFile, buf: rawptr, nbytes: u64) -> i64 ---
	zip_file_get_error       :: proc(zf: ^ZipFile) -> ^ZipError ---
	zip_file_strerror        :: proc(file: ^ZipFile) -> cstring ---
	zip_fclose               :: proc(zf: ^ZipFile) -> ZipErrorCode ---
	zip_error_init           :: proc(ze: ^ZipError) ---
	zip_error_init_with_code :: proc(error: ^ZipError, ze: ZipErrorCode) ---
	zip_error_fini           :: proc(error: ^ZipError) ---
	zip_stat :: proc(
		archive: ^Zip, fname: cstring, 
		flags: ZipFlags, sb: ^ZipStat,
	) -> ZipErrorCode ---
	zip_stat_index :: proc(
		archive: ^Zip, index: u64,
		flags: ZipFlags, sb: ^ZipStat,
	) -> ZipErrorCode ---
	zip_name_locate :: proc(archive: ^Zip, fname: cstring, flags: ZipFlags) -> i64 ---
}

