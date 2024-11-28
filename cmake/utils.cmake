
macro (find_python_from_executable EXECUTABLE SUPPORTED_VERSIONS)
    file(REAL_PATH ${EXECUTABLE} REAL_EXECUTABLE)
    # file(REAL_PATH ...): 是 CMake 中 file 命令的一个用法，用于获取文件的实际路径。
    # REAL_EXECUTABLE 是 REAL_PATH 模式下的一个参数，表示要获取实际路径的文件，可用于后续使用。
    # 如果 EXECUTABLE 是一个无效的路径，例如：abc，那么 REAL_EXECUTABLE 的值为：${CMAKE_CURRENT_LIST_DIR}/abc。
    # 其中，CMAKE_CURRENT_LIST_DIR 是 CMake 提供的一个内置变量，用于表示当前正在处理的 CMakeLists.txt 文件的完整路径。
    # 其中，CMAKE_CURRENT_LIST_DIR 在 CMake 处理构建脚本时自动设置，不需要用户手动设置；是一个只读变量，用户不能直接修改它的值。 

    # 提前一步手动设置 Python_EXECUTABLE
    set(Python_EXECUTABLE ${REAL_EXECUTABLE})

    find_package(Python COMPONENTS Interpreter Development.Module Development.SABIModule)
    if (NOT Python_FOUND)
        message(FATAL_ERROR "Unable to find python matching: ${EXECUTABLE}.")
    endif()
    # find_package(Python COMPONENTS ...) 是 CMake 中用于查找 Python 相关组件的命令。
    # 通过这个命令，CMake 会尝试找到 Python 解释器、Python 开发库以及特定于 SABI（System ABIs）的模块开发库。
    # 如果找到 Python 相关组件：
    #       自动设置 Python_FOUND 变量为 TRUE。
    message(STATUS "-- find_python_from_executable Python_FOUND<${Python_FOUND}>")
    # 如果查找到 Python Interpreter（解释器）：
    #       自动设置 Python_EXECUTABLE 变量为 Python 解释器的路径
    #       自动设置 Python_VERSION 变量为 Python 解释器的版本号
    #       自动设置 Python_VERSION_MAJOR 变量为 Python 解释器的主版本号
    #       自动设置 Python_VERSION_MINOR 变量为 Python 解释器的次版本号。
    message(STATUS "-- find_python_from_executable Python_EXECUTABLE<${Python_EXECUTABLE}>, Python_VERSION<${Python_VERSION}>")
    message(STATUS "-- find_python_from_executable Python_VERSION_MAJOR<${Python_VERSION_MAJOR}>, Python_VERSION_MINOR<${Python_VERSION_MINOR}>")
    # 如果查找到 Python Development.Module（开发库）：
    #       自动设置 Python_INCLUDE_DIRS 变量为 Python 头文件的路径
    #       自动设置 Python_LIBRARIES 变量为 Python 开发库的库文件路径。
    message(STATUS "-- find_python_from_executable Python_INCLUDE_DIRS<${Python_INCLUDE_DIRS}>, Python_LIBRARIES<${Python_LIBRARIES}>")
    # 如果查找到 Python Development.SABIModule（特定于 SABI 的模块开发库）：
    #       自动设置 Python_SABI_INCLUDE_DIRS 变量为特定于 SABI 的 Python 头文件的路径
    #       自动设置 Python_SABI_LIBRARY 变量为特定于 SABI 的 Python 库的路径。
    message(STATUS "-- find_python_from_executable Python_SABI_INCLUDE_DIRS<${Python_SABI_INCLUDE_DIRS}>, Python_SABI_LIBRARY<${Python_SABI_LIBRARY}>")

    set(_VER "${Python_VERSION_MAJOR}.${Python_VERSION_MINOR}")
    set(_SUPPORTED_VERSIONS_LIST ${SUPPORTED_VERSIONS} ${ARGN})
    # 判断当前 Python 版本是否在指定支持的版本列表中
    if (NOT _VER IN_LIST _SUPPORTED_VERSIONS_LIST)
        message(FATAL_ERROR
            "Python version (${_VER}) is not one of the supported versions: "
            "${_SUPPORTED_VERSIONS_LIST}.")
    endif()

    message(STATUS "Found python matching: ${REAL_EXECUTABLE}.")
