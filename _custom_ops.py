import logging 
import functools
# from typing import TYPE_CHECKING, List, Optional, Tuple, Union

import torch
import torch.library


logger = logging.getLogger(__name__)

try:
    import cppcase._C
    print("---> loading cppcase._C successfully.")
except ImportError as e:
    logger.warning("Failed to import from cppcase._C with %r", e)


# if TYPE_CHECKING:

#     def register_fake(fn):
#         return lambda name: fn
# else:
#     try:
#         from torch.library import register_fake
#     except ImportError:
#         from torch.library import impl_abstract as register_fake


def hint_on_error(fn):

    @functools.wraps(fn)
    def wrapper(*args, **kwargs):
        try:
            return fn(*args, **kwargs)

        except NotImplementedError as e:
            msg = (
                "Error in calling custom op %s: %s\n"
                "Not implemented or built, mostly likely because the current current device "
                "does not support this kernel (less likely TORCH_CUDA_ARCH_LIST was set "
                "incorrectly while building)")
            logger.error(msg, fn.__name__, e)
            raise NotImplementedError(msg % (fn.__name__, e)) from e
        except AttributeError as e:
            msg = (
                "Error in calling custom op %s: %s\n"
                "Possibly you have built or installed an obsolete version of vllm.\n"
                "Please try a clean build and install of vllm,"
                "or remove old built files such as vllm/*cpython*.so and build/ ."
            )
            logger.error(msg, fn.__name__, e)
            raise e

    return wrapper


# basic ops
def custom_add_1(a: torch.Tensor, b: torch.Tensor) -> torch.Tensor:
    return torch.ops._C_ops_1.add_1(a, b)

def custom_add_2(a: torch.Tensor, b: torch.Tensor) -> torch.Tensor:
    return torch.ops._C_ops_2.add_2(a, b)


# temporary fix for https://github.com/vllm-project/vllm/issues/5456
# TODO: remove this in v0.6.0
names_and_values = globals()
names_and_values_to_update = {}
# prepare variables to avoid dict size change during iteration
k, v, arg = None, None, None
fn_type = type(lambda x: x)
for k, v in names_and_values.items():
    # find functions that are defined in this file and have torch.Tensor
    # in their annotations. `arg == "torch.Tensor"` is used to handle
    # the case when users use `import __annotations__` to turn type
    # hints into strings.
    if isinstance(v, fn_type) \
        and v.__code__.co_filename == __file__ \
        and any(arg is torch.Tensor or arg == "torch.Tensor"
                for arg in v.__annotations__.values()):
        names_and_values_to_update[k] = hint_on_error(v)

names_and_values.update(names_and_values_to_update)
del names_and_values_to_update, names_and_values, v, k, fn_type
