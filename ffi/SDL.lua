local ffi = require("ffi")

local libs = ffi_luajit_libs or {
   OSX     = { x86 = "bin/luajit.dylib", x64 = "bin/luajit.dylib" },
   Windows = { x86 = "bin/Windows/x86/SDL.dll", x64 = "bin/Windows/x64/SDL.dll" },
   Linux   = { x86 = "bin/luajit32.so",  x64 = "bin/luajit64.so" },
   BSD     = { x86 = "bin/luajit32.so",  x64 = "bin/luajit64.so" },
   POSIX   = { x86 = "bin/luajit32.so",  x64 = "bin/luajit64.so" },
   Other   = { x86 = "bin/luajit32.so",  x64 = "bin/luajit64.so" },
}

local lib  = ffi_SDL_lib or libs[ ffi.os ][ ffi.arch ]

local sdl  = ffi.load( lib )

ffi.cdef[[
      const char * SDL_GetPlatform (void);

      typedef enum SDL_bool {
	 SDL_FALSE,
	 SDL_TRUE
      } SDL_bool;
      
      void*   SDL_malloc(  size_t size );
      void*   SDL_calloc(  size_t nmemb, size_t size );
      void*   SDL_realloc( void*  mem, size_t size );
      void    SDL_free(    void* mem );
      char*   SDL_getenv(  const char *name );
      int     SDL_setenv(  const char *name, const char *value, int overwrite );
      void    SDL_qsort(   void *base, size_t nmemb, size_t size, int (*compare) (const void *, const void *) );
      void*   SDL_memset(  void *dst, int c, size_t len );
      void*   SDL_memcpy(  void *dst, const void *src, size_t len );
      void*   SDL_memmove( void *dst, const void *src, size_t len );
      int     SDL_memcmp(  const void *s1, const void *s2, size_t len );
      size_t  SDL_strlen(const char *string);
      size_t  SDL_wcslen(const wchar_t * string);
      size_t  SDL_wcslcpy(wchar_t *dst, const wchar_t *src, size_t maxlen);
      size_t  SDL_wcslcat(wchar_t *dst, const wchar_t *src, size_t maxlen);
      size_t  SDL_strlcpy(char *dst, const char *src, size_t maxlen);
      size_t  SDL_utf8strlcpy(char *dst, const char *src, size_t dst_bytes);
      size_t  SDL_strlcat(char *dst, const char *src, size_t maxlen);
      char*   SDL_strdup(const char *string);
      char*   SDL_strrev(char *string);
      char*   SDL_strupr(char *string);
      char*   SDL_strlwr(char *string);
      char*   SDL_strchr(const char *string, int c);
      char*   SDL_strrchr(const char *string, int c);
      char*   SDL_strstr(const char *haystack, const char *needle);
      char*   SDL_ltoa(long value, char *string, int radix);
      char*         SDL_ultoa(    unsigned long value, char *string, int radix);
      long          SDL_strtol(   const char *string, char **endp, int base);
      unsigned long SDL_strtoul(  const char *string, char **endp, int base);
      char*         SDL_lltoa(    int64_t value, char *string, int radix);
      char*         SDL_ulltoa(   uint64_t value, char *string, int radix);
      int64_t       SDL_strtoll(  const char *string, char **endp, int base);
      uint64_t      SDL_strtoull( const char *string, char **endp, int base);

double SDL_strtod(const char *string, char **endp);
int SDL_strcmp(const char *str1, const char *str2);
int SDL_strncmp(const char *str1, const char *str2, size_t maxlen);
int SDL_strcasecmp(const char *str1, const char *str2);
int SDL_strncasecmp(const char *str1, const char *str2, size_t maxlen);
int SDL_sscanf(const char *text, const char *fmt, ...);
int SDL_snprintf(char *text, size_t maxlen, const char *fmt, ...);
int SDL_vsnprintf(char *text, size_t maxlen, const char *fmt, va_list ap);
double SDL_atan(double x);
double SDL_atan2(double y, double x);
double SDL_copysign(double x, double y);
double SDL_cos(double x);
double SDL_fabs(double x);
double SDL_floor(double x);
double SDL_log(double x);
double SDL_pow(double x, double y);
double SDL_scalbn(double x, int n);
double SDL_sin(double x);
double SDL_sqrt(double x);

typedef struct _SDL_iconv_t *SDL_iconv_t;
SDL_iconv_t SDL_iconv_open(const char *tocode,
                                                   const char *fromcode);
int SDL_iconv_close(SDL_iconv_t cd);

size_t SDL_iconv(SDL_iconv_t cd, const char **inbuf,
                                         size_t * inbytesleft, char **outbuf,
                                         size_t * outbytesleft);

char *SDL_iconv_string(const char *tocode,
                                               const char *fromcode,
                                               const char *inbuf,
                                               size_t inbytesleft);

int  SDL_main(int argc, char *argv[]);
int  SDL_RegisterApp(char *name, uint32_t style, void *hInst);
void SDL_UnregisterApp(void);

typedef enum {
   SDL_ASSERTION_RETRY,  
   SDL_ASSERTION_BREAK,  
   SDL_ASSERTION_ABORT,  
   SDL_ASSERTION_IGNORE,  
   SDL_ASSERTION_ALWAYS_IGNORE,  
} SDL_assert_state;

typedef struct SDL_assert_data {
    int always_ignore;
    unsigned int trigger_count;
    const char *condition;
    const char *filename;
    int linenum;
    const char *function;
    const struct SDL_assert_data *next;
} SDL_assert_data;

SDL_assert_state SDL_ReportAssertion(SDL_assert_data *, const char *, const char *, int);

typedef SDL_assert_state (*SDL_AssertionHandler)(const SDL_assert_data* data, void* userdata);

void  SDL_SetAssertionHandler(SDL_AssertionHandler handler, void *userdata);
const SDL_assert_data * SDL_GetAssertionReport(void);
void  SDL_ResetAssertionReport(void);

typedef uintptr_t(* pfnSDL_CurrentBeginThread) (void *, unsigned, unsigned (__stdcall *func) (void *), void *arg, unsigned, unsigned *threadID );
typedef void (* pfnSDL_CurrentEndThread) (unsigned code);

typedef struct SDL_Thread SDL_Thread;
typedef unsigned long SDL_threadID;
typedef int (__cdecl * SDL_ThreadFunction) (void *data);

typedef enum {
    SDL_THREAD_PRIORITY_LOW,
    SDL_THREAD_PRIORITY_NORMAL,
    SDL_THREAD_PRIORITY_HIGH
} SDL_ThreadPriority;

SDL_Thread* SDL_CreateThread(SDL_ThreadFunction fn, void *data, pfnSDL_CurrentBeginThread pfnBeginThread, pfnSDL_CurrentEndThread pfnEndThread);
SDL_threadID SDL_ThreadID(void);
SDL_threadID SDL_GetThreadID(SDL_Thread * thread);
int SDL_SetThreadPriority(SDL_ThreadPriority priority);
void SDL_WaitThread(SDL_Thread * thread, int *status);

typedef struct SDL_RWops
{
   long (* seek) (struct SDL_RWops * context, long offset,  int whence);
   size_t(* read) (struct SDL_RWops * context, void *ptr, size_t size, size_t maxnum);
   size_t(* write) (struct SDL_RWops * context, const void *ptr, size_t size, size_t num);

    

    int (* close) (struct SDL_RWops * context);

    uint32_t type;
    union
    {

        struct
        {
            SDL_bool append;
            void *h;
            struct
            {
                void *data;
                size_t size;
                size_t left;
            } buffer;
        } windowsio;

        struct
        {
            uint8_t *base;
            uint8_t *here;
            uint8_t *stop;
        } mem;
        struct
        {
            void *data1;
        } unknown;
    } hidden;

} SDL_RWops;

SDL_RWops *SDL_RWFromFile(const char *file, const char *mode);
SDL_RWops *SDL_RWFromFP(void * fp, SDL_bool autoclose);
SDL_RWops *SDL_RWFromMem(void *mem, int size);
SDL_RWops *SDL_RWFromConstMem(const void *mem,  int size);
SDL_RWops *SDL_AllocRW(void);
void SDL_FreeRW(SDL_RWops * area);
uint16_t SDL_ReadLE16(SDL_RWops * src);
uint16_t SDL_ReadBE16(SDL_RWops * src);
uint32_t SDL_ReadLE32(SDL_RWops * src);
uint32_t SDL_ReadBE32(SDL_RWops * src);
uint64_t SDL_ReadLE64(SDL_RWops * src);
uint64_t SDL_ReadBE64(SDL_RWops * src);
size_t SDL_WriteLE16(SDL_RWops * dst, uint16_t value);
size_t SDL_WriteBE16(SDL_RWops * dst, uint16_t value);
size_t SDL_WriteLE32(SDL_RWops * dst, uint32_t value);
size_t SDL_WriteBE32(SDL_RWops * dst, uint32_t value);
size_t SDL_WriteLE64(SDL_RWops * dst, uint64_t value);
size_t SDL_WriteBE64(SDL_RWops * dst, uint64_t value);

typedef uint16_t SDL_AudioFormat;
typedef void (* SDL_AudioCallback) (void *userdata, uint8_t * stream,
                                            int len);

typedef struct SDL_AudioSpec {
    int freq;                   
    SDL_AudioFormat format;     
    uint8_t channels;             
    uint8_t silence;              
    uint16_t samples;             
    uint16_t padding;             
    uint32_t size;                
    SDL_AudioCallback callback;
    void *userdata;
} SDL_AudioSpec;

struct SDL_AudioCVT;
typedef void (* SDL_AudioFilter) (struct SDL_AudioCVT * cvt,
                                          SDL_AudioFormat format);

typedef struct SDL_AudioCVT
{
    int needed;                 
    SDL_AudioFormat src_format; 
    SDL_AudioFormat dst_format; 
    double rate_incr;           
    uint8_t *buf;                 
    int len;                    
    int len_cvt;                
    int len_mult;               
    double len_ratio;           
    SDL_AudioFilter filters[10];        
    int filter_index;           
} SDL_AudioCVT;

int SDL_GetNumAudioDrivers(void);
const char *SDL_GetAudioDriver(int index);

int SDL_AudioInit(const char *driver_name);
void SDL_AudioQuit(void);

const char *SDL_GetCurrentAudioDriver(void);

int SDL_OpenAudio(SDL_AudioSpec * desired,
                                          SDL_AudioSpec * obtained);

typedef uint32_t SDL_AudioDeviceID;

int SDL_GetNumAudioDevices(int iscapture);

const char *SDL_GetAudioDeviceName(int index,
                                                           int iscapture);

SDL_AudioDeviceID SDL_OpenAudioDevice(const char
                                                              *device,
                                                              int iscapture,
                                                              const
                                                              SDL_AudioSpec *
                                                              desired,
                                                              SDL_AudioSpec *
                                                              obtained,
                                                              int
                                                              allowed_changes);

typedef enum
{
    SDL_AUDIO_STOPPED = 0,
    SDL_AUDIO_PLAYING,
    SDL_AUDIO_PAUSED
} SDL_AudioStatus;
SDL_AudioStatus SDL_GetAudioStatus(void);

SDL_AudioStatus __cdecl
SDL_GetAudioDeviceStatus(SDL_AudioDeviceID dev);

void SDL_PauseAudio(int pause_on);
void SDL_PauseAudioDevice(SDL_AudioDeviceID dev,
                                                  int pause_on);

SDL_AudioSpec *SDL_LoadWAV_RW(SDL_RWops * src,
                                                      int freesrc,
                                                      SDL_AudioSpec * spec,
                                                      uint8_t ** audio_buf,
                                                      uint32_t * audio_len);

void SDL_FreeWAV(uint8_t * audio_buf);

int SDL_BuildAudioCVT(SDL_AudioCVT * cvt,
                                              SDL_AudioFormat src_format,
                                              uint8_t src_channels,
                                              int src_rate,
                                              SDL_AudioFormat dst_format,
                                              uint8_t dst_channels,
                                              int dst_rate);

int SDL_ConvertAudio(SDL_AudioCVT * cvt);

void SDL_MixAudio(uint8_t * dst, const uint8_t * src,
                                          uint32_t len, int volume);

void SDL_MixAudioFormat(uint8_t * dst,
                                                const uint8_t * src,
                                                SDL_AudioFormat format,
                                                uint32_t len, int volume);

void SDL_LockAudio(void);
void SDL_LockAudioDevice(SDL_AudioDeviceID dev);
void SDL_UnlockAudio(void);
void SDL_UnlockAudioDevice(SDL_AudioDeviceID dev);

void SDL_CloseAudio(void);
void SDL_CloseAudioDevice(SDL_AudioDeviceID dev);

int SDL_AudioDeviceConnected(SDL_AudioDeviceID dev);

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

int SDL_SetClipboardText(const char *text);

char * SDL_GetClipboardText(void);

SDL_bool SDL_HasClipboardText(void);

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

int SDL_GetCPUCount(void);

int SDL_GetCPUCacheLineSize(void);

SDL_bool SDL_HasRDTSC(void);

SDL_bool SDL_HasAltiVec(void);

SDL_bool SDL_HasMMX(void);

SDL_bool SDL_Has3DNow(void);

SDL_bool SDL_HasSSE(void);

SDL_bool SDL_HasSSE2(void);

SDL_bool SDL_HasSSE3(void);

SDL_bool SDL_HasSSE41(void);

SDL_bool SDL_HasSSE42(void);

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

enum
{
    SDL_PIXELTYPE_UNKNOWN,
    SDL_PIXELTYPE_INDEX1,
    SDL_PIXELTYPE_INDEX4,
    SDL_PIXELTYPE_INDEX8,
    SDL_PIXELTYPE_PACKED8,
    SDL_PIXELTYPE_PACKED16,
    SDL_PIXELTYPE_PACKED32,
    SDL_PIXELTYPE_ARRAYU8,
    SDL_PIXELTYPE_ARRAYU16,
    SDL_PIXELTYPE_ARRAYU32,
    SDL_PIXELTYPE_ARRAYF16,
    SDL_PIXELTYPE_ARRAYF32
};

enum
{
    SDL_BITMAPORDER_NONE,
    SDL_BITMAPORDER_4321,
    SDL_BITMAPORDER_1234
};

enum
{
    SDL_PACKEDORDER_NONE,
    SDL_PACKEDORDER_XRGB,
    SDL_PACKEDORDER_RGBX,
    SDL_PACKEDORDER_ARGB,
    SDL_PACKEDORDER_RGBA,
    SDL_PACKEDORDER_XBGR,
    SDL_PACKEDORDER_BGRX,
    SDL_PACKEDORDER_ABGR,
    SDL_PACKEDORDER_BGRA
};

enum
{
    SDL_ARRAYORDER_NONE,
    SDL_ARRAYORDER_RGB,
    SDL_ARRAYORDER_RGBA,
    SDL_ARRAYORDER_ARGB,
    SDL_ARRAYORDER_BGR,
    SDL_ARRAYORDER_BGRA,
    SDL_ARRAYORDER_ABGR
};

enum
{
    SDL_PACKEDLAYOUT_NONE,
    SDL_PACKEDLAYOUT_332,
    SDL_PACKEDLAYOUT_4444,
    SDL_PACKEDLAYOUT_1555,
    SDL_PACKEDLAYOUT_5551,
    SDL_PACKEDLAYOUT_565,
    SDL_PACKEDLAYOUT_8888,
    SDL_PACKEDLAYOUT_2101010,
    SDL_PACKEDLAYOUT_1010102
};

enum
{
    SDL_PIXELFORMAT_UNKNOWN,
    SDL_PIXELFORMAT_INDEX1LSB =
        ((1 << 31) | ((SDL_PIXELTYPE_INDEX1) << 24) | ((SDL_BITMAPORDER_4321) << 20) | ((0) << 16) | ((1) << 8) | ((0) << 0)),
    SDL_PIXELFORMAT_INDEX1MSB =
        ((1 << 31) | ((SDL_PIXELTYPE_INDEX1) << 24) | ((SDL_BITMAPORDER_1234) << 20) | ((0) << 16) | ((1) << 8) | ((0) << 0)),
    SDL_PIXELFORMAT_INDEX4LSB =
        ((1 << 31) | ((SDL_PIXELTYPE_INDEX4) << 24) | ((SDL_BITMAPORDER_4321) << 20) | ((0) << 16) | ((4) << 8) | ((0) << 0)),
    SDL_PIXELFORMAT_INDEX4MSB =
        ((1 << 31) | ((SDL_PIXELTYPE_INDEX4) << 24) | ((SDL_BITMAPORDER_1234) << 20) | ((0) << 16) | ((4) << 8) | ((0) << 0)),
    SDL_PIXELFORMAT_INDEX8 =
        ((1 << 31) | ((SDL_PIXELTYPE_INDEX8) << 24) | ((0) << 20) | ((0) << 16) | ((8) << 8) | ((1) << 0)),
    SDL_PIXELFORMAT_RGB332 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED8) << 24) | ((SDL_PACKEDORDER_XRGB) << 20) | ((SDL_PACKEDLAYOUT_332) << 16) | ((8) << 8) | ((1) << 0)),
    SDL_PIXELFORMAT_RGB444 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED16) << 24) | ((SDL_PACKEDORDER_XRGB) << 20) | ((SDL_PACKEDLAYOUT_4444) << 16) | ((12) << 8) | ((2) << 0)),
    SDL_PIXELFORMAT_RGB555 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED16) << 24) | ((SDL_PACKEDORDER_XRGB) << 20) | ((SDL_PACKEDLAYOUT_1555) << 16) | ((15) << 8) | ((2) << 0)),
    SDL_PIXELFORMAT_BGR555 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED16) << 24) | ((SDL_PACKEDORDER_XBGR) << 20) | ((SDL_PACKEDLAYOUT_1555) << 16) | ((15) << 8) | ((2) << 0)),
    SDL_PIXELFORMAT_ARGB4444 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED16) << 24) | ((SDL_PACKEDORDER_ARGB) << 20) | ((SDL_PACKEDLAYOUT_4444) << 16) | ((16) << 8) | ((2) << 0)),
    SDL_PIXELFORMAT_RGBA4444 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED16) << 24) | ((SDL_PACKEDORDER_RGBA) << 20) | ((SDL_PACKEDLAYOUT_4444) << 16) | ((16) << 8) | ((2) << 0)),
    SDL_PIXELFORMAT_ABGR4444 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED16) << 24) | ((SDL_PACKEDORDER_ABGR) << 20) | ((SDL_PACKEDLAYOUT_4444) << 16) | ((16) << 8) | ((2) << 0)),
    SDL_PIXELFORMAT_BGRA4444 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED16) << 24) | ((SDL_PACKEDORDER_BGRA) << 20) | ((SDL_PACKEDLAYOUT_4444) << 16) | ((16) << 8) | ((2) << 0)),
    SDL_PIXELFORMAT_ARGB1555 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED16) << 24) | ((SDL_PACKEDORDER_ARGB) << 20) | ((SDL_PACKEDLAYOUT_1555) << 16) | ((16) << 8) | ((2) << 0)),
    SDL_PIXELFORMAT_RGBA5551 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED16) << 24) | ((SDL_PACKEDORDER_RGBA) << 20) | ((SDL_PACKEDLAYOUT_5551) << 16) | ((16) << 8) | ((2) << 0)),
    SDL_PIXELFORMAT_ABGR1555 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED16) << 24) | ((SDL_PACKEDORDER_ABGR) << 20) | ((SDL_PACKEDLAYOUT_1555) << 16) | ((16) << 8) | ((2) << 0)),
    SDL_PIXELFORMAT_BGRA5551 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED16) << 24) | ((SDL_PACKEDORDER_BGRA) << 20) | ((SDL_PACKEDLAYOUT_5551) << 16) | ((16) << 8) | ((2) << 0)),
    SDL_PIXELFORMAT_RGB565 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED16) << 24) | ((SDL_PACKEDORDER_XRGB) << 20) | ((SDL_PACKEDLAYOUT_565) << 16) | ((16) << 8) | ((2) << 0)),
    SDL_PIXELFORMAT_BGR565 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED16) << 24) | ((SDL_PACKEDORDER_XBGR) << 20) | ((SDL_PACKEDLAYOUT_565) << 16) | ((16) << 8) | ((2) << 0)),
    SDL_PIXELFORMAT_RGB24 =
        ((1 << 31) | ((SDL_PIXELTYPE_ARRAYU8) << 24) | ((SDL_ARRAYORDER_RGB) << 20) | ((0) << 16) | ((24) << 8) | ((3) << 0)),
    SDL_PIXELFORMAT_BGR24 =
        ((1 << 31) | ((SDL_PIXELTYPE_ARRAYU8) << 24) | ((SDL_ARRAYORDER_BGR) << 20) | ((0) << 16) | ((24) << 8) | ((3) << 0)),
    SDL_PIXELFORMAT_RGB888 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED32) << 24) | ((SDL_PACKEDORDER_XRGB) << 20) | ((SDL_PACKEDLAYOUT_8888) << 16) | ((24) << 8) | ((4) << 0)),
    SDL_PIXELFORMAT_BGR888 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED32) << 24) | ((SDL_PACKEDORDER_XBGR) << 20) | ((SDL_PACKEDLAYOUT_8888) << 16) | ((24) << 8) | ((4) << 0)),
    SDL_PIXELFORMAT_ARGB8888 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED32) << 24) | ((SDL_PACKEDORDER_ARGB) << 20) | ((SDL_PACKEDLAYOUT_8888) << 16) | ((32) << 8) | ((4) << 0)),
    SDL_PIXELFORMAT_RGBA8888 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED32) << 24) | ((SDL_PACKEDORDER_RGBA) << 20) | ((SDL_PACKEDLAYOUT_8888) << 16) | ((32) << 8) | ((4) << 0)),
    SDL_PIXELFORMAT_ABGR8888 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED32) << 24) | ((SDL_PACKEDORDER_ABGR) << 20) | ((SDL_PACKEDLAYOUT_8888) << 16) | ((32) << 8) | ((4) << 0)),
    SDL_PIXELFORMAT_BGRA8888 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED32) << 24) | ((SDL_PACKEDORDER_BGRA) << 20) | ((SDL_PACKEDLAYOUT_8888) << 16) | ((32) << 8) | ((4) << 0)),
    SDL_PIXELFORMAT_ARGB2101010 =
        ((1 << 31) | ((SDL_PIXELTYPE_PACKED32) << 24) | ((SDL_PACKEDORDER_ARGB) << 20) | ((SDL_PACKEDLAYOUT_2101010) << 16) | ((32) << 8) | ((4) << 0)),

    SDL_PIXELFORMAT_YV12 =      
        ((((uint32_t)(((uint8_t)(('Y'))))) << 0) | (((uint32_t)(((uint8_t)(('V'))))) << 8) | (((uint32_t)(((uint8_t)(('1'))))) << 16) | (((uint32_t)(((uint8_t)(('2'))))) << 24)),
    SDL_PIXELFORMAT_IYUV =      
        ((((uint32_t)(((uint8_t)(('I'))))) << 0) | (((uint32_t)(((uint8_t)(('Y'))))) << 8) | (((uint32_t)(((uint8_t)(('U'))))) << 16) | (((uint32_t)(((uint8_t)(('V'))))) << 24)),
    SDL_PIXELFORMAT_YUY2 =      
        ((((uint32_t)(((uint8_t)(('Y'))))) << 0) | (((uint32_t)(((uint8_t)(('U'))))) << 8) | (((uint32_t)(((uint8_t)(('Y'))))) << 16) | (((uint32_t)(((uint8_t)(('2'))))) << 24)),
    SDL_PIXELFORMAT_UYVY =      
        ((((uint32_t)(((uint8_t)(('U'))))) << 0) | (((uint32_t)(((uint8_t)(('Y'))))) << 8) | (((uint32_t)(((uint8_t)(('V'))))) << 16) | (((uint32_t)(((uint8_t)(('Y'))))) << 24)),
    SDL_PIXELFORMAT_YVYU =      
        ((((uint32_t)(((uint8_t)(('Y'))))) << 0) | (((uint32_t)(((uint8_t)(('V'))))) << 8) | (((uint32_t)(((uint8_t)(('Y'))))) << 16) | (((uint32_t)(((uint8_t)(('U'))))) << 24))
};

