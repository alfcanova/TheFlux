/* ==============================================================================
 * TheFlux Native Runtime: Multi-dimensional Tensors
 * Source: runtime/src/collections/tensor.c
 * ============================================================================== */

#include "flux/tensor.h"
#include <stdlib.h>
#include <string.h>

FluxTensor *flux_tensor_create(const int64_t *shape, int64_t ndim) {
    if (!shape || ndim <= 0) return NULL;
    FluxTensor *t = (FluxTensor *)malloc(sizeof(FluxTensor));
    if (!t) return NULL;

    t->ndim = ndim;
    t->shape = (int64_t *)malloc(sizeof(int64_t) * ndim);
    t->strides = (int64_t *)malloc(sizeof(int64_t) * ndim);

    int64_t total = 1;
    for (int64_t i = ndim - 1; i >= 0; i--) {
        t->shape[i] = shape[i];
        t->strides[i] = total;
        total *= shape[i];
    }
    t->total_elements = total;
    t->data = (double *)calloc(total, sizeof(double));
    return t;
}

double flux_tensor_get(FluxTensor *tensor, const int64_t *indices) {
    if (!tensor || !indices) return 0.0;
    int64_t offset = 0;
    for (int64_t i = 0; i < tensor->ndim; i++) {
        offset += indices[i] * tensor->strides[i];
    }
    if (offset < 0 || offset >= tensor->total_elements) return 0.0;
    return tensor->data[offset];
}

void flux_tensor_set(FluxTensor *tensor, const int64_t *indices, double value) {
    if (!tensor || !indices) return;
    int64_t offset = 0;
    for (int64_t i = 0; i < tensor->ndim; i++) {
        offset += indices[i] * tensor->strides[i];
    }
    if (offset >= 0 && offset < tensor->total_elements) {
        tensor->data[offset] = value;
    }
}

void flux_tensor_free(FluxTensor *tensor) {
    if (!tensor) return;
    if (tensor->shape) free(tensor->shape);
    if (tensor->strides) free(tensor->strides);
    if (tensor->data) free(tensor->data);
    free(tensor);
}
