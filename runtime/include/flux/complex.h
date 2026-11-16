/* ==============================================================================
 * TheFlux Native Runtime: Complex Number Support
 * Header: runtime/include/flux/complex.h
 * ============================================================================== */

#ifndef FLUX_COMPLEX_H
#define FLUX_COMPLEX_H

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    double re;
    double im;
} flux_complex_t;

flux_complex_t* flux_complex_create(double re, double im);
double flux_complex_get_real(flux_complex_t *c);
double flux_complex_get_imag(flux_complex_t *c);
flux_complex_t* flux_complex_from_str(const char *s);
flux_complex_t* flux_complex_add(flux_complex_t *a, flux_complex_t *b);
flux_complex_t* flux_complex_sub(flux_complex_t *a, flux_complex_t *b);
flux_complex_t* flux_complex_mul(flux_complex_t *a, flux_complex_t *b);
flux_complex_t* flux_complex_mul_real(flux_complex_t *a, double re);
flux_complex_t* flux_complex_real_mul(double re, flux_complex_t *b);
flux_complex_t* flux_complex_add_real(double re, flux_complex_t *b);
flux_complex_t* flux_complex_real_add(flux_complex_t *a, double re);
flux_complex_t* flux_complex_neg(flux_complex_t *a);
void flux_complex_print(flux_complex_t *a);
char* flux_complex_to_str(flux_complex_t *a);

#ifdef __cplusplus
}
#endif

#endif /* FLUX_COMPLEX_H */