typedef struct SDL_Color
{
    uint8_t r;
    uint8_t g;
    uint8_t b;
    uint8_t unused;
} SDL_Color;

typedef struct SDL_Palette
{
    int ncolors;
    SDL_Color *colors;
    uint32_t version;
    int refcount;
} SDL_Palette;

typedef struct SDL_PixelFormat
{
    uint32_t format;
    SDL_Palette *palette;
    uint8_t BitsPerPixel;
    uint8_t BytesPerPixel;
    uint8_t padding[2];
    uint32_t Rmask;
    uint32_t Gmask;
    uint32_t Bmask;
    uint32_t Amask;
    uint8_t Rloss;
    uint8_t Gloss;
    uint8_t Bloss;
    uint8_t Aloss;
    uint8_t Rshift;
    uint8_t Gshift;
    uint8_t Bshift;
    uint8_t Ashift;
    int refcount;
    struct SDL_PixelFormat *next;
} SDL_PixelFormat;

const char* SDL_GetPixelFormatName(uint32_t format);

SDL_bool SDL_PixelFormatEnumToMasks(uint32_t format,
                                                            int *bpp,
                                                            uint32_t * Rmask,
                                                            uint32_t * Gmask,
                                                            uint32_t * Bmask,
                                                            uint32_t * Amask);

uint32_t SDL_MasksToPixelFormatEnum(int bpp,
                                                          uint32_t Rmask,
                                                          uint32_t Gmask,
                                                          uint32_t Bmask,
                                                          uint32_t Amask);

SDL_PixelFormat * SDL_AllocFormat(uint32_t pixel_format);

void SDL_FreeFormat(SDL_PixelFormat *format);

