package aln

import "core:c"

// Copied from libavcodec/codec_id.h
@(private)
AVCodecID :: enum c.int {
	AV_CODEC_ID_NONE,

	/* video codecs */
	AV_CODEC_ID_MPEG1VIDEO,
	AV_CODEC_ID_MPEG2VIDEO, ///< preferred ID for MPEG-1/2 video decoding
	AV_CODEC_ID_H261,
	AV_CODEC_ID_H263,
	AV_CODEC_ID_RV10,
	AV_CODEC_ID_RV20,
	AV_CODEC_ID_MJPEG,
	AV_CODEC_ID_MJPEGB,
	AV_CODEC_ID_LJPEG,
	AV_CODEC_ID_SP5X,
	AV_CODEC_ID_JPEGLS,
	AV_CODEC_ID_MPEG4,
	AV_CODEC_ID_RAWVIDEO,
	AV_CODEC_ID_MSMPEG4V1,
	AV_CODEC_ID_MSMPEG4V2,
	AV_CODEC_ID_MSMPEG4V3,
	AV_CODEC_ID_WMV1,
	AV_CODEC_ID_WMV2,
	AV_CODEC_ID_H263P,
	AV_CODEC_ID_H263I,
	AV_CODEC_ID_FLV1,
	AV_CODEC_ID_SVQ1,
	AV_CODEC_ID_SVQ3,
	AV_CODEC_ID_DVVIDEO,
	AV_CODEC_ID_HUFFYUV,
	AV_CODEC_ID_CYUV,
	AV_CODEC_ID_H264,
	AV_CODEC_ID_INDEO3,
	AV_CODEC_ID_VP3,
	AV_CODEC_ID_THEORA,
	AV_CODEC_ID_ASV1,
	AV_CODEC_ID_ASV2,
	AV_CODEC_ID_FFV1,
	AV_CODEC_ID_4XM,
	AV_CODEC_ID_VCR1,
	AV_CODEC_ID_CLJR,
	AV_CODEC_ID_MDEC,
	AV_CODEC_ID_ROQ,
	AV_CODEC_ID_INTERPLAY_VIDEO,
	AV_CODEC_ID_XAN_WC3,
	AV_CODEC_ID_XAN_WC4,
	AV_CODEC_ID_RPZA,
	AV_CODEC_ID_CINEPAK,
	AV_CODEC_ID_WS_VQA,
	AV_CODEC_ID_MSRLE,
	AV_CODEC_ID_MSVIDEO1,
	AV_CODEC_ID_IDCIN,
	AV_CODEC_ID_8BPS,
	AV_CODEC_ID_SMC,
	AV_CODEC_ID_FLIC,
	AV_CODEC_ID_TRUEMOTION1,
	AV_CODEC_ID_VMDVIDEO,
	AV_CODEC_ID_MSZH,
	AV_CODEC_ID_ZLIB,
	AV_CODEC_ID_QTRLE,
	AV_CODEC_ID_TSCC,
	AV_CODEC_ID_ULTI,
	AV_CODEC_ID_QDRAW,
	AV_CODEC_ID_VIXL,
	AV_CODEC_ID_QPEG,
	AV_CODEC_ID_PNG,
	AV_CODEC_ID_PPM,
	AV_CODEC_ID_PBM,
	AV_CODEC_ID_PGM,
	AV_CODEC_ID_PGMYUV,
	AV_CODEC_ID_PAM,
	AV_CODEC_ID_FFVHUFF,
	AV_CODEC_ID_RV30,
	AV_CODEC_ID_RV40,
	AV_CODEC_ID_VC1,
	AV_CODEC_ID_WMV3,
	AV_CODEC_ID_LOCO,
	AV_CODEC_ID_WNV1,
	AV_CODEC_ID_AASC,
	AV_CODEC_ID_INDEO2,
	AV_CODEC_ID_FRAPS,
	AV_CODEC_ID_TRUEMOTION2,
	AV_CODEC_ID_BMP,
	AV_CODEC_ID_CSCD,
	AV_CODEC_ID_MMVIDEO,
	AV_CODEC_ID_ZMBV,
	AV_CODEC_ID_AVS,
	AV_CODEC_ID_SMACKVIDEO,
	AV_CODEC_ID_NUV,
	AV_CODEC_ID_KMVC,
	AV_CODEC_ID_FLASHSV,
	AV_CODEC_ID_CAVS,
	AV_CODEC_ID_JPEG2000,
	AV_CODEC_ID_VMNC,
	AV_CODEC_ID_VP5,
	AV_CODEC_ID_VP6,
	AV_CODEC_ID_VP6F,
	AV_CODEC_ID_TARGA,
	AV_CODEC_ID_DSICINVIDEO,
	AV_CODEC_ID_TIERTEXSEQVIDEO,
	AV_CODEC_ID_TIFF,
	AV_CODEC_ID_GIF,
	AV_CODEC_ID_DXA,
	AV_CODEC_ID_DNXHD,
	AV_CODEC_ID_THP,
	AV_CODEC_ID_SGI,
	AV_CODEC_ID_C93,
	AV_CODEC_ID_BETHSOFTVID,
	AV_CODEC_ID_PTX,
	AV_CODEC_ID_TXD,
	AV_CODEC_ID_VP6A,
	AV_CODEC_ID_AMV,
	AV_CODEC_ID_VB,
	AV_CODEC_ID_PCX,
	AV_CODEC_ID_SUNRAST,
	AV_CODEC_ID_INDEO4,
	AV_CODEC_ID_INDEO5,
	AV_CODEC_ID_MIMIC,
	AV_CODEC_ID_RL2,
	AV_CODEC_ID_ESCAPE124,
	AV_CODEC_ID_DIRAC,
	AV_CODEC_ID_BFI,
	AV_CODEC_ID_CMV,
	AV_CODEC_ID_MOTIONPIXELS,
	AV_CODEC_ID_TGV,
	AV_CODEC_ID_TGQ,
	AV_CODEC_ID_TQI,
	AV_CODEC_ID_AURA,
	AV_CODEC_ID_AURA2,
	AV_CODEC_ID_V210X,
	AV_CODEC_ID_TMV,
	AV_CODEC_ID_V210,
	AV_CODEC_ID_DPX,
	AV_CODEC_ID_MAD,
	AV_CODEC_ID_FRWU,
	AV_CODEC_ID_FLASHSV2,
	AV_CODEC_ID_CDGRAPHICS,
	AV_CODEC_ID_R210,
	AV_CODEC_ID_ANM,
	AV_CODEC_ID_BINKVIDEO,
	AV_CODEC_ID_IFF_ILBM,
	AV_CODEC_ID_IFF_BYTERUN1 = AV_CODEC_ID_IFF_ILBM,
	AV_CODEC_ID_KGV1,
	AV_CODEC_ID_YOP,
	AV_CODEC_ID_VP8,
	AV_CODEC_ID_PICTOR,
	AV_CODEC_ID_ANSI,
	AV_CODEC_ID_A64_MULTI,
	AV_CODEC_ID_A64_MULTI5,
	AV_CODEC_ID_R10K,
	AV_CODEC_ID_MXPEG,
	AV_CODEC_ID_LAGARITH,
	AV_CODEC_ID_PRORES,
	AV_CODEC_ID_JV,
	AV_CODEC_ID_DFA,
	AV_CODEC_ID_WMV3IMAGE,
	AV_CODEC_ID_VC1IMAGE,
	AV_CODEC_ID_UTVIDEO,
	AV_CODEC_ID_BMV_VIDEO,
	AV_CODEC_ID_VBLE,
	AV_CODEC_ID_DXTORY,
	AV_CODEC_ID_V410,
	AV_CODEC_ID_XWD,
	AV_CODEC_ID_CDXL,
	AV_CODEC_ID_XBM,
	AV_CODEC_ID_ZEROCODEC,
	AV_CODEC_ID_MSS1,
	AV_CODEC_ID_MSA1,
	AV_CODEC_ID_TSCC2,
	AV_CODEC_ID_MTS2,
	AV_CODEC_ID_CLLC,
	AV_CODEC_ID_MSS2,
	AV_CODEC_ID_VP9,
	AV_CODEC_ID_AIC,
	AV_CODEC_ID_ESCAPE130,
	AV_CODEC_ID_G2M,
	AV_CODEC_ID_WEBP,
	AV_CODEC_ID_HNM4_VIDEO,
	AV_CODEC_ID_HEVC,
	AV_CODEC_ID_H265 = AV_CODEC_ID_HEVC,
	AV_CODEC_ID_FIC,
	AV_CODEC_ID_ALIAS_PIX,
	AV_CODEC_ID_BRENDER_PIX,
	AV_CODEC_ID_PAF_VIDEO,
	AV_CODEC_ID_EXR,
	AV_CODEC_ID_VP7,
	AV_CODEC_ID_SANM,
	AV_CODEC_ID_SGIRLE,
	AV_CODEC_ID_MVC1,
	AV_CODEC_ID_MVC2,
	AV_CODEC_ID_HQX,
	AV_CODEC_ID_TDSC,
	AV_CODEC_ID_HQ_HQA,
	AV_CODEC_ID_HAP,
	AV_CODEC_ID_DDS,
	AV_CODEC_ID_DXV,
	AV_CODEC_ID_SCREENPRESSO,
	AV_CODEC_ID_RSCC,
	AV_CODEC_ID_AVS2,
	AV_CODEC_ID_PGX,
	AV_CODEC_ID_AVS3,
	AV_CODEC_ID_MSP2,
	AV_CODEC_ID_VVC,
	AV_CODEC_ID_H266 = AV_CODEC_ID_VVC,
	AV_CODEC_ID_Y41P,
	AV_CODEC_ID_AVRP,
	AV_CODEC_ID_012V,
	AV_CODEC_ID_AVUI,
	AV_CODEC_ID_TARGA_Y216,
	AV_CODEC_ID_V308,
	AV_CODEC_ID_V408,
	AV_CODEC_ID_YUV4,
	AV_CODEC_ID_AVRN,
	AV_CODEC_ID_CPIA,
	AV_CODEC_ID_XFACE,
	AV_CODEC_ID_SNOW,
	AV_CODEC_ID_SMVJPEG,
	AV_CODEC_ID_APNG,
	AV_CODEC_ID_DAALA,
	AV_CODEC_ID_CFHD,
	AV_CODEC_ID_TRUEMOTION2RT,
	AV_CODEC_ID_M101,
	AV_CODEC_ID_MAGICYUV,
	AV_CODEC_ID_SHEERVIDEO,
	AV_CODEC_ID_YLC,
	AV_CODEC_ID_PSD,
	AV_CODEC_ID_PIXLET,
	AV_CODEC_ID_SPEEDHQ,
	AV_CODEC_ID_FMVC,
	AV_CODEC_ID_SCPR,
	AV_CODEC_ID_CLEARVIDEO,
	AV_CODEC_ID_XPM,
	AV_CODEC_ID_AV1,
	AV_CODEC_ID_BITPACKED,
	AV_CODEC_ID_MSCC,
	AV_CODEC_ID_SRGC,
	AV_CODEC_ID_SVG,
	AV_CODEC_ID_GDV,
	AV_CODEC_ID_FITS,
	AV_CODEC_ID_IMM4,
	AV_CODEC_ID_PROSUMER,
	AV_CODEC_ID_MWSC,
	AV_CODEC_ID_WCMV,
	AV_CODEC_ID_RASC,
	AV_CODEC_ID_HYMT,
	AV_CODEC_ID_ARBC,
	AV_CODEC_ID_AGM,
	AV_CODEC_ID_LSCR,
	AV_CODEC_ID_VP4,
	AV_CODEC_ID_IMM5,
	AV_CODEC_ID_MVDV,
	AV_CODEC_ID_MVHA,
	AV_CODEC_ID_CDTOONS,
	AV_CODEC_ID_MV30,
	AV_CODEC_ID_NOTCHLC,
	AV_CODEC_ID_PFM,
	AV_CODEC_ID_MOBICLIP,
	AV_CODEC_ID_PHOTOCD,
	AV_CODEC_ID_IPU,
	AV_CODEC_ID_ARGO,
	AV_CODEC_ID_CRI,
	AV_CODEC_ID_SIMBIOSIS_IMX,
	AV_CODEC_ID_SGA_VIDEO,
	AV_CODEC_ID_GEM,
	AV_CODEC_ID_VBN,
	AV_CODEC_ID_JPEGXL,
	AV_CODEC_ID_QOI,
	AV_CODEC_ID_PHM,
	AV_CODEC_ID_RADIANCE_HDR,
	AV_CODEC_ID_WBMP,
	AV_CODEC_ID_MEDIA100,
	AV_CODEC_ID_VQC,
	AV_CODEC_ID_PDV,
	AV_CODEC_ID_EVC,
	AV_CODEC_ID_RTV1,
	AV_CODEC_ID_VMIX,
	AV_CODEC_ID_LEAD,

	/* various PCM "codecs" */
	AV_CODEC_ID_FIRST_AUDIO = 0x10000, ///< A dummy id pointing at the start of audio codecs
	AV_CODEC_ID_PCM_S16LE = 0x10000,
	AV_CODEC_ID_PCM_S16BE,
	AV_CODEC_ID_PCM_U16LE,
	AV_CODEC_ID_PCM_U16BE,
	AV_CODEC_ID_PCM_S8,
	AV_CODEC_ID_PCM_U8,
	AV_CODEC_ID_PCM_MULAW,
	AV_CODEC_ID_PCM_ALAW,
	AV_CODEC_ID_PCM_S32LE,
	AV_CODEC_ID_PCM_S32BE,
	AV_CODEC_ID_PCM_U32LE,
	AV_CODEC_ID_PCM_U32BE,
	AV_CODEC_ID_PCM_S24LE,
	AV_CODEC_ID_PCM_S24BE,
	AV_CODEC_ID_PCM_U24LE,
	AV_CODEC_ID_PCM_U24BE,
	AV_CODEC_ID_PCM_S24DAUD,
	AV_CODEC_ID_PCM_ZORK,
	AV_CODEC_ID_PCM_S16LE_PLANAR,
	AV_CODEC_ID_PCM_DVD,
	AV_CODEC_ID_PCM_F32BE,
	AV_CODEC_ID_PCM_F32LE,
	AV_CODEC_ID_PCM_F64BE,
	AV_CODEC_ID_PCM_F64LE,
	AV_CODEC_ID_PCM_BLURAY,
	AV_CODEC_ID_PCM_LXF,
	AV_CODEC_ID_S302M,
	AV_CODEC_ID_PCM_S8_PLANAR,
	AV_CODEC_ID_PCM_S24LE_PLANAR,
	AV_CODEC_ID_PCM_S32LE_PLANAR,
	AV_CODEC_ID_PCM_S16BE_PLANAR,
	AV_CODEC_ID_PCM_S64LE,
	AV_CODEC_ID_PCM_S64BE,
	AV_CODEC_ID_PCM_F16LE,
	AV_CODEC_ID_PCM_F24LE,
	AV_CODEC_ID_PCM_VIDC,
	AV_CODEC_ID_PCM_SGA,

	/* various ADPCM codecs */
	AV_CODEC_ID_ADPCM_IMA_QT = 0x11000,
	AV_CODEC_ID_ADPCM_IMA_WAV,
	AV_CODEC_ID_ADPCM_IMA_DK3,
	AV_CODEC_ID_ADPCM_IMA_DK4,
	AV_CODEC_ID_ADPCM_IMA_WS,
	AV_CODEC_ID_ADPCM_IMA_SMJPEG,
	AV_CODEC_ID_ADPCM_MS,
	AV_CODEC_ID_ADPCM_4XM,
	AV_CODEC_ID_ADPCM_XA,
	AV_CODEC_ID_ADPCM_ADX,
	AV_CODEC_ID_ADPCM_EA,
	AV_CODEC_ID_ADPCM_G726,
	AV_CODEC_ID_ADPCM_CT,
	AV_CODEC_ID_ADPCM_SWF,
	AV_CODEC_ID_ADPCM_YAMAHA,
	AV_CODEC_ID_ADPCM_SBPRO_4,
	AV_CODEC_ID_ADPCM_SBPRO_3,
	AV_CODEC_ID_ADPCM_SBPRO_2,
	AV_CODEC_ID_ADPCM_THP,
	AV_CODEC_ID_ADPCM_IMA_AMV,
	AV_CODEC_ID_ADPCM_EA_R1,
	AV_CODEC_ID_ADPCM_EA_R3,
	AV_CODEC_ID_ADPCM_EA_R2,
	AV_CODEC_ID_ADPCM_IMA_EA_SEAD,
	AV_CODEC_ID_ADPCM_IMA_EA_EACS,
	AV_CODEC_ID_ADPCM_EA_XAS,
	AV_CODEC_ID_ADPCM_EA_MAXIS_XA,
	AV_CODEC_ID_ADPCM_IMA_ISS,
	AV_CODEC_ID_ADPCM_G722,
	AV_CODEC_ID_ADPCM_IMA_APC,
	AV_CODEC_ID_ADPCM_VIMA,
	AV_CODEC_ID_ADPCM_AFC,
	AV_CODEC_ID_ADPCM_IMA_OKI,
	AV_CODEC_ID_ADPCM_DTK,
	AV_CODEC_ID_ADPCM_IMA_RAD,
	AV_CODEC_ID_ADPCM_G726LE,
	AV_CODEC_ID_ADPCM_THP_LE,
	AV_CODEC_ID_ADPCM_PSX,
	AV_CODEC_ID_ADPCM_AICA,
	AV_CODEC_ID_ADPCM_IMA_DAT4,
	AV_CODEC_ID_ADPCM_MTAF,
	AV_CODEC_ID_ADPCM_AGM,
	AV_CODEC_ID_ADPCM_ARGO,
	AV_CODEC_ID_ADPCM_IMA_SSI,
	AV_CODEC_ID_ADPCM_ZORK,
	AV_CODEC_ID_ADPCM_IMA_APM,
	AV_CODEC_ID_ADPCM_IMA_ALP,
	AV_CODEC_ID_ADPCM_IMA_MTF,
	AV_CODEC_ID_ADPCM_IMA_CUNNING,
	AV_CODEC_ID_ADPCM_IMA_MOFLEX,
	AV_CODEC_ID_ADPCM_IMA_ACORN,
	AV_CODEC_ID_ADPCM_XMD,

	/* AMR */
	AV_CODEC_ID_AMR_NB = 0x12000,
	AV_CODEC_ID_AMR_WB,

	/* RealAudio codecs*/
	AV_CODEC_ID_RA_144 = 0x13000,
	AV_CODEC_ID_RA_288,

	/* various DPCM codecs */
	AV_CODEC_ID_ROQ_DPCM = 0x14000,
	AV_CODEC_ID_INTERPLAY_DPCM,
	AV_CODEC_ID_XAN_DPCM,
	AV_CODEC_ID_SOL_DPCM,
	AV_CODEC_ID_SDX2_DPCM,
	AV_CODEC_ID_GREMLIN_DPCM,
	AV_CODEC_ID_DERF_DPCM,
	AV_CODEC_ID_WADY_DPCM,
	AV_CODEC_ID_CBD2_DPCM,

	/* audio codecs */
	AV_CODEC_ID_MP2 = 0x15000,
	AV_CODEC_ID_MP3, ///< preferred ID for decoding MPEG audio layer 1, 2 or 3
	AV_CODEC_ID_AAC,
	AV_CODEC_ID_AC3,
	AV_CODEC_ID_DTS,
	AV_CODEC_ID_VORBIS,
	AV_CODEC_ID_DVAUDIO,
	AV_CODEC_ID_WMAV1,
	AV_CODEC_ID_WMAV2,
	AV_CODEC_ID_MACE3,
	AV_CODEC_ID_MACE6,
	AV_CODEC_ID_VMDAUDIO,
	AV_CODEC_ID_FLAC,
	AV_CODEC_ID_MP3ADU,
	AV_CODEC_ID_MP3ON4,
	AV_CODEC_ID_SHORTEN,
	AV_CODEC_ID_ALAC,
	AV_CODEC_ID_WESTWOOD_SND1,
	AV_CODEC_ID_GSM, ///< as in Berlin toast format
	AV_CODEC_ID_QDM2,
	AV_CODEC_ID_COOK,
	AV_CODEC_ID_TRUESPEECH,
	AV_CODEC_ID_TTA,
	AV_CODEC_ID_SMACKAUDIO,
	AV_CODEC_ID_QCELP,
	AV_CODEC_ID_WAVPACK,
	AV_CODEC_ID_DSICINAUDIO,
	AV_CODEC_ID_IMC,
	AV_CODEC_ID_MUSEPACK7,
	AV_CODEC_ID_MLP,
	AV_CODEC_ID_GSM_MS, /* as found in WAV */
	AV_CODEC_ID_ATRAC3,
	AV_CODEC_ID_APE,
	AV_CODEC_ID_NELLYMOSER,
	AV_CODEC_ID_MUSEPACK8,
	AV_CODEC_ID_SPEEX,
	AV_CODEC_ID_WMAVOICE,
	AV_CODEC_ID_WMAPRO,
	AV_CODEC_ID_WMALOSSLESS,
	AV_CODEC_ID_ATRAC3P,
	AV_CODEC_ID_EAC3,
	AV_CODEC_ID_SIPR,
	AV_CODEC_ID_MP1,
	AV_CODEC_ID_TWINVQ,
	AV_CODEC_ID_TRUEHD,
	AV_CODEC_ID_MP4ALS,
	AV_CODEC_ID_ATRAC1,
	AV_CODEC_ID_BINKAUDIO_RDFT,
	AV_CODEC_ID_BINKAUDIO_DCT,
	AV_CODEC_ID_AAC_LATM,
	AV_CODEC_ID_QDMC,
	AV_CODEC_ID_CELT,
	AV_CODEC_ID_G723_1,
	AV_CODEC_ID_G729,
	AV_CODEC_ID_8SVX_EXP,
	AV_CODEC_ID_8SVX_FIB,
	AV_CODEC_ID_BMV_AUDIO,
	AV_CODEC_ID_RALF,
	AV_CODEC_ID_IAC,
	AV_CODEC_ID_ILBC,
	AV_CODEC_ID_OPUS,
	AV_CODEC_ID_COMFORT_NOISE,
	AV_CODEC_ID_TAK,
	AV_CODEC_ID_METASOUND,
	AV_CODEC_ID_PAF_AUDIO,
	AV_CODEC_ID_ON2AVC,
	AV_CODEC_ID_DSS_SP,
	AV_CODEC_ID_CODEC2,
	AV_CODEC_ID_FFWAVESYNTH,
	AV_CODEC_ID_SONIC,
	AV_CODEC_ID_SONIC_LS,
	AV_CODEC_ID_EVRC,
	AV_CODEC_ID_SMV,
	AV_CODEC_ID_DSD_LSBF,
	AV_CODEC_ID_DSD_MSBF,
	AV_CODEC_ID_DSD_LSBF_PLANAR,
	AV_CODEC_ID_DSD_MSBF_PLANAR,
	AV_CODEC_ID_4GV,
	AV_CODEC_ID_INTERPLAY_ACM,
	AV_CODEC_ID_XMA1,
	AV_CODEC_ID_XMA2,
	AV_CODEC_ID_DST,
	AV_CODEC_ID_ATRAC3AL,
	AV_CODEC_ID_ATRAC3PAL,
	AV_CODEC_ID_DOLBY_E,
	AV_CODEC_ID_APTX,
	AV_CODEC_ID_APTX_HD,
	AV_CODEC_ID_SBC,
	AV_CODEC_ID_ATRAC9,
	AV_CODEC_ID_HCOM,
	AV_CODEC_ID_ACELP_KELVIN,
	AV_CODEC_ID_MPEGH_3D_AUDIO,
	AV_CODEC_ID_SIREN,
	AV_CODEC_ID_HCA,
	AV_CODEC_ID_FASTAUDIO,
	AV_CODEC_ID_MSNSIREN,
	AV_CODEC_ID_DFPWM,
	AV_CODEC_ID_BONK,
	AV_CODEC_ID_MISC4,
	AV_CODEC_ID_APAC,
	AV_CODEC_ID_FTR,
	AV_CODEC_ID_WAVARC,
	AV_CODEC_ID_RKA,
	AV_CODEC_ID_AC4,
	AV_CODEC_ID_OSQ,
	AV_CODEC_ID_QOA,

	/* subtitle codecs */
	AV_CODEC_ID_FIRST_SUBTITLE = 0x17000, ///< A dummy ID pointing at the start of subtitle codecs.
	AV_CODEC_ID_DVD_SUBTITLE = 0x17000,
	AV_CODEC_ID_DVB_SUBTITLE,
	AV_CODEC_ID_TEXT, ///< raw UTF-8 text
	AV_CODEC_ID_XSUB,
	AV_CODEC_ID_SSA,
	AV_CODEC_ID_MOV_TEXT,
	AV_CODEC_ID_HDMV_PGS_SUBTITLE,
	AV_CODEC_ID_DVB_TELETEXT,
	AV_CODEC_ID_SRT,
	AV_CODEC_ID_MICRODVD,
	AV_CODEC_ID_EIA_608,
	AV_CODEC_ID_JACOSUB,
	AV_CODEC_ID_SAMI,
	AV_CODEC_ID_REALTEXT,
	AV_CODEC_ID_STL,
	AV_CODEC_ID_SUBVIEWER1,
	AV_CODEC_ID_SUBVIEWER,
	AV_CODEC_ID_SUBRIP,
	AV_CODEC_ID_WEBVTT,
	AV_CODEC_ID_MPL2,
	AV_CODEC_ID_VPLAYER,
	AV_CODEC_ID_PJS,
	AV_CODEC_ID_ASS,
	AV_CODEC_ID_HDMV_TEXT_SUBTITLE,
	AV_CODEC_ID_TTML,
	AV_CODEC_ID_ARIB_CAPTION,

	/* other specific kind of codecs (generally used for attachments) */
	AV_CODEC_ID_FIRST_UNKNOWN = 0x18000, ///< A dummy ID pointing at the start of various fake codecs.
	AV_CODEC_ID_TTF = 0x18000,
	AV_CODEC_ID_SCTE_35, ///< Contain timestamp estimated through PCR of program stream.
	AV_CODEC_ID_EPG,
	AV_CODEC_ID_BINTEXT,
	AV_CODEC_ID_XBIN,
	AV_CODEC_ID_IDF,
	AV_CODEC_ID_OTF,
	AV_CODEC_ID_SMPTE_KLV,
	AV_CODEC_ID_DVD_NAV,
	AV_CODEC_ID_TIMED_ID3,
	AV_CODEC_ID_BIN_DATA,
	AV_CODEC_ID_SMPTE_2038,
	AV_CODEC_ID_PROBE = 0x19000, ///< codec_id is not known (like AV_CODEC_ID_NONE) but lavf should attempt to identify it
	AV_CODEC_ID_MPEG2TS = 0x20000, /**< _FAKE_ codec to indicate a raw MPEG-2 TS
                                * stream (only used by libavformat) */
	AV_CODEC_ID_MPEG4SYSTEMS = 0x20001, /**< _FAKE_ codec to indicate a MPEG-4 Systems
                                * stream (only used by libavformat) */
	AV_CODEC_ID_FFMETADATA = 0x21000, ///< Dummy codec for streams containing only metadata information.
	AV_CODEC_ID_WRAPPED_AVFRAME = 0x21001, ///< Passthrough codec, AVFrames wrapped in AVPacket
	/**
     * Dummy null video codec, useful mainly for development and debugging.
     * Null encoder/decoder discard all input and never return any output.
     */
	AV_CODEC_ID_VNULL,
	/**
     * Dummy null audio codec, useful mainly for development and debugging.
     * Null encoder/decoder discard all input and never return any output.
     */
	AV_CODEC_ID_ANULL,
}

