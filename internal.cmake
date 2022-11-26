cmake_minimum_required(VERSION 3.22)

# Функция проверки доступности pvs-studio
# IS_PVS_STUDIO_FOUND - статус доступности PVS-Studio
function(is_pvs_studio_available)
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

   # Изначально полагаем, что pvs-studio установлена на компьютере
   set(IS_PVS_STUDIO_FOUND ON)

   find_program(PVS_STUDIO_BIN_PATH "${PVS_STUDIO_BIN}" ${PATHS})
   set(PVS_STUDIO_BIN "${PVS_STUDIO_BIN_PATH}")

   if (NOT EXISTS "${PVS_STUDIO_BIN}")
      message("pvs-studio-analyzer is not found")
      set(IS_PVS_STUDIO_FOUND OFF)
   else()
      message(STATUS "pvs-studio-analyzer is found in ${PVS_STUDIO_BIN}")
      set(IS_PVS_STUDIO_FOUND ON)
   endif()

   find_program(PVS_STUDIO_CONVERTER_PATH "${PVS_STUDIO_CONVERTER}" ${PATHS})
   set(PVS_STUDIO_CONVERTER "${PVS_STUDIO_CONVERTER_PATH}")

   if (NOT EXISTS "${PVS_STUDIO_CONVERTER}")
      message("plog-converter is not found")
      set(IS_PVS_STUDIO_FOUND OFF)
   else()
      message(STATUS "plog-converter is found in ${PVS_STUDIO_CONVERTER}")
      set(IS_PVS_STUDIO_FOUND ON)
   endif()

   if (IS_PVS_STUDIO_FOUND AND EXISTS ${CMAKE_CURRENT_LIST_DIR}/pvs-studio-cmake-module)
      message(STATUS "pvs-studio-cmake-module is found in ${CMAKE_CURRENT_LIST_DIR}")
      set(IS_PVS_STUDIO_FOUND ON PARENT_SCOPE)
   else()
      set(IS_PVS_STUDIO_FOUND OFF PARENT_SCOPE)
   endif()

endfunction()

# Функция проверки доступности googletest
# IS_GOOGLETEST_FOUND - статус доступности googletest
# GTEST_INCLUDE_DIR - директории заголовочных файлов googletest
function(is_googletest_available)
   if(EXISTS ${CMAKE_CURRENT_LIST_DIR}/googletest)
      message(STATUS "googletest is found in ${CMAKE_CURRENT_LIST_DIR}")
      add_subdirectory(googletest)
      set(GTEST_INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/googletest/googletest/include" PARENT_SCOPE)
      set(IS_GOOGLETEST_FOUND ON PARENT_SCOPE)
   else()
      message(STATUS "googletest is not found in ${CMAKE_CURRENT_LIST_DIR}")
      set(IS_GOOGLETEST_FOUND OFF PARENT_SCOPE)
   endif()
endfunction()