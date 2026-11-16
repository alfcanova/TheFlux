/* ==============================================================================
 * TheFlux Native Runtime: Complex Number Operations
 * Source: runtime/src/core/complex.c
 * ============================================================================== */

#include "flux/complex.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

static void format_double(char *buf, size_t sz, double d) {
    if (fabs(d) == 0.0) d = 0.0;
    snprintf(buf, sz, "%.9g", d);
    if (!strchr(buf, '.') && !strchr(buf, 'e') && !strchr(buf, 'E')) {
        size_t l = strlen(buf);
        if (l + 2 < sz) {
            buf[l] = '.';
            buf[l+1] = '0';
            buf[l+2] = '\0';
        }
    }
}

flux_complex_t* flux_complex_create(double re, double im) {
    flux_complex_t *c = (flux_complex_t*)malloc(sizeof(flux_complex_t));
    if (!c) return NULL;
    c->re = (fabs(re) == 0.0) ? 0.0 : re;
    c->im = (fabs(im) == 0.0) ? 0.0 : im;
    return c;
}

double flux_complex_get_real(flux_complex_t *c) {
    return c ? c->re : 0.0;
}

double flux_complex_get_imag(flux_complex_t *c) {
    return c ? c->im : 0.0;
}

flux_complex_t* flux_complex_from_str(const char *s) {
    if (!s || !*s) return flux_complex_create(0.0, 0.0);
    const char *p_plus = strstr(s, " + ");
    const char *p_minus = strstr(s, " - ");
    if (p_plus) {
        double re = atof(s);
        double im = atof(p_plus + 3);
        return flux_complex_create(re, im);
    } else if (p_minus) {
        double re = atof(s);
        double im = -atof(p_minus + 3);
        return flux_complex_create(re, im);
    } else {
        if (strchr(s, 'i')) {
            double im = atof(s);
            return flux_complex_create(0.0, im);
        } else {
            double re = atof(s);
            return flux_complex_create(re, 0.0);
        }
    }
}

flux_complex_t* flux_complex_add(flux_complex_t *a, flux_complex_t *b) {
    double re_a = a ? a->re : 0.0;
    double im_a = a ? a->im : 0.0;
    double re_b = b ? b->re : 0.0;
    double im_b = b ? b->im : 0.0;
    return flux_complex_create(re_a + re_b, im_a + im_b);
}

flux_complex_t* flux_complex_sub(flux_complex_t *a, flux_complex_t *b) {
    double re_a = a ? a->re : 0.0;
    double im_a = a ? a->im : 0.0;
    double re_b = b ? b->re : 0.0;
    double im_b = b ? b->im : 0.0;
    return flux_complex_create(re_a - re_b, im_a - im_b);
}

flux_complex_t* flux_complex_mul(flux_complex_t *a, flux_complex_t *b) {
    double re_a = a ? a->re : 0.0;
    double im_a = a ? a->im : 0.0;
    double re_b = b ? b->re : 0.0;
    double im_b = b ? b->im : 0.0;
    return flux_complex_create(re_a * re_b - im_a * im_b, re_a * im_b + im_a * re_b);
}

flux_complex_t* flux_complex_mul_real(flux_complex_t *a, double re) {
    double re_a = a ? a->re : 0.0;
    double im_a = a ? a->im : 0.0;
    return flux_complex_create(re_a * re, im_a * re);
}

flux_complex_t* flux_complex_real_mul(double re, flux_complex_t *b) {
    double re_b = b ? b->re : 0.0;
    double im_b = b ? b->im : 0.0;
    return flux_complex_create(re * re_b, re * im_b);
}

flux_complex_t* flux_complex_add_real(double re, flux_complex_t *b) {
    double re_b = b ? b->re : 0.0;
    double im_b = b ? b->im : 0.0;
    return flux_complex_create(re + re_b, im_b);
}

flux_complex_t* flux_complex_real_add(flux_complex_t *a, double re) {
    double re_a = a ? a->re : 0.0;
    double im_a = a ? a->im : 0.0;
    return flux_complex_create(re_a + re, im_a);
}

flux_complex_t* flux_complex_neg(flux_complex_t *a) {
    double re = a ? a->re : 0.0;
    double im = a ? a->im : 0.0;
    return flux_complex_create(-re, -im);
}

char* flux_complex_to_str(flux_complex_t *a) {
    if (!a) {
        char *s = (char*)malloc(16);
        if (s) strcpy(s, "0.0 + 0.0i");
        return s;
    }
    char re_buf[32];
    char im_buf[32];
    format_double(re_buf, sizeof(re_buf), a->re);
    double im = a->im;
    char *res = (char*)malloc(80);
    if (!res) return NULL;
    if (im < 0) {
        format_double(im_buf, sizeof(im_buf), -im);
        snprintf(res, 80, "%s - %si", re_buf, im_buf);
    } else {
        format_double(im_buf, sizeof(im_buf), im);
        snprintf(res, 80, "%s + %si", re_buf, im_buf);
    }
    return res;
}

void flux_complex_print(flux_complex_t *a) {
    char *s = flux_complex_to_str(a);
    if (s) {
        printf("%s\n", s);
        free(s);
    }
}
