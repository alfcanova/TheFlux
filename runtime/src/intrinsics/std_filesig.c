#include "flux/flux.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

/* ==============================================================================
 * TheFlux FileSignatureStdLib Runtime (C / LLVM)
 * ============================================================================== */

static FILE *_open_sig_candidate_file(const char *path) {
    if (!path || !*path) return NULL;
    FILE *f = fopen(path, "rb");
    if (f) return f;
    char alt[1024];
    const char *base = strrchr(path, '/');
    if (!base) base = strrchr(path, '\\');
    base = base ? base + 1 : path;
    snprintf(alt, sizeof(alt), "flux/%s", base);
    return fopen(alt, "rb");
}

/* --- CRC-32 IEEE 802.3 --- */
static uint32_t _sig_crc32_tab[256];
static int _sig_crc32_ready = 0;
static void _sig_crc32_init(void) {
    if (_sig_crc32_ready) return;
    for (uint32_t i = 0; i < 256; i++) {
        uint32_t c = i;
        for (int j = 0; j < 8; j++) {
            c = (c & 1) ? (0xEDB88320L ^ (c >> 1)) : (c >> 1);
        }
        _sig_crc32_tab[i] = c;
    }
    _sig_crc32_ready = 1;
}

int64_t flux_std_file_crc32(const char *path) {
    _sig_crc32_init();
    FILE *f = _open_sig_candidate_file(path);
    if (!f) return 0;
    uint32_t crc = 0xFFFFFFFF;
    unsigned char buf[65536];
    size_t n;
    while ((n = fread(buf, 1, sizeof(buf), f)) > 0) {
        for (size_t i = 0; i < n; i++) {
            crc = _sig_crc32_tab[(crc ^ buf[i]) & 0xFF] ^ (crc >> 8);
        }
    }
    fclose(f);
    return (int64_t)(crc ^ 0xFFFFFFFF);
}

/* --- MD5 RFC 1321 --- */
typedef struct {
    uint32_t state[4];
    uint32_t count[2];
    unsigned char buffer[64];
} SIG_MD5_CTX;

#define SIG_MD5_F(x, y, z) (((x) & (y)) | ((~x) & (z)))
#define SIG_MD5_G(x, y, z) (((x) & (z)) | ((y) & (~z)))
#define SIG_MD5_H(x, y, z) ((x) ^ (y) ^ (z))
#define SIG_MD5_I(x, y, z) ((y) ^ ((x) | (~z)))
#define SIG_MD5_ROTL(x, n) (((x) << (n)) | ((x) >> (32 - (n))))
#define SIG_MD5_FF(a, b, c, d, x, s, ac) { (a) += SIG_MD5_F((b), (c), (d)) + (x) + (uint32_t)(ac); (a) = SIG_MD5_ROTL((a), (s)); (a) += (b); }
#define SIG_MD5_GG(a, b, c, d, x, s, ac) { (a) += SIG_MD5_G((b), (c), (d)) + (x) + (uint32_t)(ac); (a) = SIG_MD5_ROTL((a), (s)); (a) += (b); }
#define SIG_MD5_HH(a, b, c, d, x, s, ac) { (a) += SIG_MD5_H((b), (c), (d)) + (x) + (uint32_t)(ac); (a) = SIG_MD5_ROTL((a), (s)); (a) += (b); }
#define SIG_MD5_II(a, b, c, d, x, s, ac) { (a) += SIG_MD5_I((b), (c), (d)) + (x) + (uint32_t)(ac); (a) = SIG_MD5_ROTL((a), (s)); (a) += (b); }

