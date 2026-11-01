/* ==============================================================================
 * TheFlux Native Runtime: Multi-dimensional Tensor Primitives
 * Header: runtime/include/flux/tensor.h
 * ============================================================================== */

#ifndef FLUX_TENSOR_H
#define FLUX_TENSOR_H

#include "types.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    int64_t *shape;
    int64_t *strides;
    int64_t ndim;
    int64_t total_elements;
    double *data;
} FluxTensor;

FluxTensor *flux_tensor_create(const int64_t *shape, int64_t ndim);
double flux_tensor_get(FluxTensor *tensor, const int64_t *indices);
void flux_tensor_set(FluxTensor *tensor, const int64_t *indices, double value);
void flux_tensor_free(FluxTensor *tensor);

#ifdef __cplusplus
}
#endif

#endif /* FLUX_TENSOR_H */