SDL_Palette *SDL_AllocPalette(int ncolors);

int SDL_SetPixelFormatPalette(SDL_PixelFormat * format,
                                                      SDL_Palette *palette);

int SDL_SetPaletteColors(SDL_Palette * palette,
                                                 const SDL_Color * colors,
                                                 int firstcolor, int ncolors);

void SDL_FreePalette(SDL_Palette * palette);

uint32_t SDL_MapRGB(const SDL_PixelFormat * format,
                                          uint8_t r, uint8_t g, uint8_t b);

uint32_t SDL_MapRGBA(const SDL_PixelFormat * format,
                                           uint8_t r, uint8_t g, uint8_t b,
                                           uint8_t a);

void SDL_GetRGB(uint32_t pixel,
                                        const SDL_PixelFormat * format,
                                        uint8_t * r, uint8_t * g, uint8_t * b);

void SDL_GetRGBA(uint32_t pixel,
                                         const SDL_PixelFormat * format,
                                         uint8_t * r, uint8_t * g, uint8_t * b,
                                         uint8_t * a);

void SDL_CalculateGammaRamp(float gamma, uint16_t * ramp);

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

typedef struct
{
    int x;
    int y;
} SDL_Point;

typedef struct SDL_Rect
{
    int x, y;
    int w, h;
} SDL_Rect;

SDL_bool SDL_HasIntersection(const SDL_Rect * A,
                                                     const SDL_Rect * B);

SDL_bool SDL_IntersectRect(const SDL_Rect * A,
                                                   const SDL_Rect * B,
                                                   SDL_Rect * result);

void SDL_UnionRect(const SDL_Rect * A,
                                           const SDL_Rect * B,
                                           SDL_Rect * result);

SDL_bool SDL_EnclosePoints(const SDL_Point * points,
                                                   int count,
                                                   const SDL_Rect * clip,
                                                   SDL_Rect * result);

SDL_bool SDL_IntersectRectAndLine(const SDL_Rect *
                                                          rect, int *X1,
                                                          int *Y1, int *X2,
                                                          int *Y2);

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

typedef enum
{
    SDL_BLENDMODE_NONE = 0x00000000,     
    SDL_BLENDMODE_BLEND = 0x00000001,    
    SDL_BLENDMODE_ADD = 0x00000002,      
    SDL_BLENDMODE_MOD = 0x00000004       
} SDL_BlendMode;

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

typedef struct SDL_Surface
{
    uint32_t flags;               
    SDL_PixelFormat *format;    
    int w, h;                   
    int pitch;                  
    void *pixels;               

    
    void *userdata;             

    
    int locked;                 
    void *lock_data;            

    
    SDL_Rect clip_rect;         

    
    struct SDL_BlitMap *map;    

    
    int refcount;               
} SDL_Surface;

typedef int (*SDL_blit) (struct SDL_Surface * src, SDL_Rect * srcrect,
                         struct SDL_Surface * dst, SDL_Rect * dstrect);

SDL_Surface *SDL_CreateRGBSurface
    (uint32_t flags, int width, int height, int depth,
     uint32_t Rmask, uint32_t Gmask, uint32_t Bmask, uint32_t Amask);
SDL_Surface *SDL_CreateRGBSurfaceFrom(void *pixels,
                                                              int width,
                                                              int height,
                                                              int depth,
                                                              int pitch,
                                                              uint32_t Rmask,
                                                              uint32_t Gmask,
                                                              uint32_t Bmask,
                                                              uint32_t Amask);
void SDL_FreeSurface(SDL_Surface * surface);

int SDL_SetSurfacePalette(SDL_Surface * surface,
                                                  SDL_Palette * palette);

int SDL_LockSurface(SDL_Surface * surface);

void SDL_UnlockSurface(SDL_Surface * surface);

SDL_Surface *SDL_LoadBMP_RW(SDL_RWops * src,
                                                    int freesrc);

int SDL_SaveBMP_RW
    (SDL_Surface * surface, SDL_RWops * dst, int freedst);

int SDL_SetSurfaceRLE(SDL_Surface * surface,
                                              int flag);

int SDL_SetColorKey(SDL_Surface * surface,
                                            int flag, uint32_t key);

int SDL_GetColorKey(SDL_Surface * surface,
                                            uint32_t * key);

int SDL_SetSurfaceColorMod(SDL_Surface * surface,
                                                   uint8_t r, uint8_t g, uint8_t b);

int SDL_GetSurfaceColorMod(SDL_Surface * surface,
                                                   uint8_t * r, uint8_t * g,
                                                   uint8_t * b);

int SDL_SetSurfaceAlphaMod(SDL_Surface * surface,
                                                   uint8_t alpha);

int SDL_GetSurfaceAlphaMod(SDL_Surface * surface,
                                                   uint8_t * alpha);

int SDL_SetSurfaceBlendMode(SDL_Surface * surface,
                                                    SDL_BlendMode blendMode);

int SDL_GetSurfaceBlendMode(SDL_Surface * surface,
                                                    SDL_BlendMode *blendMode);

SDL_bool SDL_SetClipRect(SDL_Surface * surface,
                                                 const SDL_Rect * rect);

void SDL_GetClipRect(SDL_Surface * surface,
                                             SDL_Rect * rect);

SDL_Surface *SDL_ConvertSurface
    (SDL_Surface * src, SDL_PixelFormat * fmt, uint32_t flags);
SDL_Surface *SDL_ConvertSurfaceFormat
    (SDL_Surface * src, uint32_t pixel_format, uint32_t flags);

int SDL_ConvertPixels(int width, int height,
                                              uint32_t src_format,
                                              const void * src, int src_pitch,
                                              uint32_t dst_format,
                                              void * dst, int dst_pitch);

int SDL_FillRect
    (SDL_Surface * dst, const SDL_Rect * rect, uint32_t color);
int SDL_FillRects
    (SDL_Surface * dst, const SDL_Rect * rects, int count, uint32_t color);

int SDL_UpperBlit
    (SDL_Surface * src, const SDL_Rect * srcrect,
     SDL_Surface * dst, SDL_Rect * dstrect);

int SDL_LowerBlit
    (SDL_Surface * src, SDL_Rect * srcrect,
     SDL_Surface * dst, SDL_Rect * dstrect);

int SDL_SoftStretch(SDL_Surface * src,
                                            const SDL_Rect * srcrect,
                                            SDL_Surface * dst,
                                            const SDL_Rect * dstrect);

int SDL_UpperBlitScaled
    (SDL_Surface * src, const SDL_Rect * srcrect,
    SDL_Surface * dst, SDL_Rect * dstrect);

int SDL_LowerBlitScaled
    (SDL_Surface * src, SDL_Rect * srcrect,
    SDL_Surface * dst, SDL_Rect * dstrect);

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

typedef struct
{
    uint32_t format;              
    int w;                      
    int h;                      
    int refresh_rate;           
    void *driverdata;           
} SDL_DisplayMode;

typedef struct SDL_Window SDL_Window;

typedef enum
{
    SDL_WINDOW_FULLSCREEN = 0x00000001,         
    SDL_WINDOW_OPENGL = 0x00000002,             
    SDL_WINDOW_SHOWN = 0x00000004,              
    SDL_WINDOW_HIDDEN = 0x00000008,             
    SDL_WINDOW_BORDERLESS = 0x00000010,         
    SDL_WINDOW_RESIZABLE = 0x00000020,          
    SDL_WINDOW_MINIMIZED = 0x00000040,          
    SDL_WINDOW_MAXIMIZED = 0x00000080,          
    SDL_WINDOW_INPUT_GRABBED = 0x00000100,      
    SDL_WINDOW_INPUT_FOCUS = 0x00000200,        
    SDL_WINDOW_MOUSE_FOCUS = 0x00000400,        
    SDL_WINDOW_FOREIGN = 0x00000800             
} SDL_WindowFlags;

typedef enum
{
    SDL_WINDOWEVENT_NONE,           
    SDL_WINDOWEVENT_SHOWN,          
    SDL_WINDOWEVENT_HIDDEN,         
    SDL_WINDOWEVENT_EXPOSED,        

    SDL_WINDOWEVENT_MOVED,          

    SDL_WINDOWEVENT_RESIZED,        
    SDL_WINDOWEVENT_SIZE_CHANGED,   
    SDL_WINDOWEVENT_MINIMIZED,      
    SDL_WINDOWEVENT_MAXIMIZED,      
    SDL_WINDOWEVENT_RESTORED,       

    SDL_WINDOWEVENT_ENTER,          
    SDL_WINDOWEVENT_LEAVE,          
    SDL_WINDOWEVENT_FOCUS_GAINED,   
    SDL_WINDOWEVENT_FOCUS_LOST,     
    SDL_WINDOWEVENT_CLOSE           

} SDL_WindowEventID;

typedef void *SDL_GLContext;

typedef enum
{
    SDL_GL_RED_SIZE,
    SDL_GL_GREEN_SIZE,
    SDL_GL_BLUE_SIZE,
    SDL_GL_ALPHA_SIZE,
    SDL_GL_BUFFER_SIZE,
    SDL_GL_DOUBLEBUFFER,
    SDL_GL_DEPTH_SIZE,
    SDL_GL_STENCIL_SIZE,
    SDL_GL_ACCUM_RED_SIZE,
    SDL_GL_ACCUM_GREEN_SIZE,
    SDL_GL_ACCUM_BLUE_SIZE,
    SDL_GL_ACCUM_ALPHA_SIZE,
    SDL_GL_STEREO,
    SDL_GL_MULTISAMPLEBUFFERS,
    SDL_GL_MULTISAMPLESAMPLES,
    SDL_GL_ACCELERATED_VISUAL,
    SDL_GL_RETAINED_BACKING,
    SDL_GL_CONTEXT_MAJOR_VERSION,
    SDL_GL_CONTEXT_MINOR_VERSION
} SDL_GLattr;

int SDL_GetNumVideoDrivers(void);

const char *SDL_GetVideoDriver(int index);

int SDL_VideoInit(const char *driver_name);

void SDL_VideoQuit(void);

const char *SDL_GetCurrentVideoDriver(void);

int SDL_GetNumVideoDisplays(void);

int SDL_GetDisplayBounds(int displayIndex, SDL_Rect * rect);

int SDL_GetNumDisplayModes(int displayIndex);

int SDL_GetDisplayMode(int displayIndex, int modeIndex,
                                               SDL_DisplayMode * mode);

int SDL_GetDesktopDisplayMode(int displayIndex, SDL_DisplayMode * mode);

int SDL_GetCurrentDisplayMode(int displayIndex, SDL_DisplayMode * mode);

SDL_DisplayMode * SDL_GetClosestDisplayMode(int displayIndex, const SDL_DisplayMode * mode, SDL_DisplayMode * closest);

int SDL_GetWindowDisplay(SDL_Window * window);

int SDL_SetWindowDisplayMode(SDL_Window * window,
                                                     const SDL_DisplayMode
                                                         * mode);

int SDL_GetWindowDisplayMode(SDL_Window * window,
                                                     SDL_DisplayMode * mode);

uint32_t SDL_GetWindowPixelFormat(SDL_Window * window);

SDL_Window * SDL_CreateWindow(const char *title,
                                                      int x, int y, int w,
                                                      int h, uint32_t flags);

SDL_Window * SDL_CreateWindowFrom(const void *data);

uint32_t SDL_GetWindowID(SDL_Window * window);

SDL_Window * SDL_GetWindowFromID(uint32_t id);

uint32_t SDL_GetWindowFlags(SDL_Window * window);

void SDL_SetWindowTitle(SDL_Window * window,
                                                const char *title);

const char *SDL_GetWindowTitle(SDL_Window * window);

void SDL_SetWindowIcon(SDL_Window * window,
                                               SDL_Surface * icon);

void* SDL_SetWindowData(SDL_Window * window,
                                                const char *name,
                                                void *userdata);

void *SDL_GetWindowData(SDL_Window * window,
                                                const char *name);

void SDL_SetWindowPosition(SDL_Window * window,
                                                   int x, int y);

void SDL_GetWindowPosition(SDL_Window * window,
                                                   int *x, int *y);

void SDL_SetWindowSize(SDL_Window * window, int w,
                                               int h);

void SDL_GetWindowSize(SDL_Window * window, int *w,
                                               int *h);

void SDL_ShowWindow(SDL_Window * window);

void SDL_HideWindow(SDL_Window * window);

void SDL_RaiseWindow(SDL_Window * window);

void SDL_MaximizeWindow(SDL_Window * window);

void SDL_MinimizeWindow(SDL_Window * window);

void SDL_RestoreWindow(SDL_Window * window);

int SDL_SetWindowFullscreen(SDL_Window * window,
                                                    SDL_bool fullscreen);

SDL_Surface * SDL_GetWindowSurface(SDL_Window * window);

int SDL_UpdateWindowSurface(SDL_Window * window);

int SDL_UpdateWindowSurfaceRects(SDL_Window * window,
                                                         SDL_Rect * rects,
                                                         int numrects);

void SDL_SetWindowGrab(SDL_Window * window,
                                               SDL_bool grabbed);