static void _sig_md5_transform(uint32_t state[4], const unsigned char block[64]) {
    uint32_t a = state[0], b = state[1], c = state[2], d = state[3], x[16];
    for (int i = 0, j = 0; j < 64; i++, j += 4)
        x[i] = ((uint32_t)block[j]) | (((uint32_t)block[j+1]) << 8) | (((uint32_t)block[j+2]) << 16) | (((uint32_t)block[j+3]) << 24);

    SIG_MD5_FF(a, b, c, d, x[ 0],  7, 0xd76aa478); SIG_MD5_FF(d, a, b, c, x[ 1], 12, 0xe8c7b756); SIG_MD5_FF(c, d, a, b, x[ 2], 17, 0x242070db); SIG_MD5_FF(b, c, d, a, x[ 3], 22, 0xc1bdceee);
    SIG_MD5_FF(a, b, c, d, x[ 4],  7, 0xf57c0faf); SIG_MD5_FF(d, a, b, c, x[ 5], 12, 0x4787c62a); SIG_MD5_FF(c, d, a, b, x[ 6], 17, 0xa8304613); SIG_MD5_FF(b, c, d, a, x[ 7], 22, 0xfd469501);
    SIG_MD5_FF(a, b, c, d, x[ 8],  7, 0x698098d8); SIG_MD5_FF(d, a, b, c, x[ 9], 12, 0x8b44f7af); SIG_MD5_FF(c, d, a, b, x[10], 17, 0xffff5bb1); SIG_MD5_FF(b, c, d, a, x[11], 22, 0x895cd7be);
    SIG_MD5_FF(a, b, c, d, x[12],  7, 0x6b901122); SIG_MD5_FF(d, a, b, c, x[13], 12, 0xfd987193); SIG_MD5_FF(c, d, a, b, x[14], 17, 0xa679438e); SIG_MD5_FF(b, c, d, a, x[15], 22, 0x49b40821);

    SIG_MD5_GG(a, b, c, d, x[ 1],  5, 0xf61e2562); SIG_MD5_GG(d, a, b, c, x[ 6],  9, 0xc040b340); SIG_MD5_GG(c, d, a, b, x[11], 14, 0x265e5a51); SIG_MD5_GG(b, c, d, a, x[ 0], 20, 0xe9b6c7aa);
    SIG_MD5_GG(a, b, c, d, x[ 5],  5, 0xd62f105d); SIG_MD5_GG(d, a, b, c, x[10],  9, 0x02441453); SIG_MD5_GG(c, d, a, b, x[15], 14, 0xd8a1e681); SIG_MD5_GG(b, c, d, a, x[ 4], 20, 0xe7d3fbc8);
    SIG_MD5_GG(a, b, c, d, x[ 9],  5, 0x21e1cde6); SIG_MD5_GG(d, a, b, c, x[14],  9, 0xc33707d6); SIG_MD5_GG(c, d, a, b, x[ 3], 14, 0xf4d50d87); SIG_MD5_GG(b, c, d, a, x[ 8], 20, 0x455a14ed);
    SIG_MD5_GG(a, b, c, d, x[13],  5, 0xa9e3e905); SIG_MD5_GG(d, a, b, c, x[ 2],  9, 0xfcefa3f8); SIG_MD5_GG(c, d, a, b, x[ 7], 14, 0x676f02d9); SIG_MD5_GG(b, c, d, a, x[12], 20, 0x8d2a4c8a);

    SIG_MD5_HH(a, b, c, d, x[ 5],  4, 0xfffa3942); SIG_MD5_HH(d, a, b, c, x[ 8], 11, 0x8771f681); SIG_MD5_HH(c, d, a, b, x[11], 16, 0x6d9d6122); SIG_MD5_HH(b, c, d, a, x[14], 23, 0xfde5380c);
    SIG_MD5_HH(a, b, c, d, x[ 1],  4, 0xa4beea44); SIG_MD5_HH(d, a, b, c, x[ 4], 11, 0x4bdecfa9); SIG_MD5_HH(c, d, a, b, x[ 7], 16, 0xf6bb4b60); SIG_MD5_HH(b, c, d, a, x[10], 23, 0xbebfbc70);
    SIG_MD5_HH(a, b, c, d, x[13],  4, 0x289b7ec6); SIG_MD5_HH(d, a, b, c, x[ 0], 11, 0xeaa127fa); SIG_MD5_HH(c, d, a, b, x[ 3], 16, 0xd4ef3085); SIG_MD5_HH(b, c, d, a, x[ 6], 23, 0x04881d05);
    SIG_MD5_HH(a, b, c, d, x[ 9],  4, 0xd9d4d039); SIG_MD5_HH(d, a, b, c, x[12], 11, 0xe6db99e5); SIG_MD5_HH(c, d, a, b, x[15], 16, 0x1fa27cf8); SIG_MD5_HH(b, c, d, a, x[ 2], 23, 0xc4ac5665);

    SIG_MD5_II(a, b, c, d, x[ 0],  6, 0xf4292244); SIG_MD5_II(d, a, b, c, x[ 7], 10, 0x432aff97); SIG_MD5_II(c, d, a, b, x[14], 15, 0xab9423a7); SIG_MD5_II(b, c, d, a, x[ 5], 21, 0xfc93a039);
    SIG_MD5_II(a, b, c, d, x[12],  6, 0x655b59c3); SIG_MD5_II(d, a, b, c, x[ 3], 10, 0x8f0ccc92); SIG_MD5_II(c, d, a, b, x[10], 15, 0xffeff47d); SIG_MD5_II(b, c, d, a, x[ 1], 21, 0x85845dd1);
    SIG_MD5_II(a, b, c, d, x[ 8],  6, 0x6fa87e4f); SIG_MD5_II(d, a, b, c, x[15], 10, 0xfe2ce6e0); SIG_MD5_II(c, d, a, b, x[ 6], 15, 0xa3014314); SIG_MD5_II(b, c, d, a, x[13], 21, 0x4e0811a1);
    SIG_MD5_II(a, b, c, d, x[ 4],  6, 0xf7537e82); SIG_MD5_II(d, a, b, c, x[11], 10, 0xbd3af235); SIG_MD5_II(c, d, a, b, x[ 2], 15, 0x2ad7d2bb); SIG_MD5_II(b, c, d, a, x[ 9], 21, 0xeb86d391);

    state[0] += a; state[1] += b; state[2] += c; state[3] += d;
}

