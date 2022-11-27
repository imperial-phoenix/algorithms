# Общие заголовочные файлы
set(SHARED_INCLUDE_DIR ${CMAKE_CURRENT_LIST_DIR})

# Подключаем проекты
set(TARGET_LIST)

add_subdirectory(Algorithms)
add_subdirectory(DataStructures)

# Подключаем статический анализатор pvs-studio
if(IS_PVS_STUDIO_FOUND)
   include(../pvs-studio-cmake-module/PVS-Studio.cmake)

   add_custom_target(
      RmPvsLog
      COMMAND ${CMAKE_COMMAND} -E rm -r -f ${PROJECT_PATH}/Output/PvsStudioLog)

   pvs_studio_add_target(TARGET Pvs ALL
                         FORMAT fullhtml
                         ANALYZE ${TARGET_LIST}
                         MODE GA:1,2
                         LOG ${PROJECT_PATH}/Output/PvsStudioLog)

   add_dependencies(Pvs RmPvsLog)
endif()