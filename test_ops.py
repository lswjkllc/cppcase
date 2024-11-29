# coding: utf-8

import os

import torch


def test_add():
    # clean build
    os.system("rm -rf ./build/*")
    # cmake 执行 cd build && cmake ..
    os.system("cd ./build/ && cmake .. -Wno-dev")
    # compile
    os.system("cd ./build/ && make")

    lib_path = "./build/libops_lib.so"
    torch.ops.load_library(lib_path)

    a = torch.rand([10, 10, 3])
    b = torch.rand([10, 10, 3])
    c = torch.ops.my_ops_lib.my_add(a, b)
    d = a + b
    assert torch.allclose(c, d), "Failed"
    print("Succeed")


def test_add2():
    # clean build
    os.system("rm -rf ./dist && rm -rf ./my_ops_mod.egg-info")
    # setup install
    os.system("python setup.py install")

    import my_ops_mod
    a = torch.rand([10, 10, 3])
    b = torch.rand([10, 10, 3])
    c = my_ops_mod.my_add(a, b)
    d = a + b
    assert torch.allclose(c, d), "Failed"
    print("Succeed")


if __name__ == "__main__":
    # test
    # test_add()
    test_add2()
