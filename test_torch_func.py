# coding: utf-8

import torch
from torch.autograd import Function

import my_ops_mod


class MyAddFunction(Function):
    """
    forward's params: t1, t2
    forward's return: output

    backward's params: grad_output
    backward's return: grad_t1, grad_t2
    """

    @staticmethod
    def forward(ctx, t1, t2):
        output = my_ops_mod.my_add(t1, t2)
        ctx.save_for_backward(output)
        return output

    @staticmethod
    def backward(ctx, grad_output):
        v = grad_output / 2
        return v, v


class MyAddModule(torch.nn.Module):

    def __init__(self):
        super(MyAddModule, self).__init__()

    def forward(self, t1, t2):
        return MyAddFunction.apply(t1, t2)


if __name__ == '__main__':
    a = torch.rand([10, 10, 3])
    b = torch.rand([10, 10, 3])
    c = MyAddModule()(a, b)
    d = a + b
    assert torch.allclose(c, d), "Failed"
    print("Succeed")