static void _sig_md5_init(SIG_MD5_CTX *ctx) {
    ctx->count[0] = ctx->count[1] = 0;
    ctx->state[0] = 0x67452301; ctx->state[1] = 0xefcdab89; ctx->state[2] = 0x98badcfe; ctx->state[3] = 0x10325476;
}

static void _sig_md5_update(SIG_MD5_CTX *ctx, const unsigned char *input, size_t inputLen) {
    size_t i = 0, index = (ctx->count[0] >> 3) & 0x3F;
    if ((ctx->count[0] += ((uint32_t)inputLen << 3)) < ((uint32_t)inputLen << 3)) ctx->count[1]++;
    ctx->count[1] += (uint32_t)(inputLen >> 29);
    size_t partLen = 64 - index;
    if (inputLen >= partLen) {
        memcpy(&ctx->buffer[index], input, partLen);
        _sig_md5_transform(ctx->state, ctx->buffer);
        for (i = partLen; i + 63 < inputLen; i += 64)
            _sig_md5_transform(ctx->state, &input[i]);
        index = 0;
    }
    memcpy(&ctx->buffer[index], &input[i], inputLen - i);
}

static void _sig_md5_final(unsigned char digest[16], SIG_MD5_CTX *ctx) {
    unsigned char bits[8];
    for (int i = 0; i < 4; i++) {
        bits[i] = (unsigned char)((ctx->count[0] >> (i * 8)) & 0xFF);
        bits[i + 4] = (unsigned char)((ctx->count[1] >> (i * 8)) & 0xFF);
    }
    size_t index = (ctx->count[0] >> 3) & 0x3F;
    size_t padLen = (index < 56) ? (56 - index) : (120 - index);
    static const unsigned char PADDING[64] = { 0x80 };
    _sig_md5_update(ctx, PADDING, padLen);
    _sig_md5_update(ctx, bits, 8);
    for (int i = 0; i < 4; i++) {
        digest[i*4]   = (unsigned char)((ctx->state[i]) & 0xFF);
        digest[i*4+1] = (unsigned char)((ctx->state[i] >> 8) & 0xFF);
        digest[i*4+2] = (unsigned char)((ctx->state[i] >> 16) & 0xFF);
        digest[i*4+3] = (unsigned char)((ctx->state[i] >> 24) & 0xFF);
    }
}

