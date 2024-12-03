
message(STATUS "----------------------------------------------find_package(... REQUIRED)----------------------------------------------------------------------")
find_package(OpenSSL REQUIRED)
# find_package(OpenSSL REQUIRED): 是 CMake 中的一个命令，用于查找 OpenSSL 库。
# 其中，REQUIRED 表示必须找到，否则会报错。
# 如果找到了 OpenSSL 库，CMake 会自动设置/引用一些变量：
#       OPENSSL_FOUND
#       OPENSSL_VERSION
#       OPENSSL_INCLUDE_DIR
#       OPENSSL_LIBRARIES
message(STATUS "OpenSSL OPENSSL_FOUND: ${OPENSSL_FOUND}")
message(STATUS "OpenSSL OPENSSL_VERSION: ${OPENSSL_VERSION}")
message(STATUS "OpenSSL OPENSSL_INCLUDE_DIR: ${OPENSSL_INCLUDE_DIR}")
message(STATUS "OpenSSL OPENSSL_LIBRARIES: ${OPENSSL_LIBRARIES}")
message(STATUS "----------------------------------------------find_package(... REQUIRED)----------------------------------------------------------------------\n")

message(STATUS "----------------------------------------------Python3_add_library(...)----------------------------------------------------------------------")
find_package(Python3 COMPONENTS Development)
# include_directories(${Python3_INCLUDE_DIRS})
Python3_add_library(hello MODULE hello.cc)
# 在cmake版本3.12开始，提供了1个非常好用的Python_add_library命令。
# 详情可以：https://cmake.org/cmake/help/v3.12/module/FindPython.html。借助该命令,我们可以快速生成Python的C扩展。
# 使用时需要先使用：find_package 才能导入相关函数。
message(STATUS "----------------------------------------------Python3_add_library(...)----------------------------------------------------------------------\n")

message(STATUS "----------------------------------------------find_program(...)----------------------------------------------------------------------")
message(STATUS "-- FIND_CXX_EXECUTABLE<${FIND_CXX_EXECUTABLE}>")
find_program(FIND_CXX_EXECUTABLE c++)
# find_program 是 cmake 中的一个命令，用于查找指定的程序。
# 该命令会在系统的环境变量路径中搜索指定的程序，并将其路径存储到指定的变量中。
# 这段代码的作用是在系统的环境变量路径中搜索 c++ 程序，并将找到的 c++ 程序的路径存储到 FIND_CXX_EXECUTABLE 变量中。
message(STATUS "-- FIND_CXX_EXECUTABLE<${FIND_CXX_EXECUTABLE}>")
message(STATUS "-- CUDA_FOUND<${CUDA_FOUND}>")
message(STATUS "-- NVCC_FOUND<${NVCC_FOUND}>")
message(STATUS "----------------------------------------------find_program(...)----------------------------------------------------------------------\n")

message(STATUS "----------------------------------------------install(CODE  ...)----------------------------------------------------------------------")
install(CODE "set(CMAKE_INSTALL_LOCAL_ONLY TRUE)" ALL_COMPONENTS)
# install(CODE ...): 是 CMake 中的一个命令，用于在安装阶段执行特定的代码。
# ALL_COMPONENTS: 是 install 命令的一个可选参数，用于指定安装的所有组件。
# "set(CMAKE_INSTALL_LOCAL_ONLY TRUE)": 是要执行的 CMake 代码。
# 其中，set 是 CMake 中的一个命令，用于设置变量的值；
# 其中，CMAKE_INSTALL_LOCAL_ONLY 是一个 CMake 变量，当设置为 TRUE 时，表示安装仅限于本地，不会影响系统的全局安装。

install(CODE "set(CMAKE_INSTALL_LOCAL_ONLY FALSE)" COMPONENT vllm_flash_attn_c)
# COMPONENT vllm_flash_attn_c 指定了安装组件的名称，这有助于在后续的安装步骤中对不同的组件进行细粒度的控制和管理。
message(STATUS "----------------------------------------------install(CODE  ...)----------------------------------------------------------------------\n")

message(STATUS "----------------------------------------------install(TARGETS  ...)----------------------------------------------------------------------")
install(
    TARGETS ${GPU_MOD_NAME}
    LIBRARY
    DESTINATION ${GPU_DESTINATION}
    COMPONENT ${GPU_MOD_NAME})
