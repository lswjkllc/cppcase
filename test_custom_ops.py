# coding: utf-8

"""
@Author: Lauzee Liu
@software: Vscode
@file: test_custom_ops.py
@time: 2024/12/16
@description: test custom torch operators
"""

"""
Prepare: (compile and install library)
    # 方式一
    python setup.py install
    # 方式二
    pip install -e .
"""

import torch

import _custom_ops as ops


if __name__ == "__main__":
    a = torch.randn(3)
    b = torch.randn(3)
    c = a + b
    c_1 = ops.custom_add_1(a, b)
    c_2 = ops.custom_add_2(a, b)
    print(f"c   == c_1: { all(c == c_1) }")
    print(f"c   == c_2: { all(c == c_2) }")
    print(f"c_1 == c_2: { all(c_1 == c_2) }")
