cmake_minimum_required(VERSION 3.10)
project(cpplangcase LANGUAGES CXX)

message(STATUS "CMAKE_CURRENT_LIST_DIR: ${CMAKE_CURRENT_LIST_DIR}")
# CMAKE_CURRENT_LIST_DIR 是 CMake 提供的一个内置变量，用于表示当前正在处理的 CMakeLists.txt 文件的完整路径。
# 这个变量在 CMake 处理构建脚本时自动设置，不需要用户手动设置；是一个只读变量，用户不能直接修改它的值。

# message(STATUS "----------------------------------------------include(...)----------------------------------------------------------------------")
# include(${CMAKE_CURRENT_LIST_DIR}/cmake/utils.cmake)
# # include 用于将其他 CMake 文件包含到当前文件中。
# # 有助于组织大型项目的构建脚本并避免代码重复。
# # 可以将公共的、模块化的构建逻辑封装到单独的文件中，并在需要的地方引用它们。

# include(${CMAKE_CURRENT_LIST_DIR}/cmake/buildin-common.cmake)
# include(${CMAKE_CURRENT_LIST_DIR}/cmake/buildin-deps.cmake)
# include(${CMAKE_CURRENT_LIST_DIR}/cmake/buildin-props.cmake)
# message(STATUS "----------------------------------------------include(...)----------------------------------------------------------------------\n")

# message(STATUS "----------------------------------------------find_python_from_executable(...)----------------------------------------------------------------------")
# set(PYTHON_EXECUTABLE "/opt/homebrew/bin/python3.11")
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

find_package(Python COMPONENTS Interpreter Development.Module Development.SABIModule)
message(STATUS "-- Python_FOUND<${Python_FOUND}>, Python_VERSION<${Python_VERSION}>")
message(STATUS "-- Python_DIR<${Python_DIR}>, Python_INCLUDE_DIRS<${Python_INCLUDE_DIRS}>, Python_LIBRARIES<${Python_LIBRARIES}>")

execute_process(
    COMMAND
    "${Python_EXECUTABLE}" "-c" "import torch; print(torch.utils.cmake_prefix_path)"
    OUTPUT_VARIABLE PYTHON_OUT
    RESULT_VARIABLE PYTHON_ERROR_CODE
    ERROR_VARIABLE PYTHON_STDERR
    OUTPUT_STRIP_TRAILING_WHITESPACE)
list(APPEND CMAKE_PREFIX_PATH ${PYTHON_OUT})
find_package(Torch REQUIRED) # 需要设置 Torch_DIR 或者 CMAKE_PREFIX_PATH
message(STATUS "-- TORCH_FOUND<${TORCH_FOUND}>")

add_executable(ops ops.cc)
target_compile_features(ops PRIVATE cxx_std_17)
target_link_libraries(ops "${TORCH_LIBRARIES}")
