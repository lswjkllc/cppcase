#include "ops.h"
#include "core/registration.h"

#include <torch/library.h>

TORCH_LIBRARY_EXPAND(CONCAT(TORCH_EXTENSION_NAME, _ops_1), ops) {
    ops.def("add_1(Tensor a, Tensor b) -> Tensor");
    ops.impl("add_1", torch::kCPU, &ADD);
}


TORCH_LIBRARY_EXPAND(CONCAT(TORCH_EXTENSION_NAME, _ops_2), ops) {
    ops.def("add_2", ADD);
}

REGISTER_EXTENSION(TORCH_EXTENSION_NAME)
