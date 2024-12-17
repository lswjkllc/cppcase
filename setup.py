import importlib.util
import io
import logging
import os
import re
import subprocess
import sys
from pathlib import Path
from shutil import which
from typing import Dict, List

import torch
# from packaging.version import Version, parse
from setuptools import Extension, find_packages, setup
from setuptools.command.build_ext import build_ext
# from setuptools_scm import get_version
# from torch.utils.cpp_extension import CUDA_HOME


ROOT_DIR = os.path.dirname(__file__)
logger = logging.getLogger(__name__)


# CPPCASE_TARGET_DEVICE = "cpu"


def is_ninja_available() -> bool:
    return which("ninja") is not None


def remove_prefix(text, prefix):
    if text.startswith(prefix):
        return text[len(prefix):]
    return text


class CMakeExtension(Extension):

    def __init__(self, name: str, cmake_lists_dir: str = '.', **kwa) -> None:
        super().__init__(name, sources=[], py_limited_api=True, **kwa)
        self.cmake_lists_dir = os.path.abspath(cmake_lists_dir)


class cmake_build_ext(build_ext):
    # A dict of extension directories that have been configured.
    did_config: Dict[str, bool] = {}

    #
    # Determine number of compilation jobs and optionally nvcc compile threads.
    #
    def compute_num_jobs(self):
        # `num_jobs` is either the value of the MAX_JOBS environment variable
        # (if defined) or the number of CPUs available.
        num_jobs = 8
        if num_jobs is not None:
            num_jobs = int(num_jobs)
            logger.info("Using MAX_JOBS=%d as the number of jobs.", num_jobs)
        else:
            try:
                # os.sched_getaffinity() isn't universally available, so fall
                #  back to os.cpu_count() if we get an error here.
                num_jobs = len(os.sched_getaffinity(0))
            except AttributeError:
                num_jobs = os.cpu_count()

        return num_jobs

    #
    # Perform cmake configuration for a single extension.
    #
    def configure(self, ext: CMakeExtension) -> None:
        # If we've already configured using the CMakeLists.txt for
        # this extension, exit early.
        if ext.cmake_lists_dir in cmake_build_ext.did_config:
            return

        cmake_build_ext.did_config[ext.cmake_lists_dir] = True

        # Select the build type.
        # Note: optimization level + debug info are set by the build type
        default_cfg = "Debug" if self.debug else "RelWithDebInfo"
        cfg = default_cfg

        cmake_args = [
            '-DCMAKE_BUILD_TYPE={}'.format(cfg),
            # '-DCPPCASE_TARGET_DEVICE={}'.format(CPPCASE_TARGET_DEVICE),
        ]

        # Pass the python executable to cmake so it can find an exact
        # match.
        cmake_args += ['-DCPPCASE_PYTHON_EXECUTABLE={}'.format(sys.executable)]

        # # Pass the python path to cmake so it can reuse the build dependencies
        # # on subsequent calls to python.
        # cmake_args += ['-DCPPCASE_PYTHON_PATH={}'.format(":".join(sys.path))]

        #
        # Setup parallelism and build tool
        #
        num_jobs = self.compute_num_jobs()

        if is_ninja_available():
            build_tool = ['-G', 'Ninja']
            cmake_args += [
                '-DCMAKE_JOB_POOL_COMPILE:STRING=compile',
                '-DCMAKE_JOB_POOLS:STRING=compile={}'.format(num_jobs),
            ]
        else:
            # Default build tool to whatever cmake picks.
            build_tool = []
        # 第三步：cmake 编译 == cmake ..
        subprocess.check_call(
            ['cmake', ext.cmake_lists_dir, *build_tool, *cmake_args],
            cwd=self.build_temp)

    # 第二步：在 run 方法中调用 build_extensions 方法
    def build_extensions(self) -> None:
        # Ensure that CMake is present and working
        try:
            subprocess.check_output(['cmake', '--version'])
        except OSError as e:
            raise RuntimeError('Cannot find CMake executable') from e

        # Create build directory if it does not exist.
        if not os.path.exists(self.build_temp):
            os.makedirs(self.build_temp)

        targets = []
        target_name = lambda s: remove_prefix(s, "cppcase.")
        # Build all the extensions
        for ext in self.extensions:
            # 第三步：调用 configure 方法（cmake 编译，需要 CMakeLists.txt 文件）
            self.configure(ext)
            targets.append(target_name(ext.name))

        num_jobs = self.compute_num_jobs()

        build_args = [
            "--build",
            ".",
            f"-j={num_jobs}",
            *[f"--target={name}" for name in targets],
        ]

        # 第四步: make 编译 == cmake --build
        subprocess.check_call(["cmake", *build_args], cwd=self.build_temp)

        # Install the libraries
        for ext in self.extensions:
            # Install the extension into the proper location
            outdir = Path(self.get_ext_fullpath(ext.name)).parent.absolute()

            # Skip if the install directory is the same as the build directory
            if outdir == self.build_temp:
                continue

            # CMake appends the extension prefix to the install path,
            # and outdir already contains that prefix, so we need to remove it.
            prefix = outdir
            for i in range(ext.name.count('.')):
                prefix = prefix.parent

            # prefix here should actually be the same for all components
            install_args = [
                "cmake", "--install", ".", "--prefix", prefix, "--component",
                target_name(ext.name)
            ]
            # 第五步: make install == cmake --install
            subprocess.check_call(install_args, cwd=self.build_temp)

    # 第一步：运行 run 方法
    def run(self):
        # First, run the standard build_ext command to compile the extensions
        super().run()

        # Other custom logic ------------------------------------------------
        # Example:
        # ```python
        # import glob
        # # 搜索需要的文件
        # files = glob.glob(
        #     os.path.join(self.build_lib, ..., "*.py"))
        # # 循环处理需要的文件
        # for file in files:
        #     dst_file = os.path.join("cppcase", os.path.basename(file))
        #     print(f"Copying {file} to {dst_file}")
        #     # 拷贝需要的文件到目标路径
        #     self.copy_file(file, dst_file)
        # ```
        # Other custom logic ------------------------------------------------


