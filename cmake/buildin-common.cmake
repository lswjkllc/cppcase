
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

message(STATUS "----------------------------------------------list(APPEND ...)----------------------------------------------------------------------")
list(APPEND PYTHON_OUT_LIST "${PYTHON_OUT}-1" "${PYTHON_OUT}-2")
list(APPEND PYTHON_OUT_LIST "${PYTHON_OUT}-3")
# list 是 cmake 中的一个命令，用于操作列表变量。
# APPEND 是 list 命令的一个子命令，用于向列表中添加元素。
# PYTHON_OUT_LIST 是一个列表变量，代码的作用是将一个个新的元素添加到这个列表中。
message(STATUS "-- PYTHON_OUT_LIST<${PYTHON_OUT_LIST}>")
message(STATUS "----------------------------------------------list(APPEND ...)----------------------------------------------------------------------\n")