char *flux_std_file_md5(const char *path) {
    FILE *f = _open_sig_candidate_file(path);
    if (!f) return strdup("");
    SIG_MD5_CTX ctx;
    _sig_md5_init(&ctx);
    unsigned char buf[65536];
    size_t n;
    while ((n = fread(buf, 1, sizeof(buf), f)) > 0) {
        _sig_md5_update(&ctx, buf, n);
    }
    fclose(f);
    unsigned char d[16];
    _sig_md5_final(d, &ctx);
    char *res = (char *)malloc(33);
    for (int i = 0; i < 16; i++) snprintf(res + i*2, 3, "%02x", d[i]);
    res[32] = 0;
    return res;
}

/* --- SHA-1 FIPS 180-1 --- */
typedef struct {
    uint32_t state[5];
    uint64_t count;
    unsigned char buffer[64];
} SIG_SHA1_CTX;

#define SIG_SHA1_ROTL(x, n) (((x) << (n)) | ((x) >> (32 - (n))))

static void _sig_sha1_transform(uint32_t state[5], const unsigned char buffer[64]) {
    uint32_t a = state[0], b = state[1], c = state[2], d = state[3], e = state[4], w[80];
    for (int i = 0; i < 16; i++)
        w[i] = ((uint32_t)buffer[i*4] << 24) | ((uint32_t)buffer[i*4+1] << 16) | ((uint32_t)buffer[i*4+2] << 8) | ((uint32_t)buffer[i*4+3]);
    for (int i = 16; i < 80; i++)
        w[i] = SIG_SHA1_ROTL(w[i-3] ^ w[i-8] ^ w[i-14] ^ w[i-16], 1);

    for (int i = 0; i < 80; i++) {
        uint32_t f, k;
        if (i < 20) {
            f = (b & c) | ((~b) & d); k = 0x5a827999;
        } else if (i < 40) {
            f = b ^ c ^ d; k = 0x6ed9eba1;
        } else if (i < 60) {
            f = (b & c) | (b & d) | (c & d); k = 0x8f1bbcdc;
        } else {
            f = b ^ c ^ d; k = 0xca62c1d6;
        }
        uint32_t temp = SIG_SHA1_ROTL(a, 5) + f + e + k + w[i];
        e = d; d = c; c = SIG_SHA1_ROTL(b, 30); b = a; a = temp;
    }
    state[0] += a; state[1] += b; state[2] += c; state[3] += d; state[4] += e;
}

static void _sig_sha1_init(SIG_SHA1_CTX *ctx) {
    ctx->count = 0;
    ctx->state[0] = 0x67452301; ctx->state[1] = 0xefcdab89; ctx->state[2] = 0x98badcfe; ctx->state[3] = 0x10325476; ctx->state[4] = 0xc3d2e1f0;
}

static void _sig_sha1_update(SIG_SHA1_CTX *ctx, const unsigned char *data, size_t len) {
    size_t i = 0, index = (ctx->count / 8) % 64;
    ctx->count += (uint64_t)len * 8;
    size_t partLen = 64 - index;
    if (len >= partLen) {
        memcpy(&ctx->buffer[index], data, partLen);
        _sig_sha1_transform(ctx->state, ctx->buffer);
        for (i = partLen; i + 63 < len; i += 64)
            _sig_sha1_transform(ctx->state, &data[i]);
        index = 0;
    }
    memcpy(&ctx->buffer[index], &data[i], len - i);
}

static void _sig_sha1_final(unsigned char digest[20], SIG_SHA1_CTX *ctx) {
    unsigned char bits[8];
    for (int i = 0; i < 8; i++)
        bits[i] = (unsigned char)((ctx->count >> ((7 - i) * 8)) & 0xFF);
    size_t index = (ctx->count / 8) % 64;
    size_t padLen = (index < 56) ? (56 - index) : (120 - index);
    static const unsigned char PADDING[64] = { 0x80 };
    _sig_sha1_update(ctx, PADDING, padLen);
    _sig_sha1_update(ctx, bits, 8);
    for (int i = 0; i < 5; i++) {
        digest[i*4]   = (unsigned char)((ctx->state[i] >> 24) & 0xFF);
        digest[i*4+1] = (unsigned char)((ctx->state[i] >> 16) & 0xFF);
        digest[i*4+2] = (unsigned char)((ctx->state[i] >> 8) & 0xFF);
        digest[i*4+3] = (unsigned char)((ctx->state[i]) & 0xFF);
    }
}

