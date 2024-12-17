
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
# Parse cmake function arguments
# 
function (use_cmake_parse_arguments PREFIX_MOD_NAME)
    cmake_parse_arguments(
        PARSE_ARGV 1
        PREFIX
        "WITH_SOABI"
        "DESTINATION;LANGUAGE;USE_SABI"
        "SOURCES;ARCHITECTURES;COMPILE_FLAGS;INCLUDE_DIRECTORIES;LIBRARIES")
    # cmake_parse_arguments 是 CMake 中用于解析函数或宏参数的预定义命令。它能够解析函数或宏的参数，并定义一组变量来保存相应选项的值。
    # PARSE_ARGV 1: 表示从第一个参数开始解析。
    # PREFIX: 这是一个前缀，用于所有解析后的变量。例如，如果解析出一个名为 DESTINATION 的参数，那么生成的变量将是 PREFIX_DESTINATION。
    # "WITH_SOABI": 这是一个可选的布尔参数。如果提供了这个参数，那么 PREFIX_WITH_SOABI 将被设置为 TRUE，否则为 FALSE。
    # "DESTINATION;LANGUAGE;USE_SABI": 这些是可选的单值参数。每个参数如果被提供，将生成一个对应的变量，如 PREFIX_DESTINATION、PREFIX_LANGUAGE 和 PREFIX_USE_SABI。
    # "SOURCES;ARCHITECTURES;COMPILE_FLAGS;INCLUDE_DIRECTORIES;LIBRARIES": 这些是可选的多值参数。每个参数如果被提供，将生成一个对应的列表变量，如 PREFIX_SOURCES、PREFIX_ARCHITECTURES 等。
    
    message(STATUS "-- use_cmake_parse_arguments: PREFIX_MOD_NAME<${PREFIX_MOD_NAME}>")
    message(STATUS "-- use_cmake_parse_arguments: PREFIX_WITH_SOABI<${PREFIX_WITH_SOABI}>")
    message(STATUS "-- use_cmake_parse_arguments: PREFIX_DESTINATION<${PREFIX_DESTINATION}>")
    message(STATUS "-- use_cmake_parse_arguments: PREFIX_LANGUAGE<${PREFIX_LANGUAGE}>")
    message(STATUS "-- use_cmake_parse_arguments: PREFIX_USE_SABI<${PREFIX_USE_SABI}>")
    message(STATUS "-- use_cmake_parse_arguments: PREFIX_SOURCES<${PREFIX_SOURCES}>")
    message(STATUS "-- use_cmake_parse_arguments: PREFIX_ARCHITECTURES<${PREFIX_ARCHITECTURES}>")
    message(STATUS "-- use_cmake_parse_arguments: PREFIX_COMPILE_FLAGS<${PREFIX_COMPILE_FLAGS}>")
    message(STATUS "-- use_cmake_parse_arguments: PREFIX_INCLUDE_DIRECTORIES<${PREFIX_INCLUDE_DIRECTORIES}>")
    message(STATUS "-- use_cmake_parse_arguments: PREFIX_LIBRARIES<${PREFIX_LIBRARIES}>")

    message(STATUS "-- use_cmake_parse_arguments: PREFIX_UNPARSED_ARGUMENTS<${PREFIX_UNPARSED_ARGUMENTS}>")
endfunction()

function (run_python PYTHON_SCRIPT OUT)
    execute_process(
        COMMAND
        "${Python_EXECUTABLE}" "-c" "${PYTHON_SCRIPT}"
        OUTPUT_VARIABLE PYTHON_OUT
        RESULT_VARIABLE PYTHON_ERROR_CODE
        ERROR_VARIABLE PYTHON_STDERR
        OUTPUT_STRIP_TRAILING_WHITESPACE)
    set(${OUT} ${PYTHON_OUT} PARENT_SCOPE)
endfunction()

#
# For a specific file set the `-gencode` flag in compile options conditionally 
# for the CUDA language. 
#
# Example:
#   set_gencode_flag_for_srcs(
#     SRCS "foo.cu"
#     ARCH "compute_75"
#     CODE "sm_75")
#   adds: "-gencode arch=compute_75,code=sm_75" to the compile options for 
#    `foo.cu` (only for the CUDA language).
#
macro(set_gencode_flag_for_srcs)
    set(options)
    # options: 定义了一个空列表，表示没有布尔选项。

    set(oneValueArgs ARCH CODE)
    # oneValueArgs: 定义了两个单值参数ARCH和CODE，这些参数在调用时需要提供一个值。

    set(multiValueArgs SRCS)
    # multiValueArgs: 定义了一个多值参数SRCS，表示可以传入多个源文件。

    cmake_parse_arguments(arg "${options}" "${oneValueArgs}"
                            "${multiValueArgs}" ${ARGN} )
    # cmake_parse_arguments: 这是一个CMake函数，用于解析传入的参数。解析后的结果存储在arg变量中。

    set(_FLAG -gencode arch=${arg_ARCH},code=${arg_CODE})
    # _FLAG: 根据解析后的ARCH和CODE参数生成一个编译选项字符串。这个字符串将被用于CUDA编译。

    set_property(
        SOURCE ${arg_SRCS}
        APPEND PROPERTY
        COMPILE_OPTIONS "$<$<COMPILE_LANGUAGE:CUDA>:${_FLAG}>"
    )
    # set_property: 用于设置源文件的属性。
    # SOURCE ${arg_SRCS}: 指定要设置属性的源文件列表。
    # APPEND PROPERTY: 表示将属性追加到现有属性中。
    # COMPILE_OPTIONS: 指定要设置的属性为编译选项。
    # "$<$<COMPILE_LANGUAGE:CUDA>:${_FLAG}>: 这是一个条件表达式，表示只有在编译语言为CUDA时，才应用_FLAG编译选项。

    message(STATUS "-- Setting gencode flag for ${arg_SRCS}: ${_FLAG}")