SDL_bool SDL_GetWindowGrab(SDL_Window * window);

int SDL_SetWindowBrightness(SDL_Window * window, float brightness);

float SDL_GetWindowBrightness(SDL_Window * window);

int SDL_SetWindowGammaRamp(SDL_Window * window,
                                                   const uint16_t * red,
                                                   const uint16_t * green,
                                                   const uint16_t * blue);

int SDL_GetWindowGammaRamp(SDL_Window * window,
                                                   uint16_t * red,
                                                   uint16_t * green,
                                                   uint16_t * blue);

void SDL_DestroyWindow(SDL_Window * window);

SDL_bool SDL_IsScreenSaverEnabled(void);

void SDL_EnableScreenSaver(void);

void SDL_DisableScreenSaver(void);

int SDL_GL_LoadLibrary(const char *path);

void *SDL_GL_GetProcAddress(const char *proc);

void SDL_GL_UnloadLibrary(void);

SDL_bool SDL_GL_ExtensionSupported(const char
                                                           *extension);

int SDL_GL_SetAttribute(SDL_GLattr attr, int value);

int SDL_GL_GetAttribute(SDL_GLattr attr, int *value);

SDL_GLContext SDL_GL_CreateContext(SDL_Window *
                                                           window);

int SDL_GL_MakeCurrent(SDL_Window * window,
                                               SDL_GLContext context);

int SDL_GL_SetSwapInterval(int interval);

int SDL_GL_GetSwapInterval(void);

void SDL_GL_SwapWindow(SDL_Window * window);

void SDL_GL_DeleteContext(SDL_GLContext context);

#pragma pack(pop)

typedef enum
{
    SDL_SCANCODE_UNKNOWN = 0,

    

    

    SDL_SCANCODE_A = 4,
    SDL_SCANCODE_B = 5,
    SDL_SCANCODE_C = 6,
    SDL_SCANCODE_D = 7,
    SDL_SCANCODE_E = 8,
    SDL_SCANCODE_F = 9,
    SDL_SCANCODE_G = 10,
    SDL_SCANCODE_H = 11,
    SDL_SCANCODE_I = 12,
    SDL_SCANCODE_J = 13,
    SDL_SCANCODE_K = 14,
    SDL_SCANCODE_L = 15,
    SDL_SCANCODE_M = 16,
    SDL_SCANCODE_N = 17,
    SDL_SCANCODE_O = 18,
    SDL_SCANCODE_P = 19,
    SDL_SCANCODE_Q = 20,
    SDL_SCANCODE_R = 21,
    SDL_SCANCODE_S = 22,
    SDL_SCANCODE_T = 23,
    SDL_SCANCODE_U = 24,
    SDL_SCANCODE_V = 25,
    SDL_SCANCODE_W = 26,
    SDL_SCANCODE_X = 27,
    SDL_SCANCODE_Y = 28,
    SDL_SCANCODE_Z = 29,

    SDL_SCANCODE_1 = 30,
    SDL_SCANCODE_2 = 31,
    SDL_SCANCODE_3 = 32,
    SDL_SCANCODE_4 = 33,
    SDL_SCANCODE_5 = 34,
    SDL_SCANCODE_6 = 35,
    SDL_SCANCODE_7 = 36,
    SDL_SCANCODE_8 = 37,
    SDL_SCANCODE_9 = 38,
    SDL_SCANCODE_0 = 39,

    SDL_SCANCODE_RETURN = 40,
    SDL_SCANCODE_ESCAPE = 41,
    SDL_SCANCODE_BACKSPACE = 42,
    SDL_SCANCODE_TAB = 43,
    SDL_SCANCODE_SPACE = 44,

    SDL_SCANCODE_MINUS = 45,
    SDL_SCANCODE_EQUALS = 46,
    SDL_SCANCODE_LEFTBRACKET = 47,
    SDL_SCANCODE_RIGHTBRACKET = 48,
    SDL_SCANCODE_BACKSLASH = 49, 

    SDL_SCANCODE_NONUSHASH = 50, 

    SDL_SCANCODE_SEMICOLON = 51,
    SDL_SCANCODE_APOSTROPHE = 52,
    SDL_SCANCODE_GRAVE = 53, 

    SDL_SCANCODE_COMMA = 54,
    SDL_SCANCODE_PERIOD = 55,
    SDL_SCANCODE_SLASH = 56,

    SDL_SCANCODE_CAPSLOCK = 57,

    SDL_SCANCODE_F1 = 58,
    SDL_SCANCODE_F2 = 59,
    SDL_SCANCODE_F3 = 60,
    SDL_SCANCODE_F4 = 61,
    SDL_SCANCODE_F5 = 62,
    SDL_SCANCODE_F6 = 63,
    SDL_SCANCODE_F7 = 64,
    SDL_SCANCODE_F8 = 65,
    SDL_SCANCODE_F9 = 66,
    SDL_SCANCODE_F10 = 67,
    SDL_SCANCODE_F11 = 68,
    SDL_SCANCODE_F12 = 69,

    SDL_SCANCODE_PRINTSCREEN = 70,
    SDL_SCANCODE_SCROLLLOCK = 71,
    SDL_SCANCODE_PAUSE = 72,
    SDL_SCANCODE_INSERT = 73, 

    SDL_SCANCODE_HOME = 74,
    SDL_SCANCODE_PAGEUP = 75,
    SDL_SCANCODE_DELETE = 76,
    SDL_SCANCODE_END = 77,
    SDL_SCANCODE_PAGEDOWN = 78,
    SDL_SCANCODE_RIGHT = 79,
    SDL_SCANCODE_LEFT = 80,
    SDL_SCANCODE_DOWN = 81,
    SDL_SCANCODE_UP = 82,

    SDL_SCANCODE_NUMLOCKCLEAR = 83, 

    SDL_SCANCODE_KP_DIVIDE = 84,
    SDL_SCANCODE_KP_MULTIPLY = 85,
    SDL_SCANCODE_KP_MINUS = 86,
    SDL_SCANCODE_KP_PLUS = 87,
    SDL_SCANCODE_KP_ENTER = 88,
    SDL_SCANCODE_KP_1 = 89,
    SDL_SCANCODE_KP_2 = 90,
    SDL_SCANCODE_KP_3 = 91,
    SDL_SCANCODE_KP_4 = 92,
    SDL_SCANCODE_KP_5 = 93,
    SDL_SCANCODE_KP_6 = 94,
    SDL_SCANCODE_KP_7 = 95,
    SDL_SCANCODE_KP_8 = 96,
    SDL_SCANCODE_KP_9 = 97,
    SDL_SCANCODE_KP_0 = 98,
    SDL_SCANCODE_KP_PERIOD = 99,

    SDL_SCANCODE_NONUSBACKSLASH = 100, 

    SDL_SCANCODE_APPLICATION = 101, 
    SDL_SCANCODE_POWER = 102, 

    SDL_SCANCODE_KP_EQUALS = 103,
    SDL_SCANCODE_F13 = 104,
    SDL_SCANCODE_F14 = 105,
    SDL_SCANCODE_F15 = 106,
    SDL_SCANCODE_F16 = 107,
    SDL_SCANCODE_F17 = 108,
    SDL_SCANCODE_F18 = 109,
    SDL_SCANCODE_F19 = 110,
    SDL_SCANCODE_F20 = 111,
    SDL_SCANCODE_F21 = 112,
    SDL_SCANCODE_F22 = 113,
    SDL_SCANCODE_F23 = 114,
    SDL_SCANCODE_F24 = 115,
    SDL_SCANCODE_EXECUTE = 116,
    SDL_SCANCODE_HELP = 117,
    SDL_SCANCODE_MENU = 118,
    SDL_SCANCODE_SELECT = 119,
    SDL_SCANCODE_STOP = 120,
    SDL_SCANCODE_AGAIN = 121,   
    SDL_SCANCODE_UNDO = 122,
    SDL_SCANCODE_CUT = 123,
    SDL_SCANCODE_COPY = 124,
    SDL_SCANCODE_PASTE = 125,
    SDL_SCANCODE_FIND = 126,
    SDL_SCANCODE_MUTE = 127,
    SDL_SCANCODE_VOLUMEUP = 128,
    SDL_SCANCODE_VOLUMEDOWN = 129,

    SDL_SCANCODE_KP_COMMA = 133,
    SDL_SCANCODE_KP_EQUALSAS400 = 134,

    SDL_SCANCODE_INTERNATIONAL1 = 135, 

    SDL_SCANCODE_INTERNATIONAL2 = 136,
    SDL_SCANCODE_INTERNATIONAL3 = 137, 
    SDL_SCANCODE_INTERNATIONAL4 = 138,
    SDL_SCANCODE_INTERNATIONAL5 = 139,
    SDL_SCANCODE_INTERNATIONAL6 = 140,
    SDL_SCANCODE_INTERNATIONAL7 = 141,
    SDL_SCANCODE_INTERNATIONAL8 = 142,
    SDL_SCANCODE_INTERNATIONAL9 = 143,
    SDL_SCANCODE_LANG1 = 144, 
    SDL_SCANCODE_LANG2 = 145, 
    SDL_SCANCODE_LANG3 = 146, 
    SDL_SCANCODE_LANG4 = 147, 
    SDL_SCANCODE_LANG5 = 148, 
    SDL_SCANCODE_LANG6 = 149, 
    SDL_SCANCODE_LANG7 = 150, 
    SDL_SCANCODE_LANG8 = 151, 
    SDL_SCANCODE_LANG9 = 152, 

    SDL_SCANCODE_ALTERASE = 153, 
    SDL_SCANCODE_SYSREQ = 154,
    SDL_SCANCODE_CANCEL = 155,
    SDL_SCANCODE_CLEAR = 156,
    SDL_SCANCODE_PRIOR = 157,
    SDL_SCANCODE_RETURN2 = 158,
    SDL_SCANCODE_SEPARATOR = 159,
    SDL_SCANCODE_OUT = 160,
    SDL_SCANCODE_OPER = 161,
    SDL_SCANCODE_CLEARAGAIN = 162,
    SDL_SCANCODE_CRSEL = 163,
    SDL_SCANCODE_EXSEL = 164,

    SDL_SCANCODE_KP_00 = 176,
    SDL_SCANCODE_KP_000 = 177,
    SDL_SCANCODE_THOUSANDSSEPARATOR = 178,
    SDL_SCANCODE_DECIMALSEPARATOR = 179,
    SDL_SCANCODE_CURRENCYUNIT = 180,
    SDL_SCANCODE_CURRENCYSUBUNIT = 181,
    SDL_SCANCODE_KP_LEFTPAREN = 182,
    SDL_SCANCODE_KP_RIGHTPAREN = 183,
    SDL_SCANCODE_KP_LEFTBRACE = 184,
    SDL_SCANCODE_KP_RIGHTBRACE = 185,
    SDL_SCANCODE_KP_TAB = 186,
    SDL_SCANCODE_KP_BACKSPACE = 187,
    SDL_SCANCODE_KP_A = 188,
    SDL_SCANCODE_KP_B = 189,
    SDL_SCANCODE_KP_C = 190,
    SDL_SCANCODE_KP_D = 191,
    SDL_SCANCODE_KP_E = 192,
    SDL_SCANCODE_KP_F = 193,
    SDL_SCANCODE_KP_XOR = 194,
    SDL_SCANCODE_KP_POWER = 195,
    SDL_SCANCODE_KP_PERCENT = 196,
    SDL_SCANCODE_KP_LESS = 197,
    SDL_SCANCODE_KP_GREATER = 198,
    SDL_SCANCODE_KP_AMPERSAND = 199,
    SDL_SCANCODE_KP_DBLAMPERSAND = 200,
    SDL_SCANCODE_KP_VERTICALBAR = 201,
    SDL_SCANCODE_KP_DBLVERTICALBAR = 202,
    SDL_SCANCODE_KP_COLON = 203,
    SDL_SCANCODE_KP_HASH = 204,
    SDL_SCANCODE_KP_SPACE = 205,
    SDL_SCANCODE_KP_AT = 206,
    SDL_SCANCODE_KP_EXCLAM = 207,
    SDL_SCANCODE_KP_MEMSTORE = 208,
    SDL_SCANCODE_KP_MEMRECALL = 209,
    SDL_SCANCODE_KP_MEMCLEAR = 210,
    SDL_SCANCODE_KP_MEMADD = 211,
    SDL_SCANCODE_KP_MEMSUBTRACT = 212,
    SDL_SCANCODE_KP_MEMMULTIPLY = 213,
    SDL_SCANCODE_KP_MEMDIVIDE = 214,
    SDL_SCANCODE_KP_PLUSMINUS = 215,
    SDL_SCANCODE_KP_CLEAR = 216,
    SDL_SCANCODE_KP_CLEARENTRY = 217,
    SDL_SCANCODE_KP_BINARY = 218,
    SDL_SCANCODE_KP_OCTAL = 219,
    SDL_SCANCODE_KP_DECIMAL = 220,
    SDL_SCANCODE_KP_HEXADECIMAL = 221,

    SDL_SCANCODE_LCTRL = 224,
    SDL_SCANCODE_LSHIFT = 225,
    SDL_SCANCODE_LALT = 226, 
    SDL_SCANCODE_LGUI = 227, 
    SDL_SCANCODE_RCTRL = 228,
    SDL_SCANCODE_RSHIFT = 229,
    SDL_SCANCODE_RALT = 230, 
    SDL_SCANCODE_RGUI = 231, 

    SDL_SCANCODE_MODE = 257,    

    

    

    

    SDL_SCANCODE_AUDIONEXT = 258,
    SDL_SCANCODE_AUDIOPREV = 259,
    SDL_SCANCODE_AUDIOSTOP = 260,
    SDL_SCANCODE_AUDIOPLAY = 261,
    SDL_SCANCODE_AUDIOMUTE = 262,
    SDL_SCANCODE_MEDIASELECT = 263,
    SDL_SCANCODE_WWW = 264,
    SDL_SCANCODE_MAIL = 265,
    SDL_SCANCODE_CALCULATOR = 266,
    SDL_SCANCODE_COMPUTER = 267,
    SDL_SCANCODE_AC_SEARCH = 268,
    SDL_SCANCODE_AC_HOME = 269,
    SDL_SCANCODE_AC_BACK = 270,
    SDL_SCANCODE_AC_FORWARD = 271,
    SDL_SCANCODE_AC_STOP = 272,
    SDL_SCANCODE_AC_REFRESH = 273,
    SDL_SCANCODE_AC_BOOKMARKS = 274,
    

    

    

    SDL_SCANCODE_BRIGHTNESSDOWN = 275,
    SDL_SCANCODE_BRIGHTNESSUP = 276,
    SDL_SCANCODE_DISPLAYSWITCH = 277, 

    SDL_SCANCODE_KBDILLUMTOGGLE = 278,
    SDL_SCANCODE_KBDILLUMDOWN = 279,
    SDL_SCANCODE_KBDILLUMUP = 280,
    SDL_SCANCODE_EJECT = 281,
    SDL_SCANCODE_SLEEP = 282,
    

    

    SDL_NUM_SCANCODES = 512 

} SDL_Scancode;