char *flux_std_file_sha1(const char *path) {
    FILE *f = _open_sig_candidate_file(path);
    if (!f) return strdup("");
    SIG_SHA1_CTX ctx;
    _sig_sha1_init(&ctx);
    unsigned char buf[65536];
    size_t n;
    while ((n = fread(buf, 1, sizeof(buf), f)) > 0) {
        _sig_sha1_update(&ctx, buf, n);
    }
    fclose(f);
    unsigned char d[20];
    _sig_sha1_final(d, &ctx);
    char *res = (char *)malloc(41);
    for (int i = 0; i < 20; i++) snprintf(res + i*2, 3, "%02x", d[i]);
    res[40] = 0;
    return res;
}

/* --- SHA-256 FIPS 180-4 --- */
typedef struct {
    uint32_t state[8];
    uint64_t count;
    unsigned char buffer[64];
} SIG_SHA256_CTX;

#define SIG_ROTR(x, n) (((x) >> (n)) | ((x) << (32 - (n))))
#define SIG_CH(x, y, z) (((x) & (y)) ^ (~(x) & (z)))
#define SIG_MAJ(x, y, z) (((x) & (y)) ^ ((x) & (z)) ^ ((y) & (z)))
#define SIG_EP0(x) (SIG_ROTR(x, 2) ^ SIG_ROTR(x, 13) ^ SIG_ROTR(x, 22))
#define SIG_EP1(x) (SIG_ROTR(x, 6) ^ SIG_ROTR(x, 11) ^ SIG_ROTR(x, 25))
#define SIG_S0(x) (SIG_ROTR(x, 7) ^ SIG_ROTR(x, 18) ^ ((x) >> 3))
#define SIG_S1(x) (SIG_ROTR(x, 17) ^ SIG_ROTR(x, 19) ^ ((x) >> 10))

static const uint32_t _sig_k256[64] = {
    0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
    0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
    0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
    0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
    0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
    0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
    0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
    0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
};

static void _sig_sha256_transform(uint32_t state[8], const unsigned char data[64]) {
    uint32_t a, b, c, d, e, f, g, h, t1, t2, m[64];
    for (int i = 0, j = 0; i < 16; i++, j += 4)
        m[i] = (((uint32_t)data[j]) << 24) | (((uint32_t)data[j+1]) << 16) | (((uint32_t)data[j+2]) << 8) | ((uint32_t)data[j+3]);
    for (int i = 16; i < 64; i++)
        m[i] = SIG_S1(m[i-2]) + m[i-7] + SIG_S0(m[i-15]) + m[i-16];
    a = state[0]; b = state[1]; c = state[2]; d = state[3];
    e = state[4]; f = state[5]; g = state[6]; h = state[7];
    for (int i = 0; i < 64; i++) {
        t1 = h + SIG_EP1(e) + SIG_CH(e, f, g) + _sig_k256[i] + m[i];
        t2 = SIG_EP0(a) + SIG_MAJ(a, b, c);
        h = g; g = f; f = e; e = d + t1;
        d = c; c = b; b = a; a = t1 + t2;
    }
    state[0] += a; state[1] += b; state[2] += c; state[3] += d;
    state[4] += e; state[5] += f; state[6] += g; state[7] += h;
}

static void _sig_sha256_init(SIG_SHA256_CTX *ctx) {
    ctx->count = 0;
    ctx->state[0] = 0x6a09e667; ctx->state[1] = 0xbb67ae85; ctx->state[2] = 0x3c6ef372; ctx->state[3] = 0xa54ff53a;
    ctx->state[4] = 0x510e527f; ctx->state[5] = 0x9b05688c; ctx->state[6] = 0x1f83d9ab; ctx->state[7] = 0x5be0cd19;
}

static void _sig_sha256_update(SIG_SHA256_CTX *ctx, const unsigned char *data, size_t len) {
    size_t i = 0, index = (ctx->count / 8) % 64;
    ctx->count += (uint64_t)len * 8;
    size_t partLen = 64 - index;
    if (len >= partLen) {
        memcpy(&ctx->buffer[index], data, partLen);
        _sig_sha256_transform(ctx->state, ctx->buffer);
        for (i = partLen; i + 63 < len; i += 64)
            _sig_sha256_transform(ctx->state, &data[i]);
        index = 0;
    }
    memcpy(&ctx->buffer[index], &data[i], len - i);
}

