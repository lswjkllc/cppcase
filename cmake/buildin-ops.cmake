
message(STATUS "----------------------------------------------STREQUAL and EQUAL----------------------------------------------------------------------")
if("string1" STREQUAL "string2")
    message("The strings are equal!")
else()
    message("The strings are not equal!")
endif()
# STREQUAL 用于比较字符串是否相等。
# 如果两个字符串完全相同，则返回 true；否则返回 false。

if(5 EQUAL 5)
    message("The numbers are equal!")
else()
    message("The numbers are not equal!")
endif()
# EQUAL 用于比较两个数值是否相等。
# 如果两个数值相等，则返回 true；否则返回 false。
message(STATUS "----------------------------------------------STREQUAL and EQUAL----------------------------------------------------------------------\n")
