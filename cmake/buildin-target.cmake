
set(GPU_MOD_NAME "_core_C")
set(GPU_LANGUAGE "CUDA")
set(GPU_COMPILE_FLAGS "")
set(GPU_INCLUDE_DIRECTORIES "")
set(GPU_LIBRARIES "")

message(STATUS "----------------------------------------------target_compile_options(...)----------------------------------------------------------------------")
target_compile_options(
    ${GPU_MOD_NAME} PRIVATE 
    $<$<COMPILE_LANGUAGE:${GPU_LANGUAGE}>:${GPU_COMPILE_FLAGS}>)
# 这段代码为 ${{GPU_MOD_NAME}} 目标设置了编译选项。
# $<COMPILE_LANGUAGE:${GPU_LANGUAGE}> 是一个条件表达式，只有在编译语言为 ${GPU_LANGUAGE} 时，才会应用 ${GPU_COMPILE_FLAGS} 指定的编译选项。
message(STATUS "----------------------------------------------target_compile_options(...)----------------------------------------------------------------------\n")

message(STATUS "----------------------------------------------target_compile_definitions(...)----------------------------------------------------------------------")
target_compile_definitions(
    ${GPU_MOD_NAME} PRIVATE 
    "-DTORCH_EXTENSION_NAME=${GPU_MOD_NAME}")
# 这段代码为 ${GPU_MOD_NAME} 目标添加了一个编译定义 -DTORCH_EXTENSION_NAME=${GPU_MOD_NAME}。
# 这意味着在编译过程中，预处理器将定义一个名为 TORCH_EXTENSION_NAME 的宏，其值为 ${GPU_MOD_NAME}。
message(STATUS "----------------------------------------------target_compile_definitions(...)----------------------------------------------------------------------\n")

message(STATUS "----------------------------------------------target_include_directories(...)----------------------------------------------------------------------")
target_include_directories(
    ${GPU_MOD_NAME} 
    PRIVATE csrc ${GPU_INCLUDE_DIRECTORIES})
# 这段代码为 ${GPU_MOD_NAME} 目标设置了包含目录。
# csrc 是一个固定的包含目录，而 ${GPU_INCLUDE_DIRECTORIES} 是一个变量，可能包含额外的包含目录。
# 这些目录将被添加到编译器的包含路径中。
message(STATUS "----------------------------------------------target_include_directories(...)----------------------------------------------------------------------\n")

message(STATUS "----------------------------------------------target_link_libraries(...)----------------------------------------------------------------------")
target_link_libraries(
    ${GPU_MOD_NAME}
    PRIVATE torch ${GPU_LIBRARIES}) 
# 这段代码为 ${GPU_MOD_NAME} 目标设置了链接库。
# torch 是一个固定的库，而 ${GPU_LIBRARIES} 是一个变量，可能包含额外的库。
# 这些库将在链接阶段被链接到目标中。
message(STATUS "----------------------------------------------target_link_libraries(...)----------------------------------------------------------------------\n")
