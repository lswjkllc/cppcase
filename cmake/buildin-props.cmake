
message(STATUS "----------------------------------------------set_target_properties(... PROPERTIES ...)----------------------------------------------------------------------")
# set_target_properties(${TARGET_NAME} PROPERTIES ${PROP_NAME} "${PROP_VALUE}") 
# set_target_properties 用于设置或修改目标的属性。在这个特定的代码片段中，它被用来设置一个目标的特定语言架构属性。
# PROPERTIES 是 set_target_properties 命令的关键字，表示接下来的参数是目标的属性。
# 假设 TARGET_NAME 是 my_gpu_module，PROP_NAME 是 CUDA_ARCHITECTURES，PROP_VALUE 是 "sm_35;sm_50"，那么这条命令将设置 my_gpu_module 的 CUDA 架构属性为 sm_35 和 sm_50。
message(STATUS "----------------------------------------------set_target_properties(... PROPERTIES ...)----------------------------------------------------------------------\n")


message(STATUS "----------------------------------------------set_property(TARGET ...)----------------------------------------------------------------------")
# set_property(TARGET ${TARGET_NAME} PROPERTY ${PROP_NAME} "${PROP_VALUE}")
# set_property(TARGET ...) 用于设置目标（如库或可执行文件）的属性。
# 假设 TARGET_NAME 是 my_gpu_module，PROP_NAME 是 CXX_STANDARD，PROP_VALUE 是 "17"，那么这条命令的作用是设置一个名为 ${TARGET_NAME} 的目标的 C++ 标准为 C++17
message(STATUS "----------------------------------------------set_property(TARGET ...)----------------------------------------------------------------------\n")