typedef int32_t SDL_Keycode;

enum
{
    SDLK_UNKNOWN = 0,

    SDLK_RETURN = '\r',
    SDLK_ESCAPE = '\033',
    SDLK_BACKSPACE = '\b',
    SDLK_TAB = '\t',
    SDLK_SPACE = ' ',
    SDLK_EXCLAIM = '!',
    SDLK_QUOTEDBL = '"',
    SDLK_HASH = '#',
    SDLK_PERCENT = '%',
    SDLK_DOLLAR = '$',
    SDLK_AMPERSAND = '&',
    SDLK_QUOTE = '\'',
    SDLK_LEFTPAREN = '(',
    SDLK_RIGHTPAREN = ')',
    SDLK_ASTERISK = '*',
    SDLK_PLUS = '+',
    SDLK_COMMA = ',',
    SDLK_MINUS = '-',
    SDLK_PERIOD = '.',
    SDLK_SLASH = '/',
    SDLK_0 = '0',
    SDLK_1 = '1',
    SDLK_2 = '2',
    SDLK_3 = '3',
    SDLK_4 = '4',
    SDLK_5 = '5',
    SDLK_6 = '6',
    SDLK_7 = '7',
    SDLK_8 = '8',
    SDLK_9 = '9',
    SDLK_COLON = ':',
    SDLK_SEMICOLON = ';',
    SDLK_LESS = '<',
    SDLK_EQUALS = '=',
    SDLK_GREATER = '>',
    SDLK_QUESTION = '?',
    SDLK_AT = '@',
    

    SDLK_LEFTBRACKET = '[',
    SDLK_BACKSLASH = '\\',
    SDLK_RIGHTBRACKET = ']',
    SDLK_CARET = '^',
    SDLK_UNDERSCORE = '_',
    SDLK_BACKQUOTE = '`',
    SDLK_a = 'a',
    SDLK_b = 'b',
    SDLK_c = 'c',
    SDLK_d = 'd',
    SDLK_e = 'e',
    SDLK_f = 'f',
    SDLK_g = 'g',
    SDLK_h = 'h',
    SDLK_i = 'i',
    SDLK_j = 'j',
    SDLK_k = 'k',
    SDLK_l = 'l',
    SDLK_m = 'm',
    SDLK_n = 'n',
    SDLK_o = 'o',
    SDLK_p = 'p',
    SDLK_q = 'q',
    SDLK_r = 'r',
    SDLK_s = 's',
    SDLK_t = 't',
    SDLK_u = 'u',
    SDLK_v = 'v',
    SDLK_w = 'w',
    SDLK_x = 'x',
    SDLK_y = 'y',
    SDLK_z = 'z',

    SDLK_CAPSLOCK = (SDL_SCANCODE_CAPSLOCK | (1<<30)),

    SDLK_F1 = (SDL_SCANCODE_F1 | (1<<30)),
    SDLK_F2 = (SDL_SCANCODE_F2 | (1<<30)),
    SDLK_F3 = (SDL_SCANCODE_F3 | (1<<30)),
    SDLK_F4 = (SDL_SCANCODE_F4 | (1<<30)),
    SDLK_F5 = (SDL_SCANCODE_F5 | (1<<30)),
    SDLK_F6 = (SDL_SCANCODE_F6 | (1<<30)),
    SDLK_F7 = (SDL_SCANCODE_F7 | (1<<30)),
    SDLK_F8 = (SDL_SCANCODE_F8 | (1<<30)),
    SDLK_F9 = (SDL_SCANCODE_F9 | (1<<30)),
    SDLK_F10 = (SDL_SCANCODE_F10 | (1<<30)),
    SDLK_F11 = (SDL_SCANCODE_F11 | (1<<30)),
    SDLK_F12 = (SDL_SCANCODE_F12 | (1<<30)),

    SDLK_PRINTSCREEN = (SDL_SCANCODE_PRINTSCREEN | (1<<30)),
    SDLK_SCROLLLOCK = (SDL_SCANCODE_SCROLLLOCK | (1<<30)),
    SDLK_PAUSE = (SDL_SCANCODE_PAUSE | (1<<30)),
    SDLK_INSERT = (SDL_SCANCODE_INSERT | (1<<30)),
    SDLK_HOME = (SDL_SCANCODE_HOME | (1<<30)),
    SDLK_PAGEUP = (SDL_SCANCODE_PAGEUP | (1<<30)),
    SDLK_DELETE = '\177',
    SDLK_END = (SDL_SCANCODE_END | (1<<30)),
    SDLK_PAGEDOWN = (SDL_SCANCODE_PAGEDOWN | (1<<30)),
    SDLK_RIGHT = (SDL_SCANCODE_RIGHT | (1<<30)),
    SDLK_LEFT = (SDL_SCANCODE_LEFT | (1<<30)),
    SDLK_DOWN = (SDL_SCANCODE_DOWN | (1<<30)),
    SDLK_UP = (SDL_SCANCODE_UP | (1<<30)),

    SDLK_NUMLOCKCLEAR = (SDL_SCANCODE_NUMLOCKCLEAR | (1<<30)),
    SDLK_KP_DIVIDE = (SDL_SCANCODE_KP_DIVIDE | (1<<30)),
    SDLK_KP_MULTIPLY = (SDL_SCANCODE_KP_MULTIPLY | (1<<30)),
    SDLK_KP_MINUS = (SDL_SCANCODE_KP_MINUS | (1<<30)),
    SDLK_KP_PLUS = (SDL_SCANCODE_KP_PLUS | (1<<30)),
    SDLK_KP_ENTER = (SDL_SCANCODE_KP_ENTER | (1<<30)),
    SDLK_KP_1 = (SDL_SCANCODE_KP_1 | (1<<30)),
    SDLK_KP_2 = (SDL_SCANCODE_KP_2 | (1<<30)),
    SDLK_KP_3 = (SDL_SCANCODE_KP_3 | (1<<30)),
    SDLK_KP_4 = (SDL_SCANCODE_KP_4 | (1<<30)),
    SDLK_KP_5 = (SDL_SCANCODE_KP_5 | (1<<30)),
    SDLK_KP_6 = (SDL_SCANCODE_KP_6 | (1<<30)),
    SDLK_KP_7 = (SDL_SCANCODE_KP_7 | (1<<30)),
    SDLK_KP_8 = (SDL_SCANCODE_KP_8 | (1<<30)),
    SDLK_KP_9 = (SDL_SCANCODE_KP_9 | (1<<30)),
    SDLK_KP_0 = (SDL_SCANCODE_KP_0 | (1<<30)),
    SDLK_KP_PERIOD = (SDL_SCANCODE_KP_PERIOD | (1<<30)),

    SDLK_APPLICATION = (SDL_SCANCODE_APPLICATION | (1<<30)),
    SDLK_POWER = (SDL_SCANCODE_POWER | (1<<30)),
    SDLK_KP_EQUALS = (SDL_SCANCODE_KP_EQUALS | (1<<30)),
    SDLK_F13 = (SDL_SCANCODE_F13 | (1<<30)),
    SDLK_F14 = (SDL_SCANCODE_F14 | (1<<30)),
    SDLK_F15 = (SDL_SCANCODE_F15 | (1<<30)),
    SDLK_F16 = (SDL_SCANCODE_F16 | (1<<30)),
    SDLK_F17 = (SDL_SCANCODE_F17 | (1<<30)),
    SDLK_F18 = (SDL_SCANCODE_F18 | (1<<30)),
    SDLK_F19 = (SDL_SCANCODE_F19 | (1<<30)),
    SDLK_F20 = (SDL_SCANCODE_F20 | (1<<30)),
    SDLK_F21 = (SDL_SCANCODE_F21 | (1<<30)),
    SDLK_F22 = (SDL_SCANCODE_F22 | (1<<30)),
    SDLK_F23 = (SDL_SCANCODE_F23 | (1<<30)),
    SDLK_F24 = (SDL_SCANCODE_F24 | (1<<30)),
    SDLK_EXECUTE = (SDL_SCANCODE_EXECUTE | (1<<30)),
    SDLK_HELP = (SDL_SCANCODE_HELP | (1<<30)),
    SDLK_MENU = (SDL_SCANCODE_MENU | (1<<30)),
    SDLK_SELECT = (SDL_SCANCODE_SELECT | (1<<30)),
    SDLK_STOP = (SDL_SCANCODE_STOP | (1<<30)),
    SDLK_AGAIN = (SDL_SCANCODE_AGAIN | (1<<30)),
    SDLK_UNDO = (SDL_SCANCODE_UNDO | (1<<30)),
    SDLK_CUT = (SDL_SCANCODE_CUT | (1<<30)),
    SDLK_COPY = (SDL_SCANCODE_COPY | (1<<30)),
    SDLK_PASTE = (SDL_SCANCODE_PASTE | (1<<30)),
    SDLK_FIND = (SDL_SCANCODE_FIND | (1<<30)),
    SDLK_MUTE = (SDL_SCANCODE_MUTE | (1<<30)),
    SDLK_VOLUMEUP = (SDL_SCANCODE_VOLUMEUP | (1<<30)),
    SDLK_VOLUMEDOWN = (SDL_SCANCODE_VOLUMEDOWN | (1<<30)),
    SDLK_KP_COMMA = (SDL_SCANCODE_KP_COMMA | (1<<30)),
    SDLK_KP_EQUALSAS400 =
        (SDL_SCANCODE_KP_EQUALSAS400 | (1<<30)),

    SDLK_ALTERASE = (SDL_SCANCODE_ALTERASE | (1<<30)),
    SDLK_SYSREQ = (SDL_SCANCODE_SYSREQ | (1<<30)),
    SDLK_CANCEL = (SDL_SCANCODE_CANCEL | (1<<30)),
    SDLK_CLEAR = (SDL_SCANCODE_CLEAR | (1<<30)),
    SDLK_PRIOR = (SDL_SCANCODE_PRIOR | (1<<30)),
    SDLK_RETURN2 = (SDL_SCANCODE_RETURN2 | (1<<30)),
    SDLK_SEPARATOR = (SDL_SCANCODE_SEPARATOR | (1<<30)),
    SDLK_OUT = (SDL_SCANCODE_OUT | (1<<30)),
    SDLK_OPER = (SDL_SCANCODE_OPER | (1<<30)),
    SDLK_CLEARAGAIN = (SDL_SCANCODE_CLEARAGAIN | (1<<30)),
    SDLK_CRSEL = (SDL_SCANCODE_CRSEL | (1<<30)),
    SDLK_EXSEL = (SDL_SCANCODE_EXSEL | (1<<30)),