static void _sig_sha256_final(unsigned char digest[32], SIG_SHA256_CTX *ctx) {
    unsigned char bits[8];
    for (int i = 0; i < 8; i++)
        bits[i] = (unsigned char)((ctx->count >> ((7 - i) * 8)) & 0xFF);
    size_t index = (ctx->count / 8) % 64;
    size_t padLen = (index < 56) ? (56 - index) : (120 - index);
    static const unsigned char PADDING[64] = { 0x80 };
    _sig_sha256_update(ctx, PADDING, padLen);
    _sig_sha256_update(ctx, bits, 8);
    for (int i = 0; i < 8; i++) {
        digest[i*4]   = (unsigned char)((ctx->state[i] >> 24) & 0xFF);
        digest[i*4+1] = (unsigned char)((ctx->state[i] >> 16) & 0xFF);
        digest[i*4+2] = (unsigned char)((ctx->state[i] >> 8) & 0xFF);
        digest[i*4+3] = (unsigned char)((ctx->state[i]) & 0xFF);
    }
}

char *flux_std_file_sha256(const char *path) {
    FILE *f = _open_sig_candidate_file(path);
    if (!f) return strdup("");
    SIG_SHA256_CTX ctx;
    _sig_sha256_init(&ctx);
    unsigned char buf[65536];
    size_t n;
    while ((n = fread(buf, 1, sizeof(buf), f)) > 0) {
        _sig_sha256_update(&ctx, buf, n);
    }
    fclose(f);
    unsigned char digest[32];
    _sig_sha256_final(digest, &ctx);
    char *res = (char *)malloc(65);
    for (int i = 0; i < 32; i++) snprintf(res + i*2, 3, "%02x", digest[i]);
    res[64] = 0;
    return res;
}

/* --- HMAC-SHA256 & HMAC-MD5 --- */
char *flux_std_file_hmac_sha256(const char *path, const char *key) {
    if (!key) key = "";
    size_t key_len = strlen(key);
    unsigned char k0[64];
    memset(k0, 0, 64);
    if (key_len > 64) {
        SIG_SHA256_CTX kctx;
        _sig_sha256_init(&kctx);
        _sig_sha256_update(&kctx, (const unsigned char *)key, key_len);
        _sig_sha256_final(k0, &kctx);
    } else {
        memcpy(k0, key, key_len);
    }
    unsigned char k_ipad[64], k_opad[64];
    for (int i = 0; i < 64; i++) {
        k_ipad[i] = k0[i] ^ 0x36;
        k_opad[i] = k0[i] ^ 0x5c;
    }
    FILE *f = _open_sig_candidate_file(path);
    if (!f) return strdup("");
    SIG_SHA256_CTX inner;
    _sig_sha256_init(&inner);
    _sig_sha256_update(&inner, k_ipad, 64);
    unsigned char buf[65536];
    size_t n;
    while ((n = fread(buf, 1, sizeof(buf), f)) > 0) {
        _sig_sha256_update(&inner, buf, n);
    }
    fclose(f);
    unsigned char inner_hash[32];
    _sig_sha256_final(inner_hash, &inner);

    SIG_SHA256_CTX outer;
    _sig_sha256_init(&outer);
    _sig_sha256_update(&outer, k_opad, 64);
    _sig_sha256_update(&outer, inner_hash, 32);
    unsigned char mac[32];
    _sig_sha256_final(mac, &outer);

    char *res = (char *)malloc(65);
    for (int i = 0; i < 32; i++) snprintf(res + i*2, 3, "%02x", mac[i]);
    res[64] = 0;
    return res;
}

