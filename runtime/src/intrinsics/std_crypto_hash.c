#include "flux/flux.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *flux_std_crypto_hash_dummy(const char *data) {
    (void)data;
    return strdup("");
}