    SDLK_KP_00 = (SDL_SCANCODE_KP_00 | (1<<30)),
    SDLK_KP_000 = (SDL_SCANCODE_KP_000 | (1<<30)),
    SDLK_THOUSANDSSEPARATOR =
        (SDL_SCANCODE_THOUSANDSSEPARATOR | (1<<30)),
    SDLK_DECIMALSEPARATOR =
        (SDL_SCANCODE_DECIMALSEPARATOR | (1<<30)),
    SDLK_CURRENCYUNIT = (SDL_SCANCODE_CURRENCYUNIT | (1<<30)),
    SDLK_CURRENCYSUBUNIT =
        (SDL_SCANCODE_CURRENCYSUBUNIT | (1<<30)),
    SDLK_KP_LEFTPAREN = (SDL_SCANCODE_KP_LEFTPAREN | (1<<30)),
    SDLK_KP_RIGHTPAREN = (SDL_SCANCODE_KP_RIGHTPAREN | (1<<30)),
    SDLK_KP_LEFTBRACE = (SDL_SCANCODE_KP_LEFTBRACE | (1<<30)),
    SDLK_KP_RIGHTBRACE = (SDL_SCANCODE_KP_RIGHTBRACE | (1<<30)),
    SDLK_KP_TAB = (SDL_SCANCODE_KP_TAB | (1<<30)),
    SDLK_KP_BACKSPACE = (SDL_SCANCODE_KP_BACKSPACE | (1<<30)),
    SDLK_KP_A = (SDL_SCANCODE_KP_A | (1<<30)),
    SDLK_KP_B = (SDL_SCANCODE_KP_B | (1<<30)),
    SDLK_KP_C = (SDL_SCANCODE_KP_C | (1<<30)),
    SDLK_KP_D = (SDL_SCANCODE_KP_D | (1<<30)),
    SDLK_KP_E = (SDL_SCANCODE_KP_E | (1<<30)),
    SDLK_KP_F = (SDL_SCANCODE_KP_F | (1<<30)),
    SDLK_KP_XOR = (SDL_SCANCODE_KP_XOR | (1<<30)),
    SDLK_KP_POWER = (SDL_SCANCODE_KP_POWER | (1<<30)),
    SDLK_KP_PERCENT = (SDL_SCANCODE_KP_PERCENT | (1<<30)),
    SDLK_KP_LESS = (SDL_SCANCODE_KP_LESS | (1<<30)),
    SDLK_KP_GREATER = (SDL_SCANCODE_KP_GREATER | (1<<30)),
    SDLK_KP_AMPERSAND = (SDL_SCANCODE_KP_AMPERSAND | (1<<30)),
    SDLK_KP_DBLAMPERSAND =
        (SDL_SCANCODE_KP_DBLAMPERSAND | (1<<30)),
    SDLK_KP_VERTICALBAR =
        (SDL_SCANCODE_KP_VERTICALBAR | (1<<30)),
    SDLK_KP_DBLVERTICALBAR =
        (SDL_SCANCODE_KP_DBLVERTICALBAR | (1<<30)),
    SDLK_KP_COLON = (SDL_SCANCODE_KP_COLON | (1<<30)),
    SDLK_KP_HASH = (SDL_SCANCODE_KP_HASH | (1<<30)),
    SDLK_KP_SPACE = (SDL_SCANCODE_KP_SPACE | (1<<30)),
    SDLK_KP_AT = (SDL_SCANCODE_KP_AT | (1<<30)),
    SDLK_KP_EXCLAM = (SDL_SCANCODE_KP_EXCLAM | (1<<30)),
    SDLK_KP_MEMSTORE = (SDL_SCANCODE_KP_MEMSTORE | (1<<30)),
    SDLK_KP_MEMRECALL = (SDL_SCANCODE_KP_MEMRECALL | (1<<30)),
    SDLK_KP_MEMCLEAR = (SDL_SCANCODE_KP_MEMCLEAR | (1<<30)),
    SDLK_KP_MEMADD = (SDL_SCANCODE_KP_MEMADD | (1<<30)),
    SDLK_KP_MEMSUBTRACT =
        (SDL_SCANCODE_KP_MEMSUBTRACT | (1<<30)),
    SDLK_KP_MEMMULTIPLY =
        (SDL_SCANCODE_KP_MEMMULTIPLY | (1<<30)),
    SDLK_KP_MEMDIVIDE = (SDL_SCANCODE_KP_MEMDIVIDE | (1<<30)),
    SDLK_KP_PLUSMINUS = (SDL_SCANCODE_KP_PLUSMINUS | (1<<30)),
    SDLK_KP_CLEAR = (SDL_SCANCODE_KP_CLEAR | (1<<30)),
    SDLK_KP_CLEARENTRY = (SDL_SCANCODE_KP_CLEARENTRY | (1<<30)),
    SDLK_KP_BINARY = (SDL_SCANCODE_KP_BINARY | (1<<30)),
    SDLK_KP_OCTAL = (SDL_SCANCODE_KP_OCTAL | (1<<30)),
    SDLK_KP_DECIMAL = (SDL_SCANCODE_KP_DECIMAL | (1<<30)),
    SDLK_KP_HEXADECIMAL =
        (SDL_SCANCODE_KP_HEXADECIMAL | (1<<30)),

    SDLK_LCTRL = (SDL_SCANCODE_LCTRL | (1<<30)),
    SDLK_LSHIFT = (SDL_SCANCODE_LSHIFT | (1<<30)),
    SDLK_LALT = (SDL_SCANCODE_LALT | (1<<30)),
    SDLK_LGUI = (SDL_SCANCODE_LGUI | (1<<30)),
    SDLK_RCTRL = (SDL_SCANCODE_RCTRL | (1<<30)),
    SDLK_RSHIFT = (SDL_SCANCODE_RSHIFT | (1<<30)),
    SDLK_RALT = (SDL_SCANCODE_RALT | (1<<30)),
    SDLK_RGUI = (SDL_SCANCODE_RGUI | (1<<30)),

    SDLK_MODE = (SDL_SCANCODE_MODE | (1<<30)),

    SDLK_AUDIONEXT = (SDL_SCANCODE_AUDIONEXT | (1<<30)),
    SDLK_AUDIOPREV = (SDL_SCANCODE_AUDIOPREV | (1<<30)),
    SDLK_AUDIOSTOP = (SDL_SCANCODE_AUDIOSTOP | (1<<30)),
    SDLK_AUDIOPLAY = (SDL_SCANCODE_AUDIOPLAY | (1<<30)),
    SDLK_AUDIOMUTE = (SDL_SCANCODE_AUDIOMUTE | (1<<30)),
    SDLK_MEDIASELECT = (SDL_SCANCODE_MEDIASELECT | (1<<30)),
    SDLK_WWW = (SDL_SCANCODE_WWW | (1<<30)),
    SDLK_MAIL = (SDL_SCANCODE_MAIL | (1<<30)),
    SDLK_CALCULATOR = (SDL_SCANCODE_CALCULATOR | (1<<30)),
    SDLK_COMPUTER = (SDL_SCANCODE_COMPUTER | (1<<30)),
    SDLK_AC_SEARCH = (SDL_SCANCODE_AC_SEARCH | (1<<30)),
    SDLK_AC_HOME = (SDL_SCANCODE_AC_HOME | (1<<30)),
    SDLK_AC_BACK = (SDL_SCANCODE_AC_BACK | (1<<30)),
    SDLK_AC_FORWARD = (SDL_SCANCODE_AC_FORWARD | (1<<30)),
    SDLK_AC_STOP = (SDL_SCANCODE_AC_STOP | (1<<30)),
    SDLK_AC_REFRESH = (SDL_SCANCODE_AC_REFRESH | (1<<30)),
    SDLK_AC_BOOKMARKS = (SDL_SCANCODE_AC_BOOKMARKS | (1<<30)),

    SDLK_BRIGHTNESSDOWN =
        (SDL_SCANCODE_BRIGHTNESSDOWN | (1<<30)),
    SDLK_BRIGHTNESSUP = (SDL_SCANCODE_BRIGHTNESSUP | (1<<30)),
    SDLK_DISPLAYSWITCH = (SDL_SCANCODE_DISPLAYSWITCH | (1<<30)),
    SDLK_KBDILLUMTOGGLE =
        (SDL_SCANCODE_KBDILLUMTOGGLE | (1<<30)),
    SDLK_KBDILLUMDOWN = (SDL_SCANCODE_KBDILLUMDOWN | (1<<30)),
    SDLK_KBDILLUMUP = (SDL_SCANCODE_KBDILLUMUP | (1<<30)),
    SDLK_EJECT = (SDL_SCANCODE_EJECT | (1<<30)),
    SDLK_SLEEP = (SDL_SCANCODE_SLEEP | (1<<30))
};

typedef enum
{
    KMOD_NONE = 0x0000,
    KMOD_LSHIFT = 0x0001,
    KMOD_RSHIFT = 0x0002,
    KMOD_LCTRL = 0x0040,
    KMOD_RCTRL = 0x0080,
    KMOD_LALT = 0x0100,
    KMOD_RALT = 0x0200,
    KMOD_LGUI = 0x0400,
    KMOD_RGUI = 0x0800,
    KMOD_NUM = 0x1000,
    KMOD_CAPS = 0x2000,
    KMOD_MODE = 0x4000,
    KMOD_RESERVED = 0x8000
} SDL_Keymod;

#pragma warning(disable: 4103)

#pragma pack(push,4)

typedef struct SDL_Keysym
{
    SDL_Scancode scancode;      
    SDL_Keycode sym;            
    uint16_t mod;                 
    uint32_t unicode;             
} SDL_Keysym;

SDL_Window * SDL_GetKeyboardFocus(void);

uint8_t *SDL_GetKeyboardState(int *numkeys);

SDL_Keymod SDL_GetModState(void);

void SDL_SetModState(SDL_Keymod modstate);

SDL_Keycode SDL_GetKeyFromScancode(SDL_Scancode scancode);

SDL_Scancode SDL_GetScancodeFromKey(SDL_Keycode key);

const char *SDL_GetScancodeName(SDL_Scancode
                                                        scancode);

const char *SDL_GetKeyName(SDL_Keycode key);

void SDL_StartTextInput(void);

void SDL_StopTextInput(void);

void SDL_SetTextInputRect(SDL_Rect *rect);

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

typedef struct SDL_Cursor SDL_Cursor;   

SDL_Window * SDL_GetMouseFocus(void);

uint8_t SDL_GetMouseState(int *x, int *y);

uint8_t SDL_GetRelativeMouseState(int *x, int *y);

void SDL_WarpMouseInWindow(SDL_Window * window,
                                                   int x, int y);

int SDL_SetRelativeMouseMode(SDL_bool enabled);

SDL_bool SDL_GetRelativeMouseMode(void);

SDL_Cursor *SDL_CreateCursor(const uint8_t * data,
                                                     const uint8_t * mask,
                                                     int w, int h, int hot_x,
                                                     int hot_y);

SDL_Cursor *SDL_CreateColorCursor(SDL_Surface *surface,
                                                          int hot_x,
                                                          int hot_y);

void SDL_SetCursor(SDL_Cursor * cursor);

SDL_Cursor *SDL_GetCursor(void);

void SDL_FreeCursor(SDL_Cursor * cursor);

int SDL_ShowCursor(int toggle);

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

struct _SDL_Joystick;
typedef struct _SDL_Joystick SDL_Joystick;

int SDL_NumJoysticks(void);

const char *SDL_JoystickName(int device_index);

SDL_Joystick *SDL_JoystickOpen(int device_index);

int SDL_JoystickOpened(int device_index);

int SDL_JoystickIndex(SDL_Joystick * joystick);

int SDL_JoystickNumAxes(SDL_Joystick * joystick);

int SDL_JoystickNumBalls(SDL_Joystick * joystick);

int SDL_JoystickNumHats(SDL_Joystick * joystick);

int SDL_JoystickNumButtons(SDL_Joystick * joystick);

void SDL_JoystickUpdate(void);

int SDL_JoystickEventState(int state);

int16_t SDL_JoystickGetAxis(SDL_Joystick * joystick,
                                                   int axis);

uint8_t SDL_JoystickGetHat(SDL_Joystick * joystick,
                                                 int hat);

int SDL_JoystickGetBall(SDL_Joystick * joystick,
                                                int ball, int *dx, int *dy);

uint8_t SDL_JoystickGetButton(SDL_Joystick * joystick,
                                                    int button);

void SDL_JoystickClose(SDL_Joystick * joystick);

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

typedef int64_t SDL_TouchID;
typedef int64_t SDL_FingerID;

struct SDL_Finger {
  SDL_FingerID id;
  uint16_t x;
  uint16_t y;
  uint16_t pressure;
  uint16_t xdelta;
  uint16_t ydelta;
  uint16_t last_x, last_y,last_pressure;  
  SDL_bool down;
};

typedef struct SDL_Touch SDL_Touch;
typedef struct SDL_Finger SDL_Finger;

struct SDL_Touch {
  
  void (*FreeTouch) (SDL_Touch * touch);
  
  float pressure_max, pressure_min;
  float x_max,x_min;
  float y_max,y_min;
  uint16_t xres,yres,pressureres;
  float native_xres,native_yres,native_pressureres;
  float tilt;                   
  float rotation;               
  
  SDL_TouchID id;
  SDL_Window *focus;
  
  char *name;
  uint8_t buttonstate;
  SDL_bool relative_mode;
  SDL_bool flush_motion;

  int num_fingers;
  int max_fingers;
  SDL_Finger** fingers;
    
