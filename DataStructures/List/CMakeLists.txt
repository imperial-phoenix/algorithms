# Объявляем имя проекта
set(TARGET_NAME "List")

# Собираем заголовочные файлы
set(HEADERS_LIST)

# Собираем исходные файлы
set(SOURCES_LIST
   ${CMAKE_CURRENT_LIST_DIR}/List.c)

# Сборка библиотеки
add_library(${TARGET_NAME} ${HEADERS_LIST} ${SOURCES_LIST})
target_include_directories(${TARGET_NAME} PUBLIC ${SHARED_INCLUDE})

# Флаги для gcc
if (TARGET_OS STREQUAL "Linux")
   target_compile_options(${TARGET_NAME} PRIVATE "-Werror" "-pedantic-errors" "-Wall" "-Wextra" "-Wpedantic")
endif()

# Добавляем тесты
if(IS_TESTING_AVAILABLE)
   add_executable(${TARGET_NAME}Tests ListTests.cpp)
   target_include_directories(${TARGET_NAME}Tests PRIVATE ${SHARED_INCLUDE})
   target_link_libraries(${TARGET_NAME}Tests PRIVATE gtest gtest_main ${TARGET_NAME})
   add_test(NAME List_tests WORKING_DIRECTORY ${OUTPUT_DEBUG_DIR}/bin COMMAND ${TARGET_NAME}Tests)
endif()