# install(TARGETS ...): 用于定义如何安装一个目标（通常是一个库）到指定的目录，并指定安装的组件。
# TARGETS ${GPU_MOD_NAME}: 表示要安装的目标名称。通常这个目标是一个库（如共享库或静态库）。
# LIBRARY: 这个关键字表示要安装的是一个库文件。通常用于共享库（.so 或 .dll）或静态库（.a 或 .lib）。
# DESTINATION ${GPU_DESTINATION}: 表示库文件将被安装到的目标目录。这个目录可以是绝对路径或相对于安装前缀的路径。
# COMPONENT ${GPU_MOD_NAME}: 这个关键字用于指定安装的组件名称。组件是CMake中用于组织安装文件的一种方式，允许用户选择性地安装某些组件。
message(STATUS "----------------------------------------------install(TARGETS  ...)----------------------------------------------------------------------\n")

message(STATUS "----------------------------------------------execute_process(COMMAND ...)----------------------------------------------------------------------")
set(PYTHON_TEMP_EXPR "print('Hello, World!')")
execute_process(
    COMMAND "${Python_EXECUTABLE}" "-c" "${PYTHON_TEMP_EXPR}"
    OUTPUT_VARIABLE PYTHON_OUT
    RESULT_VARIABLE PYTHON_ERROR_CODE
    ERROR_VARIABLE PYTHON_STDERR
    OUTPUT_STRIP_TRAILING_WHITESPACE)
# execute_process: 是 CMake 的一个命令，用于执行外部进程。可以执行命令行命令，并捕获输出、错误代码等信息。
# COMMAND: 指定要执行的命令。在这个例子中，命令是 Python 解释器执行一个 Python 表达式。
# OUTPUT_VARIABLE: 指定一个变量来存储命令的标准输出。在这个例子中，标准输出将被存储在 PYTHON_OUT 变量中。
# RESULT_VARIABLE: 指定一个变量来存储命令的返回值（错误代码）。在这个例子中，返回值将被存储在 PYTHON_ERROR_CODE 变量中。
# ERROR_VARIABLE: 指定一个变量来存储命令的标准错误输出。在这个例子中，标准错误输出将被存储在 PYTHON_STDERR 变量中。
# OUTPUT_STRIP_TRAILING_WHITESPACE: 这是一个选项，表示从输出中去除尾随的空白字符（如换行符）。
message(STATUS "-- execute_process(COMMAND ...) PYTHON_OUT<${PYTHON_OUT}>")
message(STATUS "-- execute_process(COMMAND ...) PYTHON_ERROR_CODE<${PYTHON_ERROR_CODE}>")
message(STATUS "-- execute_process(COMMAND ...) PYTHON_STDERR<${PYTHON_STDERR}>")
message(STATUS "----------------------------------------------execute_process(COMMAND ...)----------------------------------------------------------------------\n")

message(STATUS "----------------------------------------------list(APPEND/REMOVE_ITEM/SORT ...)----------------------------------------------------------------------")
list(APPEND PYTHON_OUT_LIST "3")
list(APPEND PYTHON_OUT_LIST "1" "2")
# list 是 cmake 中的一个命令，用于操作列表变量。
# APPEND 是 list 命令的一个子命令，用于向列表中添加元素。
# PYTHON_OUT_LIST 是一个列表变量，代码的作用是将一个个新的元素添加到这个列表中。
message(STATUS "-- list APPEND PYTHON_OUT_LIST<${PYTHON_OUT_LIST}>")

list(REMOVE_ITEM PYTHON_OUT_LIST "${PYTHON_OUT}-1")
message(STATUS "-- list REMOVE_ITEM PYTHON_OUT_LIST<${PYTHON_OUT_LIST}>")

list(SORT PYTHON_OUT_LIST COMPARE NATURAL ORDER ASCENDING)
message(STATUS "-- list.SORT PYTHON_OUT_LIST<${PYTHON_OUT_LIST}>")
message(STATUS "----------------------------------------------list(APPEND/REMOVE_ITEM/SORT ...)----------------------------------------------------------------------\n")

message(STATUS "----------------------------------------------include and create directory----------------------------------------------------------------------")
include(FetchContent)
# 引入了 FetchContent 模块，该模块允许你在 CMake 项目中自动下载和包含外部依赖项。

get_filename_component(PROJECT_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}" ABSOLUTE)
# 使用 get_filename_component 函数获取当前源目录的绝对路径，并将其存储在变量 PROJECT_ROOT_DIR 中。
# CMAKE_CURRENT_SOURCE_DIR 是 CMake 内置变量，表示当前处理的 CMakeLists.txt 文件所在的目录。

