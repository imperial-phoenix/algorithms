# Требование CMake указывать минимально поддерживаемую версию
cmake_minimum_required(VERSION 3.22)

# Объявление проекта
project(algorithms C CXX)

# Подключение внутреннего модуля с вспомогательными функциями
include(internal.cmake)

# Проверка доступности googletest
is_googletest_available()

if(IS_GOOGLETEST_FOUND)
   enable_testing()
endif()

# Проверка доступности pvs-studio
is_pvs_studio_available()

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
set(OUTPUT_DEBUG_DIR "${CMAKE_CURRENT_LIST_DIR}/Output/Debug")
set(OUTPUT_RELEASE_DIR "${CMAKE_CURRENT_LIST_DIR}/Output/Release")

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${OUTPUT_DEBUG_DIR}/Lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${OUTPUT_DEBUG_DIR}/Lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${OUTPUT_DEBUG_DIR}/Bin)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${OUTPUT_RELEASE_DIR}/Lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${OUTPUT_RELEASE_DIR}/Lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${OUTPUT_RELEASE_DIR}/Bin)

# Общие заголовочные файлы
set(SHARED_INCLUDE_DIR ${CMAKE_CURRENT_LIST_DIR})

# Подключаем проекты
set(TARGET_LIST)

#add_subdirectory(Algorithms)
add_subdirectory(DataStructures)

# Подключаем статический анализатор pvs-studio
if(IS_PVS_STUDIO_FOUND)
   include(pvs-studio-cmake-module/PVS-Studio.cmake)

   add_custom_target(
      RmPvsLog
      COMMAND ${CMAKE_COMMAND} -E rm -r -f ${CMAKE_CURRENT_LIST_DIR}/Output/PvsStudioLog)

   pvs_studio_add_target(TARGET Pvs ALL
                         FORMAT fullhtml
                         ANALYZE ${TARGET_LIST}
                         MODE GA:1,2
                         LOG ${CMAKE_CURRENT_LIST_DIR}/Output/PvsStudioLog)

   add_dependencies(Pvs RmPvsLog)
endif()