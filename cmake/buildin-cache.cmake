
message(STATUS "----------------------------------------------CACHE----------------------------------------------------------------------")
message(STATUS "-- set before check TEMP_VERSION: ${TEMP_VERSION}")
message(STATUS "-- set before check TEMP_VERSION: $CACHE{TEMP_VERSION}")
if (NOT DEFINED TEMP_VERSION)
    set(TEMP_VERSION "3.5.1")
endif()
message(STATUS "-- set after  check TEMP_VERSION: ${TEMP_VERSION}")
message(STATUS "-- set after  check TEMP_VERSION: $CACHE{TEMP_VERSION}")
# set 不使用缓存：
#       作用域：变量仅在当前作用域内有效。例如，如果在函数内设置了一个变量，那么这个变量仅在该函数内可见。
#       持久性：变量的值仅在当前 CMake 运行期间有效。一旦 CMake 运行结束，变量的值就会丢失。

message(STATUS "-- set before check TEMP_CACHE_VERSION: ${TEMP_CACHE_VERSION}")
message(STATUS "-- set before check TEMP_CACHE_VERSION: $CACHE{TEMP_CACHE_VERSION}")
if (NOT DEFINED CACHE{TEMP_CACHE_VERSION})
    set(TEMP_CACHE_VERSION "3.5.1" CACHE STRING "temp version")
endif()
message(STATUS "-- set after  check TEMP_CACHE_VERSION: ${TEMP_CACHE_VERSION}")
message(STATUS "-- set after  check TEMP_CACHE_VERSION: $CACHE{TEMP_CACHE_VERSION}")
# set 使用缓存：
#       作用域：变量被存储在 CMake 缓存中，这意味着变量在整个 CMake 运行过程中都是可见的，甚至在多次运行 CMake 时也会保留其值。
#       持久性：变量的值会在 CMake 缓存文件（通常是 CMakeCache.txt ）中保存，因此在后续的 CMake 运行中，这些变量会直接使用缓存值。这使得变量在不同 CMake 运行之间具有持久性。
message(STATUS "----------------------------------------------CACHE----------------------------------------------------------------------\n")