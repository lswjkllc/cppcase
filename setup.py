# coding: utf-8

from setuptools import setup
from torch.utils import cpp_extension

include_dirs = []
library_dirs = []
libraries = []

setup(
    name='my_ops_mod',
    ext_modules=[
        cpp_extension.CppExtension(
            'my_ops_mod', ['ops_mod.cc'],
            include_dirs=include_dirs,
            library_dirs=library_dirs,
            libraries=libraries)],
    cmdclass={'build_ext': cpp_extension.BuildExtension})
