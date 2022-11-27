# Требование CMake указывать минимально поддерживаемую версию
cmake_minimum_required(VERSION 3.22)

# Объявление проекта
project(algorithms C CXX)

# Подключение внутреннего модуля с вспомогательными функциями
include(internal.cmake)

# Проверка доступности googletest
is_googletest_available(${CMAKE_CURRENT_LIST_DIR}/Modules)

if(IS_GOOGLETEST_FOUND)
   enable_testing()
endif()

# Проверка доступности pvs-studio
is_pvs_studio_available(${CMAKE_CURRENT_LIST_DIR}/Modules)

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
message(STATUS "| Buid type : ${CMAKE_BUILD_TYPE}")
message(STATUS "| Target OS : ${TARGET_OS}")
message(STATUS "| Generator : ${CMAKE_GENERATOR}")
if (IS_GOOGLETEST_FOUND)
   message(STATUS "| Testing   : Available")
else()
   message(STATUS "| Testing   : Not Available")
endif()
if(IS_PVS_STUDIO_FOUND)
   message(STATUS "| PVS-Studio: Available")
else()
   message(STATUS "| PVS-Studio: Not Available")
endif()
message(STATUS "* ========================== *")

# Выходные директории
set(PROJECT_PATH ${CMAKE_CURRENT_LIST_DIR})

set(OUTPUT_DEBUG_DIR "${PROJECT_PATH}/Output/Debug")
set(OUTPUT_RELEASE_DIR "${PROJECT_PATH}/Output/Release")

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${OUTPUT_DEBUG_DIR}/Lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${OUTPUT_DEBUG_DIR}/Lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${OUTPUT_DEBUG_DIR}/Bin)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${OUTPUT_RELEASE_DIR}/Lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${OUTPUT_RELEASE_DIR}/Lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${OUTPUT_RELEASE_DIR}/Bin)

# Подключаем проекты
add_subdirectory(Src)