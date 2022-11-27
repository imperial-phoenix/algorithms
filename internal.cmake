cmake_minimum_required(VERSION 3.22)

# Функция проверки доступности pvs-studio
# PATH_TO_SUBMODULES[IN] - директория с сабмодулями
# IS_PVS_STUDIO_FOUND[OUT] - статус доступности PVS-Studio
function(is_pvs_studio_available PATH_TO_SUBMODULES)
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

   if (IS_PVS_STUDIO_FOUND AND EXISTS ${PATH_TO_SUBMODULES}/pvs-studio-cmake-module/PVS-Studio.cmake)
      message(STATUS "pvs-studio-cmake-module is found in ${PATH_TO_SUBMODULES}")
      set(IS_PVS_STUDIO_FOUND ON PARENT_SCOPE)
   else()
      message(STATUS "pvs-studio-cmake-module is not found in ${PATH_TO_SUBMODULES}")
      set(IS_PVS_STUDIO_FOUND OFF PARENT_SCOPE)
   endif()

endfunction()

# Функция проверки доступности googletest
# PATH_TO_SUBMODULES[IN] - директория с сабмодулями
# IS_GOOGLETEST_FOUND[OUT] - статус доступности googletest
# GTEST_INCLUDE_DIR[OUT] - директории заголовочных файлов googletest
function(is_googletest_available PATH_TO_SUBMODULES)
   if(EXISTS ${PATH_TO_SUBMODULES}/googletest/googletest/CMakeLists.txt)
      message(STATUS "googletest is found in ${PATH_TO_SUBMODULES}")
      add_subdirectory(${PATH_TO_SUBMODULES}/googletest)
      set(GTEST_INCLUDE_DIR "${PATH_TO_SUBMODULES}/googletest/googletest/include" PARENT_SCOPE)
      set(IS_GOOGLETEST_FOUND ON PARENT_SCOPE)
   else()
      message(STATUS "googletest is not found in ${PATH_TO_SUBMODULES}")
      set(IS_GOOGLETEST_FOUND OFF PARENT_SCOPE)
   endif()
endfunction()