  void *driverdata;
};

  SDL_Touch* SDL_GetTouch(SDL_TouchID id);

  extern 
  __declspec(dllexport) SDL_Finger* SDL_GetFinger(SDL_Touch *touch, SDL_FingerID id);

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

typedef int64_t SDL_GestureID;

int SDL_RecordGesture(SDL_TouchID touchId);

int SDL_SaveAllDollarTemplates(SDL_RWops *src);

int SDL_SaveDollarTemplate(SDL_GestureID gestureId,SDL_RWops *src);

int SDL_LoadDollarTemplates(SDL_TouchID touchId, SDL_RWops *src);

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

typedef enum
{
    SDL_FIRSTEVENT     = 0,     

    
    SDL_QUIT           = 0x100, 

    
    SDL_WINDOWEVENT    = 0x200, 
    SDL_SYSWMEVENT,             

    
    SDL_KEYDOWN        = 0x300, 
    SDL_KEYUP,                  
    SDL_TEXTEDITING,            
    SDL_TEXTINPUT,              

    
    SDL_MOUSEMOTION    = 0x400, 
    SDL_MOUSEBUTTONDOWN,        
    SDL_MOUSEBUTTONUP,          
    SDL_MOUSEWHEEL,             

    
    SDL_INPUTMOTION    = 0x500, 
    SDL_INPUTBUTTONDOWN,        
    SDL_INPUTBUTTONUP,          
    SDL_INPUTWHEEL,             
    SDL_INPUTPROXIMITYIN,       
    SDL_INPUTPROXIMITYOUT,      

    
    SDL_JOYAXISMOTION  = 0x600, 
    SDL_JOYBALLMOTION,          
    SDL_JOYHATMOTION,           
    SDL_JOYBUTTONDOWN,          
    SDL_JOYBUTTONUP,            

    
    SDL_FINGERDOWN      = 0x700,
    SDL_FINGERUP,
    SDL_FINGERMOTION,
    SDL_TOUCHBUTTONDOWN,
    SDL_TOUCHBUTTONUP,    

    
    SDL_DOLLARGESTURE   = 0x800,
    SDL_DOLLARRECORD,
    SDL_MULTIGESTURE,

    

    SDL_CLIPBOARDUPDATE = 0x900, 

    
    SDL_EVENT_COMPAT1 = 0x7000, 
    SDL_EVENT_COMPAT2,
    SDL_EVENT_COMPAT3,

    

    SDL_USEREVENT    = 0x8000,

    

    SDL_LASTEVENT    = 0xFFFF
} SDL_EventType;

typedef struct SDL_WindowEvent
{
    uint32_t type;        
    uint32_t windowID;    
    uint8_t event;        
    uint8_t padding1;
    uint8_t padding2;
    uint8_t padding3;
    int data1;          
    int data2;          
} SDL_WindowEvent;

typedef struct SDL_KeyboardEvent
{
    uint32_t type;        
    uint32_t windowID;    
    uint8_t state;        
    uint8_t repeat;       
    uint8_t padding2;
    uint8_t padding3;
    SDL_Keysym keysym;  
} SDL_KeyboardEvent;

typedef struct SDL_TextEditingEvent
{
    uint32_t type;                                
    uint32_t windowID;                            
    char text[(32)];  
    int start;                                  
    int length;                                 
} SDL_TextEditingEvent;

typedef struct SDL_TextInputEvent
{
    uint32_t type;                              
    uint32_t windowID;                          
    char text[(32)];  
} SDL_TextInputEvent;

typedef struct SDL_MouseMotionEvent
{
    uint32_t type;        
    uint32_t windowID;    
    uint8_t state;        
    uint8_t padding1;
    uint8_t padding2;
    uint8_t padding3;
    int x;              
    int y;              
    int xrel;           
    int yrel;           
} SDL_MouseMotionEvent;

typedef struct SDL_MouseButtonEvent
{
    uint32_t type;        
    uint32_t windowID;    
    uint8_t button;       
    uint8_t state;        
    uint8_t padding1;
    uint8_t padding2;
    int x;              
    int y;              
} SDL_MouseButtonEvent;

typedef struct SDL_MouseWheelEvent
{
    uint32_t type;        
    uint32_t windowID;    
    int x;              
    int y;              
} SDL_MouseWheelEvent;

typedef struct SDL_JoyAxisEvent
{
    uint32_t type;        
    uint8_t which;        
    uint8_t axis;         
    uint8_t padding1;
    uint8_t padding2;
    int value;          
} SDL_JoyAxisEvent;

typedef struct SDL_JoyBallEvent
{
    uint32_t type;        
    uint8_t which;        
    uint8_t ball;         
    uint8_t padding1;
    uint8_t padding2;
    int xrel;           
    int yrel;           
} SDL_JoyBallEvent;

typedef struct SDL_JoyHatEvent
{
    uint32_t type;        
    uint8_t which;        
    uint8_t hat;          
    uint8_t value;        

    uint8_t padding1;
} SDL_JoyHatEvent;

typedef struct SDL_JoyButtonEvent
{
    uint32_t type;        
    uint8_t which;        
    uint8_t button;       
    uint8_t state;        
    uint8_t padding1;
} SDL_JoyButtonEvent;

typedef struct SDL_TouchFingerEvent
{
    uint32_t type;        

    uint32_t windowID;    
    SDL_TouchID touchId;        
    SDL_FingerID fingerId;
    uint8_t state;        
    uint8_t padding1;
    uint8_t padding2;
    uint8_t padding3;
    uint16_t x;
    uint16_t y;
    int16_t dx;
    int16_t dy;
    uint16_t pressure;
} SDL_TouchFingerEvent;

typedef struct SDL_TouchButtonEvent
{
    uint32_t type;        
    uint32_t windowID;    
    SDL_TouchID touchId;        
    uint8_t state;        
    uint8_t button;        
    uint8_t padding1;
    uint8_t padding2;
} SDL_TouchButtonEvent;

typedef struct SDL_MultiGestureEvent
{
    uint32_t type;        
    uint32_t windowID;    
    SDL_TouchID touchId;        
    float dTheta;
    float dDist;
    float x;  
    float y;  
    uint16_t numFingers;
    uint16_t padding;
} SDL_MultiGestureEvent;

typedef struct SDL_DollarGestureEvent
{
    uint32_t type;        
    uint32_t windowID;    
    SDL_TouchID touchId;        
    SDL_GestureID gestureId;
    uint32_t numFingers;
    float error;
  

} SDL_DollarGestureEvent;

typedef struct SDL_QuitEvent
{
    uint32_t type;        
} SDL_QuitEvent;

typedef struct SDL_UserEvent
{
    uint32_t type;        
    uint32_t windowID;    
    int code;           
    void *data1;        
    void *data2;        
} SDL_UserEvent;

struct SDL_SysWMmsg;
typedef struct SDL_SysWMmsg SDL_SysWMmsg;

typedef struct SDL_SysWMEvent
{
    uint32_t type;        
    SDL_SysWMmsg *msg;  
} SDL_SysWMEvent;

typedef struct SDL_ActiveEvent
{
    uint32_t type;
    uint8_t gain;
    uint8_t state;
} SDL_ActiveEvent;

typedef struct SDL_ResizeEvent
{
    uint32_t type;
    int w;
    int h;
} SDL_ResizeEvent;

typedef union SDL_Event
{
    uint32_t type;                    
    SDL_WindowEvent window;         
    SDL_KeyboardEvent key;          
    SDL_TextEditingEvent edit;      
    SDL_TextInputEvent text;        
    SDL_MouseMotionEvent motion;    
    SDL_MouseButtonEvent button;    
    SDL_MouseWheelEvent wheel;      
    SDL_JoyAxisEvent jaxis;         
    SDL_JoyBallEvent jball;         
    SDL_JoyHatEvent jhat;           
    SDL_JoyButtonEvent jbutton;     
    SDL_QuitEvent quit;             
    SDL_UserEvent user;             
    SDL_SysWMEvent syswm;           
    SDL_TouchFingerEvent tfinger;   
    SDL_TouchButtonEvent tbutton;   
    SDL_MultiGestureEvent mgesture; 
    SDL_DollarGestureEvent dgesture; 

    

    SDL_ActiveEvent active;
    SDL_ResizeEvent resize;

    
} SDL_Event;

void SDL_PumpEvents(void);

typedef enum
{
    SDL_ADDEVENT,
    SDL_PEEKEVENT,
    SDL_GETEVENT
} SDL_eventaction;

int SDL_PeepEvents(SDL_Event * events, int numevents,
                                           SDL_eventaction action,
                                           uint32_t minType, uint32_t maxType);

SDL_bool SDL_HasEvent(uint32_t type);
SDL_bool SDL_HasEvents(uint32_t minType, uint32_t maxType);

void SDL_FlushEvent(uint32_t type);
void SDL_FlushEvents(uint32_t minType, uint32_t maxType);

int SDL_PollEvent(SDL_Event * event);

int SDL_WaitEvent(SDL_Event * event);

int SDL_WaitEventTimeout(SDL_Event * event,
                                                 int timeout);

int SDL_PushEvent(SDL_Event * event);

typedef int (* SDL_EventFilter) (void *userdata, SDL_Event * event);

void SDL_SetEventFilter(SDL_EventFilter filter,
                                                void *userdata);

SDL_bool SDL_GetEventFilter(SDL_EventFilter * filter,
                                                    void **userdata);

void SDL_AddEventWatch(SDL_EventFilter filter,
                                               void *userdata);

void SDL_DelEventWatch(SDL_EventFilter filter,
                                               void *userdata);

void SDL_FilterEvents(SDL_EventFilter filter,
                                              void *userdata);

uint8_t SDL_EventState(uint32_t type, int state);

uint32_t SDL_RegisterEvents(int numevents);

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

	

	

typedef enum
{
    SDL_HINT_DEFAULT,
    SDL_HINT_NORMAL,
    SDL_HINT_OVERRIDE
} SDL_HintPriority;

SDL_bool SDL_SetHintWithPriority(const char *name,
                                                         const char *value,
                                                         SDL_HintPriority priority);

SDL_bool SDL_SetHint(const char *name,
                                             const char *value);

const char * SDL_GetHint(const char *name);

void SDL_ClearHints(void);

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

void *SDL_LoadObject(const char *sofile);

void *SDL_LoadFunction(void *handle,
                                               const char *name);

void SDL_UnloadObject(void *handle);

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

enum
{
    SDL_LOG_CATEGORY_APPLICATION,
    SDL_LOG_CATEGORY_ERROR,
    SDL_LOG_CATEGORY_SYSTEM,
    SDL_LOG_CATEGORY_AUDIO,
    SDL_LOG_CATEGORY_VIDEO,
    SDL_LOG_CATEGORY_RENDER,
    SDL_LOG_CATEGORY_INPUT,

    
    SDL_LOG_CATEGORY_RESERVED1,
    SDL_LOG_CATEGORY_RESERVED2,
    SDL_LOG_CATEGORY_RESERVED3,
    SDL_LOG_CATEGORY_RESERVED4,
    SDL_LOG_CATEGORY_RESERVED5,
    SDL_LOG_CATEGORY_RESERVED6,
    SDL_LOG_CATEGORY_RESERVED7,
    SDL_LOG_CATEGORY_RESERVED8,
    SDL_LOG_CATEGORY_RESERVED9,
    SDL_LOG_CATEGORY_RESERVED10,

    

    SDL_LOG_CATEGORY_CUSTOM
};

typedef enum
{
    SDL_LOG_PRIORITY_VERBOSE = 1,
    SDL_LOG_PRIORITY_DEBUG,
    SDL_LOG_PRIORITY_INFO,
    SDL_LOG_PRIORITY_WARN,
    SDL_LOG_PRIORITY_ERROR,
    SDL_LOG_PRIORITY_CRITICAL,
    SDL_NUM_LOG_PRIORITIES
} SDL_LogPriority;

void SDL_LogSetAllPriority(SDL_LogPriority priority);

void SDL_LogSetPriority(int category,
                                                SDL_LogPriority priority);

SDL_LogPriority SDL_LogGetPriority(int category);

void SDL_LogResetPriorities(void);

void SDL_Log(const char *fmt, ...);

void SDL_LogVerbose(int category, const char *fmt, ...);

void SDL_LogDebug(int category, const char *fmt, ...);

void SDL_LogInfo(int category, const char *fmt, ...);

void SDL_LogWarn(int category, const char *fmt, ...);

void SDL_LogError(int category, const char *fmt, ...);

void SDL_LogCritical(int category, const char *fmt, ...);

void SDL_LogMessage(int category,
                                            SDL_LogPriority priority,
                                            const char *fmt, ...);

void SDL_LogMessageV(int category,
                                             SDL_LogPriority priority,
                                             const char *fmt, va_list ap);

typedef void (*SDL_LogOutputFunction)(void *userdata, int category, SDL_LogPriority priority, const char *message);

void SDL_LogGetOutputFunction(SDL_LogOutputFunction *callback, void **userdata);

void SDL_LogSetOutputFunction(SDL_LogOutputFunction callback, void *userdata);

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

