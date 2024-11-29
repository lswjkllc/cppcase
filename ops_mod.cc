// ops.cc
#include <torch/extension.h>

// <torch/extension.h> 是 “一站式” 头文件，包含编写 C++ 扩展所需的所有 PyTorch 内容。 这包括：
// 		ATen 库，这是我们用于张量计算的主要 API，
// 		pybind11，这是我们为 C++ 代码创建 Python 绑定的方式，
// 		以及管理 ATen 和 pybind11 之间交互细节的头文件。
// PyTorch 的张量和变量接口是从 ATen 库自动生成的，因此我们可以或多或少地将 Python 实现 1:1 转换为 C++。 
// 相关 C++ API 的文档可以在 https://pytorch.org/cppdocs/api/classat_1_1_tensor.html 中找到。
// 另请注意，我们可以包含 <iostream> 等 C 或 C++ 头文件，并支持 C++11 的全部功能。

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
