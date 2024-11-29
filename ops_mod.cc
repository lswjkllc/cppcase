// ops.cc
#include <torch/torch.h>
#include <pybind11/pybind11.h>

torch::Tensor my_add(torch::Tensor t1, torch::Tensor t2)
{
	assert(t1.size(0) == t2.size(0));
	assert(t1.size(1) == t2.size(1));

	torch::Tensor output = t1 + t2;
	return output;
}

// python setup.py install
PYBIND11_MODULE(my_ops_mod, m)
{
	m.def("my_add", my_add);
}
