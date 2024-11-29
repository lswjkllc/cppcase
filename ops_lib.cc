// ops_lib.cc
#include <torch/torch.h>

torch::Tensor my_add(torch::Tensor t1, torch::Tensor t2)
{
	assert(t1.size(0) == t2.size(0));
	assert(t1.size(1) == t2.size(1));

	torch::Tensor output = t1 + t2;
	return output;
}

// cd build/ && cmake ..
TORCH_LIBRARY(my_ops_lib, m)
{
	m.def("my_add", my_add);
}