def get_path(*filepath) -> str:
    return os.path.join(ROOT_DIR, *filepath)


def get_cppcase_version() -> str:
    return "0.0.0-dev"


def read_readme() -> str:
    """Read the README file if present."""
    p = get_path("README.md")
    if os.path.isfile(p):
        return io.open(get_path("README.md"), "r", encoding="utf-8").read()
    else:
        return ""


def get_requirements() -> List[str]:
    """Get Python package dependencies from requirements.txt."""

    def _read_requirements(filename: str) -> List[str]:
        with open(get_path(filename)) as f:
            requirements = f.read().strip().split("\n")
        resolved_requirements = []
        for line in requirements:
            if line.startswith("-r "):
                resolved_requirements += _read_requirements(line.split()[1])
            elif line.startswith("--"):
                continue
            else:
                resolved_requirements.append(line)
        return resolved_requirements

    requirements = _read_requirements("requirements.txt")

    return requirements


ext_modules = []
ext_modules.append(CMakeExtension(name="cppcase._C"))


setup(
    name="cppcase",
    version=get_cppcase_version(),
    author="cppcase Team",
    license="Apache 2.0",
    description=("A temp cppcase project."),
    long_description=read_readme(),
    long_description_content_type="text/markdown",
    url="",
    project_urls={
        "Homepage": "",
        "Documentation": "",
    },
    classifiers=[
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Programming Language :: Python :: 3.12",
        "License :: OSI Approved :: Apache Software License",
    ],
    packages=find_packages(exclude=("benchmarks", "csrc", "docs", "examples",
                                    "tests*")),
    python_requires=">=3.8",
    install_requires=get_requirements(),
    ext_modules=ext_modules,
    extras_require={},
    cmdclass={"build_ext": cmake_build_ext} if len(ext_modules) > 0 else {},
    package_data={},
    # entry_points={
    #     "console_scripts": [
    #         "vllm=vllm.scripts:main",
    #     ],
    # },
)