endmacro(set_gencode_flag_for_srcs)

#
# Define a target named `TORCH_MOD_NAME` for a single extension. The
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
function (define_torch_extension_target TORCH_MOD_NAME)
  cmake_parse_arguments(PARSE_ARGV 1
    TORCH
    "WITH_SOABI"
    "DESTINATION;LANGUAGE;USE_SABI"
    "SOURCES;ARCHITECTURES;COMPILE_FLAGS;INCLUDE_DIRECTORIES;LIBRARIES")

  # Add hipify preprocessing step when building with HIP/ROCm.
  if (TORCH_LANGUAGE STREQUAL "HIP")
    hipify_sources_target(TORCH_SOURCES ${TORCH_MOD_NAME} "${TORCH_SOURCES}")
  endif()

  if (TORCH_WITH_SOABI)
    set(TORCH_WITH_SOABI WITH_SOABI)
  else()
    set(TORCH_WITH_SOABI)
  endif()

  if (TORCH_USE_SABI)
    Python_add_library(${TORCH_MOD_NAME} MODULE USE_SABI ${TORCH_USE_SABI} ${TORCH_WITH_SOABI} "${TORCH_SOURCES}")
  else()
    Python_add_library(${TORCH_MOD_NAME} MODULE ${TORCH_WITH_SOABI} "${TORCH_SOURCES}")
  endif()

  if (TORCH_LANGUAGE STREQUAL "HIP")
    # Make this target dependent on the hipify preprocessor step.
    add_dependencies(${TORCH_MOD_NAME} hipify${TORCH_MOD_NAME})
  endif()

  if (TORCH_ARCHITECTURES)
    set_target_properties(${TORCH_MOD_NAME} PROPERTIES
      ${TORCH_LANGUAGE}_ARCHITECTURES "${TORCH_ARCHITECTURES}")
  endif()

  set_property(TARGET ${TORCH_MOD_NAME} PROPERTY CXX_STANDARD 17)

  target_compile_options(${TORCH_MOD_NAME} PRIVATE
    $<$<COMPILE_LANGUAGE:${TORCH_LANGUAGE}>:${TORCH_COMPILE_FLAGS}>)

  target_compile_definitions(${TORCH_MOD_NAME} PRIVATE
    "-DTORCH_EXTENSION_NAME=${TORCH_MOD_NAME}")

  target_include_directories(${TORCH_MOD_NAME} PRIVATE csrc
    ${TORCH_INCLUDE_DIRECTORIES})

  target_link_libraries(${TORCH_MOD_NAME} PRIVATE torch ${TORCH_LIBRARIES})

  # Don't use `TORCH_LIBRARIES` for CUDA since it pulls in a bunch of
  # dependencies that are not necessary and may not be installed.
  if (TORCH_LANGUAGE STREQUAL "CUDA")
    if ("${CUDA_CUDA_LIB}" STREQUAL "")
      set(CUDA_CUDA_LIB "${CUDA_CUDA_LIBRARY}")
    endif()
    target_link_libraries(${TORCH_MOD_NAME} PRIVATE ${CUDA_CUDA_LIB}
      ${CUDA_LIBRARIES})
  else()
    target_link_libraries(${TORCH_MOD_NAME} PRIVATE ${TORCH_LIBRARIES})
  endif()

  install(TARGETS ${TORCH_MOD_NAME} LIBRARY DESTINATION ${TORCH_DESTINATION} COMPONENT ${TORCH_MOD_NAME})
endfunction()

macro (find_python_from_executable EXECUTABLE SUPPORTED_VERSIONS)
  file(REAL_PATH ${EXECUTABLE} EXECUTABLE)
  set(Python_EXECUTABLE ${EXECUTABLE})
  find_package(Python COMPONENTS Interpreter Development.Module Development.SABIModule)
  if (NOT Python_FOUND)
    message(FATAL_ERROR "Unable to find python matching: ${EXECUTABLE}.")
  endif()
  set(_VER "${Python_VERSION_MAJOR}.${Python_VERSION_MINOR}")
  set(_SUPPORTED_VERSIONS_LIST ${SUPPORTED_VERSIONS} ${ARGN})
  if (NOT _VER IN_LIST _SUPPORTED_VERSIONS_LIST)
    message(FATAL_ERROR
      "Python version (${_VER}) is not one of the supported versions: "
      "${_SUPPORTED_VERSIONS_LIST}.")
  endif()
  message(STATUS "Found python matching: ${EXECUTABLE}.")
endmacro()
