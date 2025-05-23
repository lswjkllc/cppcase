cmake_minimum_required(VERSION 3.10)
project(cpplangcase LANGUAGES CXX)

message(STATUS "CMAKE_CURRENT_LIST_DIR: ${CMAKE_CURRENT_LIST_DIR}")
# CMAKE_CURRENT_LIST_DIR 是 CMake 提供的一个内置变量，用于表示当前正在处理的 cmake 文件的完整路径。
# 这个变量在 CMake 处理构建脚本时自动设置，不需要用户手动设置；是一个只读变量，用户不能直接修改它的值。

message(STATUS "CMAKE_CURRENT_SOURCE_DIR: ${CMAKE_CURRENT_SOURCE_DIR}")
# CMAKE_CURRENT_SOURCE_DIR 是 CMake 提供的一个内置变量，用于表示当前正在处理的 CMakeLists.txt 文件的完整路径。
# 这个变量在 CMake 处理构建脚本时自动设置，不需要用户手动设置；是一个只读变量，用户不能直接修改它的值。

message(STATUS "----------------------------------------------include(...)----------------------------------------------------------------------")
include(${CMAKE_CURRENT_LIST_DIR}/cmake/utils.cmake)
# include 用于将其他 CMake 文件包含到当前文件中。
# 有助于组织大型项目的构建脚本并避免代码重复。
# 可以将公共的、模块化的构建逻辑封装到单独的文件中，并在需要的地方引用它们。

# include(${CMAKE_CURRENT_LIST_DIR}/cmake/buildin-common.cmake)
# include(${CMAKE_CURRENT_LIST_DIR}/cmake/buildin-deps.cmake)
# include(${CMAKE_CURRENT_LIST_DIR}/cmake/buildin-ops.cmake)
# include(${CMAKE_CURRENT_LIST_DIR}/cmake/buildin-props.cmake)
# include(${CMAKE_CURRENT_LIST_DIR}/cmake/buildin-file.cmake)
# include(${CMAKE_CURRENT_LIST_DIR}/cmake/buildin-cache.cmake)
message(STATUS "----------------------------------------------include(...)----------------------------------------------------------------------\n")

# message(STATUS "----------------------------------------------find_python_from_executable(...)----------------------------------------------------------------------")
# set(PYTHON_EXECUTABLE "/usr/bin/python")
# set(PYTHON_SUPPORTED_VERSIONS "3.9" "3.10" "3.11")
# # find_python_from_executable 来自文件：${CMAKE_CURRENT_LIST_DIR}/cmake/utils.cmake
# find_python_from_executable(${PYTHON_EXECUTABLE} ${PYTHON_SUPPORTED_VERSIONS})
# message(STATUS "----------------------------------------------find_python_from_executable(...)----------------------------------------------------------------------\n")

# message(STATUS "----------------------------------------------use_cmake_parse_arguments(...)----------------------------------------------------------------------")
# set(TEMP_EXT_SRC "csrc/core/torch_bindings.cpp")
# set(CXX_COMPILE_FLAGS "")
# # use_cmake_parse_arguments 来自文件：${CMAKE_CURRENT_LIST_DIR}/cmake/utils.cmake
# use_cmake_parse_arguments(
#     _core_C
#     DESTINATION vllm
#     LANGUAGE CXX
#     SOURCES ${TEMP_EXT_SRC}
#     COMPILE_FLAGS ${CXX_COMPILE_FLAGS}
#     USE_SABI 3
#     WITH_SOABI)
# message(STATUS "----------------------------------------------use_cmake_parse_arguments(...)----------------------------------------------------------------------\n")

# message(STATUS "----------------------------------------------set_gencode_flag_for_srcs(...)----------------------------------------------------------------------")
# set(TEMP_EXT_SRC "hello.cc")
# set(TEMP_ARCH "8.9")
# set(TEMP_CODE "8.9")
# # set_gencode_flags_for_srcs 来自文件：${CMAKE_CURRENT_LIST_DIR}/cmake/utils.cmake
# set_gencode_flag_for_srcs(
#     SRCS "${TEMP_EXT_SRC}"
#     ARCH "compute_${TEMP_ARCH}"
#     CODE "sm_${TEMP_CODE}")
# message(STATUS "----------------------------------------------set_gencode_flag_for_srcs(...)----------------------------------------------------------------------\n")

message(STATUS "----------------------------------------------Python Setttings----------------------------------------------------------------------")
set(PYTHON_SUPPORTED_VERSIONS "3.8" "3.9" "3.10" "3.11" "3.12")
if (CPPCASE_PYTHON_EXECUTABLE)
  find_python_from_executable(${CPPCASE_PYTHON_EXECUTABLE} "${PYTHON_SUPPORTED_VERSIONS}")
else()
  message(FATAL_ERROR
    "Please set CPPCASE_PYTHON_EXECUTABLE to the path of the desired python version"
    " before running cmake configure.")
endif()
message(STATUS "----------------------------------------------Python Setttings----------------------------------------------------------------------\n")

message(STATUS "----------------------------------------------Torch Setttings----------------------------------------------------------------------")
# Prerequirements: Python Setttings

run_python("import torch; print(torch.utils.cmake_prefix_path)" PYTORCH_OUT)
list(APPEND CMAKE_PREFIX_PATH ${PYTORCH_OUT})
find_package(Torch REQUIRED) # 需要设置 Torch_DIR 或者 CMAKE_PREFIX_PATH
message(STATUS "-- TORCH_FOUND<${TORCH_FOUND}>, Torch_VERSION<${Torch_VERSION}>, TORCH_INCLUDE_DIRS<${TORCH_INCLUDE_DIRS}>")
message(STATUS "----------------------------------------------Torch Setttings----------------------------------------------------------------------\n")

message(STATUS "----------------------------------------------Pybind11 Setttings----------------------------------------------------------------------")
# Prerequirements: Python Setttings

run_python("import pybind11; print(pybind11.get_cmake_dir())" PYBIND11_OUT)
list(APPEND CMAKE_PREFIX_PATH "${PYBIND11_OUT}/../")
find_package(pybind11 REQUIRED) # 需要设置 Torch_DIR 或者 CMAKE_PREFIX_PATH
message(STATUS "-- pybind11_FOUND<${pybind11_FOUND}>")

# add_executable(ops_lib ops_lib.cc)
add_library(ops_lib SHARED ops_lib.cc)
target_compile_features(ops_lib PRIVATE cxx_std_17)
target_include_directories(ops_lib PRIVATE "${Python_INCLUDE_DIRS}")
target_link_libraries(ops_lib "${TORCH_LIBRARIES}")
message(STATUS "----------------------------------------------Pybind11 Setttings----------------------------------------------------------------------\n")

message(STATUS "----------------------------------------------compile csrc dir for cppcase package----------------------------------------------------------------------")
# Prerequirements: Python Setttings and Torch Setttings

set(C_EXT_SRC
  "csrc/basic.cc"
  "csrc/torch_bindings.cc")

message(STATUS "Enabling C extension.")
define_torch_extension_target(
  _C
  DESTINATION cppcase
  LANGUAGE CPU
  SOURCES ${C_EXT_SRC}
  COMPILE_FLAGS ""
  ARCHITECTURES ""
  INCLUDE_DIRECTORIES ${CUTLASS_INCLUDE_DIR}
  USE_SABI 3
  WITH_SOABI)
message(STATUS "----------------------------------------------compile csrc dir for cppcase package----------------------------------------------------------------------\n")