set(FETCHCONTENT_BASE_DIR "${PROJECT_ROOT_DIR}/.deps")
# 将 FETCHCONTENT_BASE_DIR 变量设置为项目根目录下的 .deps 目录。
# 之后，所有通过 FetchContent 下载的依赖项都会存储在这个目录中。

file(MAKE_DIRECTORY "${FETCHCONTENT_BASE_DIR}")
# 使用 file 命令的 MAKE_DIRECTORY 选项来创建一个目录。
# FETCHCONTENT_BASE_DIR 是一个变量，表示 FetchContent 模块下载依赖项时使用的目录。
# include(FetchContent) 执行后，FETCHCONTENT_BASE_DIR 变量将被自动填充为：<当前执行目录>/_deps/
message(STATUS "----------------------------------------------include and create directory----------------------------------------------------------------------\n")

message(STATUS "----------------------------------------------FetchContent_Declare and FetchContent_MakeAvailable----------------------------------------------------------------------")
SET(CUTLASS_ENABLE_HEADERS_ONLY ON CACHE BOOL "Enable only the header library")
# CUTLASS_ENABLE_HEADERS_ONLY: 这是一个缓存变量，用于指示是否仅使用CUTLASS的头文件库。
# ON: 设置为ON表示启用仅头文件模式。
# CACHE BOOL: 将该变量存储在CMake的缓存中，并将其类型定义为布尔值。
# "Enable only the header library": 这是该变量的描述，用于在CMake GUI或命令行中提供帮助信息。

set(CUTLASS_REVISION "v3.5.1" CACHE STRING "CUTLASS revision to use")
# CUTLASS_REVISION: 这是一个缓存变量，用于指定要使用的CUTLASS版本。
# "v3.5.1": 这是具体的版本号，表示要使用CUTLASS的v3.5.1版本。
# CACHE STRING: 将该变量存储在CMake的缓存中，并将其类型定义为字符串。
# "CUTLASS revision to use": 这是该变量的描述，用于在CMake GUI或命令行中提供帮助信息。

# include(FetchContent)
# 使用 FetchContent_Declare 和 FetchContent_MakeAvailable 命令必须先引入 FetchContent 模块。
FetchContent_Declare(
    cutlass
    GIT_REPOSITORY https://github.com/nvidia/cutlass.git
    GIT_TAG v3.5.1
    GIT_PROGRESS TRUE
    GIT_SHALLOW TRUE
)
message(STATUS "--> cutlass_POPULATED: ${cutlass_POPULATED}")
message(STATUS "--> cutlass_SOURCE_DIR: ${cutlass_SOURCE_DIR}")
message(STATUS "--> cutlass_BINARY_DIR: ${cutlass_BINARY_DIR}")
# FetchContent_Declare: 声明一个外部内容，这里是指CUTLASS库。
# cutlass: 这是声明的名称，用于后续引用。
# GIT_REPOSITORY: 指定CUTLASS库的Git仓库地址。
# GIT_TAG: 指定要获取的特定版本或标签，这里设置为v3.5.1。
# GIT_PROGRESS TRUE: 启用Git操作的进度显示。
# GIT_SHALLOW TRUE: 启用浅克隆（shallow clone），只获取指定标签或分支的最新提交，而不获取整个仓库的历史记录（可以加快下载速度）。

FetchContent_MakeAvailable(cutlass)
message(STATUS "--> cutlass_POPULATED: ${cutlass_POPULATED}")
message(STATUS "--> cutlass_SOURCE_DIR: ${cutlass_SOURCE_DIR}")
message(STATUS "--> cutlass_BINARY_DIR: ${cutlass_BINARY_DIR}")
# FetchContent_MakeAvailable: 使声明的外部内容可用，即下载并配置CUTLASS库。
# FetchContent_MakeAvailable 内部工作流程：
#       1. 检查依赖是否可用：检查 cutlass_POPULATED 变量；
#       2. if(NOT cutlass_POPULATED) ：调用 FetchContent_Populate 下载和解压外部项目；
#       3. 设置源码目录：FetchContent_Populate 完成后，会设置源码目录的路径，以便后续的配置和构建步骤使用；
#       4. 配置和构建依赖：进入依赖项目的源码目录，并调用 add_subdirectory 来配置和构建该项目；
#       5. 标记依赖已可用：set(cutlass_POPULATED TRUE) 
message(STATUS "----------------------------------------------FetchContent_Declare and FetchContent_MakeAvailable----------------------------------------------------------------------\n")
