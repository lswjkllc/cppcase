
message(STATUS "----------------------------------------------STREQUAL and EQUAL and VERSION_EQUAL----------------------------------------------------------------------")
if("string1" STREQUAL "string2")
    message("The string are equal!")
else()
    message("The string are not equal!")
endif()
# STREQUAL 用于比较字符串是否相等。
# 如果两个字符串完全相同，则返回 true；否则返回 false。

if(5 EQUAL 5)
    message("The number are equal!")
else()
    message("The number are not equal!")
endif()
# EQUAL 用于比较两个数值是否相等。
# 如果两个数值相等，则返回 true；否则返回 false。

# VERSION_EQUAL
if("3.11" VERSION_EQUAL "3.10")
    message("The version are equal!")
else()
    message("The version are not equal!")
endif()
message(STATUS "----------------------------------------------STREQUAL and EQUAL and VERSION_EQUAL----------------------------------------------------------------------\n")
