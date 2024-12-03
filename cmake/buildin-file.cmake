
message(STATUS "----------------------------------------------file(MAKE_DIRECTORY ...)----------------------------------------------------------------------")
file(MAKE_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/.deps")
# 使用 file 命令的 MAKE_DIRECTORY 选项来创建一个目录。
message(STATUS "----------------------------------------------file(MAKE_DIRECTORY ...)----------------------------------------------------------------------\n")


message(STATUS "----------------------------------------------file(MD5 ...)----------------------------------------------------------------------")
file(MD5 "${CMAKE_CURRENT_LIST_DIR}/../hello.cc" MD5_OUTPUT)
# 计算文件的 MD5 哈希值。通常用于确保文件内容的完整性，或者在构建过程中检查文件是否发生了变化。
message(STATUS "-- hello.cc MD5: ${MD5_OUTPUT}")
message(STATUS "----------------------------------------------file(MD5 ...)----------------------------------------------------------------------\n")