// #include <torch/library.h>
#include <torch/torch.h>

torch::Tensor ADD(const torch::Tensor& a, const torch::Tensor& b){
    return a+b;
}