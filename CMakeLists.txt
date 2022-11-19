# Требование CMake указывать минимально поддерживаемую версию
cmake_minimum_required(VERSION 3.5)

# Объявление проекта
project(algorithms C)

# Тип сборки по умолчанию
if (NOT CMAKE_BUILD_TYPE)
   set(CMAKE_BUILD_TYPE "Debug")
endif()

# OS по умолчанию
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
message(STATUS "* ========================== *")

# Выходные директории
set(OUTPUT_DEBUG_DIR "${CMAKE_CURRENT_LIST_DIR}/output/debug")
set(OUTPUT_RELEASE_DIR "${CMAKE_CURRENT_LIST_DIR}/output/release")

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${OUTPUT_DEBUG_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${OUTPUT_DEBUG_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${OUTPUT_DEBUG_DIR}/bin)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${OUTPUT_RELEASE_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${OUTPUT_RELEASE_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${OUTPUT_RELEASE_DIR}/bin)

# Подключаем проекты
#add_subdirectory(algorithms)
#add_subdirectory(data_structures)
#add_subdirectory(tests)