// Public CodecID
CodecID :: enum {
	NONE,

	/* video codecs */
	MPEG1VIDEO,
	MPEG2VIDEO, ///< preferred ID for MPEG-1/2 video decoding
	H261,
	H263,
	RV10,
	RV20,
	MJPEG,
	MJPEGB,
	LJPEG,
	SP5X,
	JPEGLS,
	MPEG4,
	RAWVIDEO,
	MSMPEG4V1,
	MSMPEG4V2,
	MSMPEG4V3,
	WMV1,
	WMV2,
	H263P,
	H263I,
	FLV1,
	SVQ1,
	SVQ3,
	DVVIDEO,
	HUFFYUV,
	CYUV,
	H264,
	INDEO3,
	VP3,
	THEORA,
	ASV1,
	ASV2,
	FFV1,
	_4XM,
	VCR1,
	CLJR,
	MDEC,
	ROQ,
	INTERPLAY_VIDEO,
	XAN_WC3,
	XAN_WC4,
	RPZA,
	CINEPAK,
	WS_VQA,
	MSRLE,
	MSVIDEO1,
	IDCIN,
	_8BPS,
	SMC,
	FLIC,
	TRUEMOTION1,
	VMDVIDEO,
	MSZH,
	ZLIB,
	QTRLE,
	TSCC,
	ULTI,
	QDRAW,
	VIXL,
	QPEG,
	PNG,
	PPM,
	PBM,
	PGM,
	PGMYUV,
	PAM,
	FFVHUFF,
	RV30,
	RV40,
	VC1,
	WMV3,
	LOCO,
	WNV1,
	AASC,
	INDEO2,
	FRAPS,
	TRUEMOTION2,
	BMP,
	CSCD,
	MMVIDEO,
	ZMBV,
	AVS,
	SMACKVIDEO,
	NUV,
	KMVC,
	FLASHSV,
	CAVS,
	JPEG2000,
	VMNC,
	VP5,
	VP6,
	VP6F,
	TARGA,
	DSICINVIDEO,
	TIERTEXSEQVIDEO,
	TIFF,
	GIF,
	DXA,
	DNXHD,
	THP,
	SGI,
	C93,
	BETHSOFTVID,
	PTX,
	TXD,
	VP6A,
	AMV,
	VB,
	PCX,
	SUNRAST,
	INDEO4,
	INDEO5,
	MIMIC,
	RL2,
	ESCAPE124,
	DIRAC,
	BFI,
	CMV,
	MOTIONPIXELS,
	TGV,
	TGQ,
	TQI,
	AURA,
	AURA2,
	V210X,
	TMV,
	V210,
	DPX,
	MAD,
	FRWU,
	FLASHSV2,
	CDGRAPHICS,
	R210,
	ANM,
	BINKVIDEO,
	IFF_ILBM,
	IFF_BYTERUN1 = IFF_ILBM,
	KGV1,
	YOP,
	VP8,
	PICTOR,
	ANSI,
	A64_MULTI,
	A64_MULTI5,
	R10K,
	MXPEG,
	LAGARITH,
	PRORES,
	JV,
	DFA,
	WMV3IMAGE,
	VC1IMAGE,
	UTVIDEO,
	BMV_VIDEO,
	VBLE,
	DXTORY,
	V410,
	XWD,
	CDXL,
	XBM,
	ZEROCODEC,
	MSS1,
	MSA1,
	TSCC2,
	MTS2,
	CLLC,
	MSS2,
	VP9,
	AIC,
	ESCAPE130,
	G2M,
	WEBP,
	HNM4_VIDEO,
	HEVC,
	H265 = HEVC,
	FIC,
	ALIAS_PIX,
	BRENDER_PIX,
	PAF_VIDEO,
	EXR,
	VP7,
	SANM,
	SGIRLE,
	MVC1,
	MVC2,
	HQX,
	TDSC,
	HQ_HQA,
	HAP,
	DDS,
	DXV,
	SCREENPRESSO,
	RSCC,
	AVS2,
	PGX,
	AVS3,
	MSP2,
	VVC,
	H266 = VVC,
	Y41P,
	AVRP,
	_012V,
	AVUI,
	TARGA_Y216,
	V308,
	V408,
	YUV4,
	AVRN,
	CPIA,
	XFACE,
	SNOW,
	SMVJPEG,
	APNG,
	DAALA,
	CFHD,
	TRUEMOTION2RT,
	M101,
	MAGICYUV,
	SHEERVIDEO,
	YLC,
	PSD,
	PIXLET,
	SPEEDHQ,
	FMVC,
	SCPR,
	CLEARVIDEO,
	XPM,
	AV1,
	BITPACKED,
	MSCC,
	SRGC,
	SVG,
	GDV,
	FITS,
	IMM4,
	PROSUMER,
	MWSC,
	WCMV,
	RASC,
	HYMT,
	ARBC,
	AGM,
	LSCR,
	VP4,
	IMM5,
	MVDV,
	MVHA,
	CDTOONS,
	MV30,
	NOTCHLC,
	PFM,
	MOBICLIP,
	PHOTOCD,
	IPU,
	ARGO,
	CRI,
	SIMBIOSIS_IMX,
	SGA_VIDEO,
	GEM,
	VBN,
	JPEGXL,
	QOI,
	PHM,
	RADIANCE_HDR,
	WBMP,
	MEDIA100,
	VQC,
	PDV,
	EVC,
	RTV1,
	VMIX,
	LEAD,

	/* various PCM "codecs" */
	FIRST_AUDIO = 0x10000, ///< A dummy id pointing at the start of audio codecs
	PCM_S16LE = 0x10000,
	PCM_S16BE,
	PCM_U16LE,
	PCM_U16BE,
	PCM_S8,
	PCM_U8,
	PCM_MULAW,
	PCM_ALAW,
	PCM_S32LE,
	PCM_S32BE,
	PCM_U32LE,
	PCM_U32BE,
	PCM_S24LE,
	PCM_S24BE,
	PCM_U24LE,
	PCM_U24BE,
	PCM_S24DAUD,
	PCM_ZORK,
	PCM_S16LE_PLANAR,
	PCM_DVD,
	PCM_F32BE,
	PCM_F32LE,
	PCM_F64BE,
	PCM_F64LE,
	PCM_BLURAY,
	PCM_LXF,
	S302M,
	PCM_S8_PLANAR,
	PCM_S24LE_PLANAR,
	PCM_S32LE_PLANAR,
	PCM_S16BE_PLANAR,
	PCM_S64LE,
	PCM_S64BE,
	PCM_F16LE,
	PCM_F24LE,
	PCM_VIDC,
	PCM_SGA,

	/* various ADPCM codecs */
	ADPCM_IMA_QT = 0x11000,
	ADPCM_IMA_WAV,
	ADPCM_IMA_DK3,
	ADPCM_IMA_DK4,
	ADPCM_IMA_WS,
	ADPCM_IMA_SMJPEG,
	ADPCM_MS,
	ADPCM_4XM,
	ADPCM_XA,
	ADPCM_ADX,
	ADPCM_EA,
	ADPCM_G726,
	ADPCM_CT,
	ADPCM_SWF,
	ADPCM_YAMAHA,
	ADPCM_SBPRO_4,
	ADPCM_SBPRO_3,
	ADPCM_SBPRO_2,
	ADPCM_THP,
	ADPCM_IMA_AMV,
	ADPCM_EA_R1,
	ADPCM_EA_R3,
	ADPCM_EA_R2,
	ADPCM_IMA_EA_SEAD,
	ADPCM_IMA_EA_EACS,
	ADPCM_EA_XAS,
	ADPCM_EA_MAXIS_XA,
	ADPCM_IMA_ISS,
	ADPCM_G722,
	ADPCM_IMA_APC,
	ADPCM_VIMA,
	ADPCM_AFC,
	ADPCM_IMA_OKI,
	ADPCM_DTK,
	ADPCM_IMA_RAD,
	ADPCM_G726LE,
	ADPCM_THP_LE,
	ADPCM_PSX,
	ADPCM_AICA,
	ADPCM_IMA_DAT4,
	ADPCM_MTAF,
	ADPCM_AGM,
	ADPCM_ARGO,
	ADPCM_IMA_SSI,
	ADPCM_ZORK,
	ADPCM_IMA_APM,
	ADPCM_IMA_ALP,
	ADPCM_IMA_MTF,
	ADPCM_IMA_CUNNING,
	ADPCM_IMA_MOFLEX,
	ADPCM_IMA_ACORN,
	ADPCM_XMD,

	/* AMR */
	AMR_NB = 0x12000,
	AMR_WB,

	/* RealAudio codecs*/
	RA_144 = 0x13000,
	RA_288,

	/* various DPCM codecs */
	ROQ_DPCM = 0x14000,
	INTERPLAY_DPCM,
	XAN_DPCM,
	SOL_DPCM,
	SDX2_DPCM,
	GREMLIN_DPCM,
	DERF_DPCM,
	WADY_DPCM,
	CBD2_DPCM,

	/* audio codecs */
	MP2 = 0x15000,
	MP3, ///< preferred ID for decoding MPEG audio layer 1, 2 or 3
	AAC,
	AC3,
	DTS,
	VORBIS,
	DVAUDIO,
	WMAV1,
	WMAV2,
	MACE3,
	MACE6,
	VMDAUDIO,
	FLAC,
	MP3ADU,
	MP3ON4,
	SHORTEN,
	ALAC,
	WESTWOOD_SND1,
	GSM, ///< as in Berlin toast format
	QDM2,
	COOK,
	TRUESPEECH,
	TTA,
	SMACKAUDIO,
	QCELP,
	WAVPACK,
	DSICINAUDIO,
	IMC,
	MUSEPACK7,
	MLP,
	GSM_MS, /* as found in WAV */
	ATRAC3,
	APE,
	NELLYMOSER,
	MUSEPACK8,
	SPEEX,
	WMAVOICE,
	WMAPRO,
	WMALOSSLESS,
	ATRAC3P,
	EAC3,
	SIPR,
	MP1,
	TWINVQ,
	TRUEHD,
	MP4ALS,
	ATRAC1,
	BINKAUDIO_RDFT,
	BINKAUDIO_DCT,
	AAC_LATM,
	QDMC,
	CELT,
	G723_1,
	G729,
	_8SVX_EXP,
	_8SVX_FIB,
	BMV_AUDIO,
	RALF,
	IAC,
	ILBC,
	OPUS,
	COMFORT_NOISE,
	TAK,
	METASOUND,
	PAF_AUDIO,
	ON2AVC,
	DSS_SP,
	CODEC2,
	FFWAVESYNTH,
	SONIC,
	SONIC_LS,
	EVRC,
	SMV,
	DSD_LSBF,
	DSD_MSBF,
	DSD_LSBF_PLANAR,
	DSD_MSBF_PLANAR,
	_4GV,
	INTERPLAY_ACM,
	XMA1,
	XMA2,
	DST,
	ATRAC3AL,
	ATRAC3PAL,
	DOLBY_E,
	APTX,
	APTX_HD,
	SBC,
	ATRAC9,
	HCOM,
	ACELP_KELVIN,
	MPEGH_3D_AUDIO,
	SIREN,
	HCA,
	FASTAUDIO,
	MSNSIREN,
	DFPWM,
	BONK,
	MISC4,
	APAC,
	FTR,
	WAVARC,
	RKA,
	AC4,
	OSQ,
	QOA,

	/* subtitle codecs */
	FIRST_SUBTITLE = 0x17000, ///< A dummy ID pointing at the start of subtitle codecs.
	DVD_SUBTITLE = 0x17000,
	DVB_SUBTITLE,
	TEXT, ///< raw UTF-8 text
	XSUB,
	SSA,
	MOV_TEXT,
	HDMV_PGS_SUBTITLE,
	DVB_TELETEXT,
	SRT,
	MICRODVD,
	EIA_608,
	JACOSUB,
	SAMI,
	REALTEXT,
	STL,
	SUBVIEWER1,
	SUBVIEWER,
	SUBRIP,
	WEBVTT,
	MPL2,
	VPLAYER,
	PJS,
	ASS,
	HDMV_TEXT_SUBTITLE,
	TTML,
	ARIB_CAPTION,

	/* other specific kind of codecs (generally used for attachments) */
	FIRST_UNKNOWN = 0x18000, ///< A dummy ID pointing at the start of various fake codecs.
	TTF = 0x18000,
	SCTE_35, ///< Contain timestamp estimated through PCR of program stream.
	EPG,
	BINTEXT,
	XBIN,
	IDF,
	OTF,
	SMPTE_KLV,
	DVD_NAV,
	TIMED_ID3,
	BIN_DATA,
	SMPTE_2038,
	PROBE = 0x19000, ///< codec_id is not known (like NONE) but lavf should attempt to identify it
	MPEG2TS = 0x20000, /**< _FAKE_ codec to indicate a raw MPEG-2 TS
                                * stream (only used by libavformat) */
	MPEG4SYSTEMS = 0x20001, /**< _FAKE_ codec to indicate a MPEG-4 Systems
                                * stream (only used by libavformat) */
	FFMETADATA = 0x21000, ///< Dummy codec for streams containing only metadata information.
	WRAPPED_AVFRAME = 0x21001, ///< Passthrough codec, AVFrames wrapped in AVPacket
	/**
     * Dummy null video codec, useful mainly for development and debugging.
     * Null encoder/decoder discard all input and never return any output.
     */
	VNULL,
	/**
     * Dummy null audio codec, useful mainly for development and debugging.
     * Null encoder/decoder discard all input and never return any output.
     */
	ANULL,
}