endmacro()

#
# Define a target named `GPU_MOD_NAME` for a single extension. The
# arguments are:
#
# DESTINATION <dest>         - Module destination directory.
# LANGUAGE <lang>            - The GPU language for this module, e.g CUDA, HIP,
#                              etc.
# SOURCES <sources>          - List of source files relative to CMakeLists.txt
#                              directory.
#
# Optional arguments:
#
# ARCHITECTURES <arches>     - A list of target GPU architectures in cmake
#                              format.
#                              Refer `CMAKE_CUDA_ARCHITECTURES` documentation
#                              and `CMAKE_HIP_ARCHITECTURES` for more info.
#                              ARCHITECTURES will use cmake's defaults if
#                              not provided.
# COMPILE_FLAGS <flags>      - Extra compiler flags passed to NVCC/hip.
# INCLUDE_DIRECTORIES <dirs> - Extra include directories.
# LIBRARIES <libraries>      - Extra link libraries.
# WITH_SOABI                 - Generate library with python SOABI suffix name.
# USE_SABI <version>         - Use python stable api <version>
#
# Note: optimization level/debug info is set via cmake build type.
#
function (use_cmake_parse_arguments GPU_MOD_NAME)
    cmake_parse_arguments(
        PARSE_ARGV 1
        GPU
        "WITH_SOABI"
        "DESTINATION;LANGUAGE;USE_SABI"
        "SOURCES;ARCHITECTURES;COMPILE_FLAGS;INCLUDE_DIRECTORIES;LIBRARIES")
    # cmake_parse_arguments 是 CMake 中用于解析函数或宏参数的预定义命令。它能够解析函数或宏的参数，并定义一组变量来保存相应选项的值。
    # PARSE_ARGV 1: 表示从第一个参数开始解析。
    # GPU: 这是一个前缀，用于所有解析后的变量。例如，如果解析出一个名为 DESTINATION 的参数，那么生成的变量将是 GPU_DESTINATION。
    # "WITH_SOABI": 这是一个可选的布尔参数。如果提供了这个参数，那么 GPU_WITH_SOABI 将被设置为 TRUE，否则为 FALSE。
    # "DESTINATION;LANGUAGE;USE_SABI": 这些是可选的单值参数。每个参数如果被提供，将生成一个对应的变量，如 GPU_DESTINATION、GPU_LANGUAGE 和 GPU_USE_SABI。
    # "SOURCES;ARCHITECTURES;COMPILE_FLAGS;INCLUDE_DIRECTORIES;LIBRARIES": 这些是可选的多值参数。每个参数如果被提供，将生成一个对应的列表变量，如 GPU_SOURCES、GPU_ARCHITECTURES 等。
    
    message(STATUS "-- use_cmake_parse_arguments: GPU_MOD_NAME<${GPU_MOD_NAME}>")
    message(STATUS "-- use_cmake_parse_arguments: GPU_WITH_SOABI<${GPU_WITH_SOABI}>")
    message(STATUS "-- use_cmake_parse_arguments: GPU_DESTINATION<${GPU_DESTINATION}>")
    message(STATUS "-- use_cmake_parse_arguments: GPU_LANGUAGE<${GPU_LANGUAGE}>")
    message(STATUS "-- use_cmake_parse_arguments: GPU_USE_SABI<${GPU_USE_SABI}>")
    message(STATUS "-- use_cmake_parse_arguments: GPU_SOURCES<${GPU_SOURCES}>")
    message(STATUS "-- use_cmake_parse_arguments: GPU_ARCHITECTURES<${GPU_ARCHITECTURES}>")
    message(STATUS "-- use_cmake_parse_arguments: GPU_COMPILE_FLAGS<${GPU_COMPILE_FLAGS}>")
    message(STATUS "-- use_cmake_parse_arguments: GPU_INCLUDE_DIRECTORIES<${GPU_INCLUDE_DIRECTORIES}>")
    message(STATUS "-- use_cmake_parse_arguments: GPU_LIBRARIES<${GPU_LIBRARIES}>")

    message(STATUS "-- use_cmake_parse_arguments: GPU_UNPARSED_ARGUMENTS<${GPU_UNPARSED_ARGUMENTS}>")
endfunction()