char *flux_std_file_hmac_md5(const char *path, const char *key) {
    if (!key) key = "";
    size_t key_len = strlen(key);
    unsigned char k0[64];
    memset(k0, 0, 64);
    if (key_len > 64) {
        SIG_MD5_CTX kctx;
        _sig_md5_init(&kctx);
        _sig_md5_update(&kctx, (const unsigned char *)key, key_len);
        _sig_md5_final(k0, &kctx);
    } else {
        memcpy(k0, key, key_len);
    }
    unsigned char k_ipad[64], k_opad[64];
    for (int i = 0; i < 64; i++) {
        k_ipad[i] = k0[i] ^ 0x36;
        k_opad[i] = k0[i] ^ 0x5c;
    }
    FILE *f = _open_sig_candidate_file(path);
    if (!f) return strdup("");
    SIG_MD5_CTX inner;
    _sig_md5_init(&inner);
    _sig_md5_update(&inner, k_ipad, 64);
    unsigned char buf[65536];
    size_t n;
    while ((n = fread(buf, 1, sizeof(buf), f)) > 0) {
        _sig_md5_update(&inner, buf, n);
    }
    fclose(f);
    unsigned char inner_hash[16];
    _sig_md5_final(inner_hash, &inner);

    SIG_MD5_CTX outer;
    _sig_md5_init(&outer);
    _sig_md5_update(&outer, k_opad, 64);
    _sig_md5_update(&outer, inner_hash, 16);
    unsigned char mac[16];
    _sig_md5_final(mac, &outer);

    char *res = (char *)malloc(33);
    for (int i = 0; i < 16; i++) snprintf(res + i*2, 3, "%02x", mac[i]);
    res[32] = 0;
    return res;
}

/* --- Magic Bytes & File Type Detection --- */
char *flux_std_file_magic_bytes(const char *path, int64_t num_bytes) {
    if (num_bytes <= 0) return strdup("");
    FILE *f = _open_sig_candidate_file(path);
    if (!f) return strdup("");
    unsigned char *buf = (unsigned char *)malloc((size_t)num_bytes);
    if (!buf) { fclose(f); return strdup(""); }
    size_t read_n = fread(buf, 1, (size_t)num_bytes, f);
    fclose(f);
    char *res = (char *)malloc(read_n * 2 + 1);
    for (size_t i = 0; i < read_n; i++) snprintf(res + i*2, 3, "%02x", buf[i]);
    res[read_n * 2] = 0;
    free(buf);
    return res;
}

char *flux_std_file_detect_type(const char *path) {
    FILE *f = _open_sig_candidate_file(path);
    if (!f) return strdup("unknown");
    unsigned char head[512];
    size_t n = fread(head, 1, sizeof(head), f);
    fclose(f);
    if (n == 0) return strdup("empty");
    if (n >= 8 && memcmp(head, "\x89PNG\r\n\x1a\n", 8) == 0) return strdup("png");
    if (n >= 4 && memcmp(head, "%PDF", 4) == 0) return strdup("pdf");
    if (n >= 4 && memcmp(head, "\x00asm", 4) == 0) return strdup("wasm");
    if (n >= 4 && (memcmp(head, "PK\x03\x04", 4) == 0 || memcmp(head, "PK\x05\x06", 4) == 0)) return strdup("zip");
    if (n >= 3 && memcmp(head, "\xff\xd8\xff", 3) == 0) return strdup("jpeg");
    if (n >= 6 && (memcmp(head, "GIF87a", 6) == 0 || memcmp(head, "GIF89a", 6) == 0)) return strdup("gif");
    if (n >= 4 && head[0] == 0x7f && head[1] == 'E' && head[2] == 'L' && head[3] == 'F') return strdup("elf");
    if (n >= 2 && memcmp(head, "MZ", 2) == 0) return strdup("exe");
    if (n >= 2 && memcmp(head, "\x1f\x8b", 2) == 0) return strdup("gzip");
    for (size_t i = 0; i < n; i++) {
        if (head[i] == 0) return strdup("binary");
    }
    return strdup("text");
}

int64_t flux_std_file_is_binary(const char *path) {
    FILE *f = _open_sig_candidate_file(path);
    if (!f) return 0;
    unsigned char head[1024];
    size_t n = fread(head, 1, sizeof(head), f);
    fclose(f);
    if (n == 0) return 0;
    for (size_t i = 0; i < n; i++) {
        if (head[i] == 0) return 1;
    }
    return 0;
}

