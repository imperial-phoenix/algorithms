# Требование CMake указывать минимально поддерживаемую версию
cmake_minimum_required(VERSION 3.5)

# Объявление проекта
project(algorithms C CXX)

# Проверка доступности тестирования
if(EXISTS ${CMAKE_CURRENT_LIST_DIR}/googletest)
   message(STATUS "googletest found in ${CMAKE_CURRENT_LIST_DIR}")
   enable_testing()
   add_subdirectory(googletest)
   set(IS_TESTING_AVAILABLE ON)
   set(GTEST_INCLUDE "${CMAKE_CURRENT_LIST_DIR}/googletest/googletest/include")
else()
   message(STATUS "googletest not found in ${CMAKE_CURRENT_LIST_DIR}")
   set(IS_TESTING_AVAILABLE OFF)
endif()

# Тип сборки по умолчанию
if (NOT CMAKE_BUILD_TYPE)
   set(CMAKE_BUILD_TYPE "Debug")
endif()

# Определяем OS
if (WIN32)
   set(TARGET_OS "Windows")
elseif(UNIX)
   set(TARGET_OS "Linux")
endif()

# Отладочная информация о конфигурации сборки
message(STATUS "* ========================== *")
message(STATUS "| Buid type: ${CMAKE_BUILD_TYPE}")
message(STATUS "| Target OS: ${TARGET_OS}")
message(STATUS "| Generator: ${CMAKE_GENERATOR}")
if (IS_TESTING_AVAILABLE)
   message(STATUS "| Testing  : Available")
else()
   message(STATUS "| Testing  : Not Available")
endif()
message(STATUS "* ========================== *")

# Выходные директории
set(OUTPUT_DEBUG_DIR "${CMAKE_CURRENT_LIST_DIR}/Output/Debug")
set(OUTPUT_RELEASE_DIR "${CMAKE_CURRENT_LIST_DIR}/Output/Release")

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${OUTPUT_DEBUG_DIR}/Lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${OUTPUT_DEBUG_DIR}/Lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${OUTPUT_DEBUG_DIR}/Bin)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${OUTPUT_RELEASE_DIR}/Lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${OUTPUT_RELEASE_DIR}/Lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${OUTPUT_RELEASE_DIR}/Bin)

# Общие заголовочные файлы
set(SHARED_INCLUDE ${CMAKE_CURRENT_LIST_DIR})

# Подключаем проекты
#add_subdirectory(Algorithms)
#add_subdirectory(DataStructures)