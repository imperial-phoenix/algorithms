# Требование CMake указывать минимально поддерживаемую версию
cmake_minimum_required(VERSION 3.22)

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

# Проверка доступности pvs-studio
if (WIN32)
   # The registry value is only read when you do some cache operation on it.
   # https://stackoverflow.com/questions/1762201/reading-registry-values-with-cmake
   GET_FILENAME_COMPONENT(ROOT "[HKEY_LOCAL_MACHINE\\SOFTWARE\\WOW6432Node\\ProgramVerificationSystems\\PVS-Studio;installDir]" ABSOLUTE CACHE)

   if (EXISTS "${ROOT}")
      set(PATHS "${ROOT}")
   else()
      set(ROOT "PROGRAMFILES(X86)")
      set(ROOT "$ENV{${ROOT}}/PVS-Studio")
      string(REPLACE \\ / ROOT "${ROOT}")

      if (EXISTS "${ROOT}")
         set(PATHS "${ROOT}")
      else()
         set(ROOT "PATH")
         set(ROOT "$ENV{${ROOT}}")
         set(PATHS "${ROOT}")
      endif()
   endif()

   SET(PVS_STUDIO_BIN "CompilerCommandsAnalyzer.exe")
   SET(PVS_STUDIO_CONVERTER "HtmlGenerator.exe")
else()
   SET(PVS_STUDIO_BIN "pvs-studio-analyzer")
   SET(PVS_STUDIO_CONVERTER "plog-converter")
endif()

find_program(PVS_STUDIO_BIN_PATH "${PVS_STUDIO_BIN}" ${PATHS})
set(PVS_STUDIO_BIN "${PVS_STUDIO_BIN_PATH}")

if (NOT EXISTS "${PVS_STUDIO_BIN}")
   message(FATAL_ERROR "pvs-studio-analyzer is not found")
endif()

find_program(PVS_STUDIO_CONVERTER_PATH "${PVS_STUDIO_CONVERTER}" ${PATHS})
set(PVS_STUDIO_CONVERTER "${PVS_STUDIO_CONVERTER_PATH}")

if (NOT EXISTS "${PVS_STUDIO_CONVERTER}")
   message(FATAL_ERROR "plog-converter is not found")
endif()

if(EXISTS ${PVS_STUDIO_BIN})
   message(STATUS "PVS-Studio found in ${CMAKE_CURRENT_LIST_DIR}/pvs-studio-cmake-module")
   set(IS_PVS_STUDIO_AVAILABLE ON)
else()
   message(STATUS "PVS-Studio not found")
endif()

# Отладочная информация о конфигурации сборки
message(STATUS "* ========================== *")
message(STATUS "| Buid type : ${CMAKE_BUILD_TYPE}")
message(STATUS "| Target OS : ${TARGET_OS}")
message(STATUS "| Generator : ${CMAKE_GENERATOR}")
if (IS_TESTING_AVAILABLE)
   message(STATUS "| Testing   : Available")
else()
   message(STATUS "| Testing   : Not Available")
endif()
if(IS_PVS_STUDIO_AVAILABLE)
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
if(IS_PVS_STUDIO_AVAILABLE)
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