typedef enum
{
    SDL_POWERSTATE_UNKNOWN,      
    SDL_POWERSTATE_ON_BATTERY,   
    SDL_POWERSTATE_NO_BATTERY,   
    SDL_POWERSTATE_CHARGING,     
    SDL_POWERSTATE_CHARGED       
} SDL_PowerState;

SDL_PowerState SDL_GetPowerInfo(int *secs, int *pct);

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

typedef enum
{
    SDL_RENDERER_SOFTWARE = 0x00000001,          
    SDL_RENDERER_ACCELERATED = 0x00000002,      

    SDL_RENDERER_PRESENTVSYNC = 0x00000004      

} SDL_RendererFlags;

typedef struct SDL_RendererInfo
{
    const char *name;           
    uint32_t flags;               
    uint32_t num_texture_formats; 
    uint32_t texture_formats[16]; 
    int max_texture_width;      
    int max_texture_height;     
} SDL_RendererInfo;

typedef enum
{
    SDL_TEXTUREACCESS_STATIC,    
    SDL_TEXTUREACCESS_STREAMING  
} SDL_TextureAccess;

typedef enum
{
    SDL_TEXTUREMODULATE_NONE = 0x00000000,     
    SDL_TEXTUREMODULATE_COLOR = 0x00000001,    
    SDL_TEXTUREMODULATE_ALPHA = 0x00000002     
} SDL_TextureModulate;

struct SDL_Renderer;
typedef struct SDL_Renderer SDL_Renderer;

struct SDL_Texture;
typedef struct SDL_Texture SDL_Texture;

int SDL_GetNumRenderDrivers(void);

int SDL_GetRenderDriverInfo(int index,
                                                    SDL_RendererInfo * info);

SDL_Renderer * SDL_CreateRenderer(SDL_Window * window,
                                               int index, uint32_t flags);

SDL_Renderer * SDL_CreateSoftwareRenderer(SDL_Surface * surface);

SDL_Renderer * SDL_GetRenderer(SDL_Window * window);

int SDL_GetRendererInfo(SDL_Renderer * renderer,
                                                SDL_RendererInfo * info);

SDL_Texture * SDL_CreateTexture(SDL_Renderer * renderer,
                                                        uint32_t format,
                                                        int access, int w,
                                                        int h);

SDL_Texture * SDL_CreateTextureFromSurface(SDL_Renderer * renderer, SDL_Surface * surface);

int SDL_QueryTexture(SDL_Texture * texture,
                                             uint32_t * format, int *access,
                                             int *w, int *h);

int SDL_SetTextureColorMod(SDL_Texture * texture,
                                                   uint8_t r, uint8_t g, uint8_t b);

int SDL_GetTextureColorMod(SDL_Texture * texture,
                                                   uint8_t * r, uint8_t * g,
                                                   uint8_t * b);

int SDL_SetTextureAlphaMod(SDL_Texture * texture,
                                                   uint8_t alpha);

int SDL_GetTextureAlphaMod(SDL_Texture * texture,
                                                   uint8_t * alpha);

int SDL_SetTextureBlendMode(SDL_Texture * texture,
                                                    SDL_BlendMode blendMode);

int SDL_GetTextureBlendMode(SDL_Texture * texture,
                                                    SDL_BlendMode *blendMode);

int SDL_UpdateTexture(SDL_Texture * texture,
                                              const SDL_Rect * rect,
                                              const void *pixels, int pitch);

int SDL_LockTexture(SDL_Texture * texture,
                                            const SDL_Rect * rect,
                                            void **pixels, int *pitch);

void SDL_UnlockTexture(SDL_Texture * texture);

int SDL_RenderSetViewport(SDL_Renderer * renderer,
                                                  const SDL_Rect * rect);

void SDL_RenderGetViewport(SDL_Renderer * renderer,
                                                   SDL_Rect * rect);

int SDL_SetRenderDrawColor(SDL_Renderer * renderer,
                                           uint8_t r, uint8_t g, uint8_t b,
                                           uint8_t a);

int SDL_GetRenderDrawColor(SDL_Renderer * renderer,
                                           uint8_t * r, uint8_t * g, uint8_t * b,
                                           uint8_t * a);

int SDL_SetRenderDrawBlendMode(SDL_Renderer * renderer,
                                                       SDL_BlendMode blendMode);

int SDL_GetRenderDrawBlendMode(SDL_Renderer * renderer,
                                                       SDL_BlendMode *blendMode);

int SDL_RenderClear(SDL_Renderer * renderer);

int SDL_RenderDrawPoint(SDL_Renderer * renderer,
                                                int x, int y);

int SDL_RenderDrawPoints(SDL_Renderer * renderer,
                                                 const SDL_Point * points,
                                                 int count);

int SDL_RenderDrawLine(SDL_Renderer * renderer,
                                               int x1, int y1, int x2, int y2);

int SDL_RenderDrawLines(SDL_Renderer * renderer,
                                                const SDL_Point * points,
                                                int count);

int SDL_RenderDrawRect(SDL_Renderer * renderer,
                                               const SDL_Rect * rect);

int SDL_RenderDrawRects(SDL_Renderer * renderer,
                                                const SDL_Rect * rects,
                                                int count);

int SDL_RenderFillRect(SDL_Renderer * renderer,
                                               const SDL_Rect * rect);

int SDL_RenderFillRects(SDL_Renderer * renderer,
                                                const SDL_Rect * rects,
                                                int count);

int SDL_RenderCopy(SDL_Renderer * renderer,
                                           SDL_Texture * texture,
                                           const SDL_Rect * srcrect,
                                           const SDL_Rect * dstrect);

int SDL_RenderReadPixels(SDL_Renderer * renderer,
                                                 const SDL_Rect * rect,
                                                 uint32_t format,
                                                 void *pixels, int pitch);

void SDL_RenderPresent(SDL_Renderer * renderer);

void SDL_DestroyTexture(SDL_Texture * texture);

void SDL_DestroyRenderer(SDL_Renderer * renderer);

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

uint32_t SDL_GetTicks(void);

uint64_t SDL_GetPerformanceCounter(void);

uint64_t SDL_GetPerformanceFrequency(void);

void SDL_Delay(uint32_t ms);

typedef uint32_t (* SDL_TimerCallback) (uint32_t interval, void *param);

typedef int SDL_TimerID;

SDL_TimerID SDL_AddTimer(uint32_t interval,
                                                 SDL_TimerCallback callback,
                                                 void *param);

SDL_bool SDL_RemoveTimer(SDL_TimerID t);

#pragma pack(pop)

#pragma warning(disable: 4103)

#pragma pack(push,4)

typedef struct SDL_version
{
    uint8_t major;        
    uint8_t minor;        
    uint8_t patch;        
} SDL_version;

void SDL_GetVersion(SDL_version * ver);

const char *SDL_GetRevision(void);

int SDL_GetRevisionNumber(void);

#pragma pack(pop)

 

 

#pragma warning(disable: 4103)

#pragma pack(push,4)

typedef struct SDL_VideoInfo
{
    uint32_t hw_available:1;
    uint32_t wm_available:1;
    uint32_t UnusedBits1:6;
    uint32_t UnusedBits2:1;
    uint32_t blit_hw:1;
    uint32_t blit_hw_CC:1;
    uint32_t blit_hw_A:1;
    uint32_t blit_sw:1;
    uint32_t blit_sw_CC:1;
    uint32_t blit_sw_A:1;
    uint32_t blit_fill:1;
    uint32_t UnusedBits3:16;
    uint32_t video_mem;

    SDL_PixelFormat *vfmt;

    int current_w;
    int current_h;
} SDL_VideoInfo;

typedef struct SDL_Overlay
{
    uint32_t format;              
    int w, h;                   
    int planes;                 
    uint16_t *pitches;            
    uint8_t **pixels;             

    

    
    struct private_yuvhwfuncs *hwfuncs;
    struct private_yuvhwdata *hwdata;
    

    

    
    uint32_t hw_overlay:1;        
    uint32_t UnusedBits:31;
    
} SDL_Overlay;

typedef enum
{
    SDL_GRAB_QUERY = -1,
    SDL_GRAB_OFF = 0,
    SDL_GRAB_ON = 1
} SDL_GrabMode;

struct SDL_SysWMinfo;

const SDL_version *SDL_Linked_Version(void);
const char *SDL_AudioDriverName(char *namebuf, int maxlen);
const char *SDL_VideoDriverName(char *namebuf, int maxlen);
const SDL_VideoInfo *SDL_GetVideoInfo(void);
int SDL_VideoModeOK(int width,
                                            int height,
                                            int bpp, uint32_t flags);
SDL_Rect **SDL_ListModes(const SDL_PixelFormat *
                                                 format, uint32_t flags);
SDL_Surface *SDL_SetVideoMode(int width, int height,
                                                      int bpp, uint32_t flags);
SDL_Surface *SDL_GetVideoSurface(void);
void SDL_UpdateRects(SDL_Surface * screen,
                                             int numrects, SDL_Rect * rects);
void SDL_UpdateRect(SDL_Surface * screen,
                                            int32_t x,
                                            int32_t y, uint32_t w, uint32_t h);
int SDL_Flip(SDL_Surface * screen);
int SDL_SetAlpha(SDL_Surface * surface,
                                         uint32_t flag, uint8_t alpha);
SDL_Surface *SDL_DisplayFormat(SDL_Surface * surface);
SDL_Surface *SDL_DisplayFormatAlpha(SDL_Surface *
                                                            surface);
void SDL_WM_SetCaption(const char *title,
                                               const char *icon);
void SDL_WM_GetCaption(const char **title,
                                               const char **icon);
void SDL_WM_SetIcon(SDL_Surface * icon, uint8_t * mask);
int SDL_WM_IconifyWindow(void);
int SDL_WM_ToggleFullScreen(SDL_Surface * surface);
SDL_GrabMode SDL_WM_GrabInput(SDL_GrabMode mode);
int SDL_SetPalette(SDL_Surface * surface,
                                           int flags,
                                           const SDL_Color * colors,
                                           int firstcolor, int ncolors);
int SDL_SetColors(SDL_Surface * surface,
                                          const SDL_Color * colors,
                                          int firstcolor, int ncolors);
int SDL_GetWMInfo(struct SDL_SysWMinfo *info);
uint8_t SDL_GetAppState(void);
void SDL_WarpMouse(uint16_t x, uint16_t y);
SDL_Overlay *SDL_CreateYUVOverlay(int width,
                                                          int height,
                                                          uint32_t format,
                                                          SDL_Surface *
                                                          display);
int SDL_LockYUVOverlay(SDL_Overlay * overlay);
void SDL_UnlockYUVOverlay(SDL_Overlay * overlay);
int SDL_DisplayYUVOverlay(SDL_Overlay * overlay,
                                                  SDL_Rect * dstrect);
void SDL_FreeYUVOverlay(SDL_Overlay * overlay);
void SDL_GL_SwapBuffers(void);
int SDL_SetGamma(float red, float green, float blue);
int SDL_SetGammaRamp(const uint16_t * red,
                                             const uint16_t * green,
                                             const uint16_t * blue);
int SDL_GetGammaRamp(uint16_t * red, uint16_t * green,
                                             uint16_t * blue);
int SDL_EnableKeyRepeat(int delay, int interval);
void SDL_GetKeyRepeat(int *delay, int *interval);
int SDL_EnableUNICODE(int enable);

typedef SDL_Window* SDL_WindowID;
typedef uint32_t (* SDL_OldTimerCallback) (uint32_t interval);

int SDL_SetTimer(uint32_t interval, SDL_OldTimerCallback callback);
int SDL_putenv(const char *variable);
int SDL_Init(uint32_t flags);
int SDL_InitSubSystem(uint32_t flags);
void SDL_QuitSubSystem(uint32_t flags);
uint32_t SDL_WasInit(uint32_t flags);
void SDL_Quit(void);

extern void SDL_InstallParachute(void);
extern void SDL_UninstallParachute(void);
extern int SDL_AssertionsInit(void);
extern void SDL_AssertionsQuit(void);
extern int SDL_HapticInit(void);
extern void SDL_HapticQuit(void);
extern uint8_t SDL_numjoysticks;
extern int SDL_JoystickInit(void);
extern void SDL_JoystickQuit(void);
extern int SDL_PrivateJoystickAxis(SDL_Joystick * joystick, uint8_t axis, int16_t value);
extern int SDL_PrivateJoystickBall(SDL_Joystick * joystick, uint8_t ball, int16_t xrel, int16_t yrel);
extern int SDL_PrivateJoystickHat(SDL_Joystick * joystick, uint8_t hat, uint8_t value);
extern int SDL_PrivateJoystickButton(SDL_Joystick * joystick, uint8_t button, uint8_t state);
extern int SDL_PrivateJoystickValid(SDL_Joystick ** joystick);
extern void SDL_StartTicks(void);
extern int  SDL_TimerInit(void);
extern void SDL_TimerQuit(void);
extern int  SDL_HelperWindowCreate(void);
extern int  SDL_HelperWindowDestroy(void);
]]

return sdl


