cmake_minimum_required(VERSION 2.8.11)
project(iclcv_catkin)

find_package(catkin_simple REQUIRED)
catkin_simple()

include(ExternalProject)
find_package(Qt5Core)
if (NOT Qt5Core_FOUND AND APPLE)
  message(STATUS "Qt5Core not found and system is apple, trying default OSX "
                 "QT5_ROOT path: /usr/local/opt/qt5.")
  set(QT5_ROOT "-DQT_ROOT=/usr/local/opt/qt5 ")
endif()

ExternalProject_Add(iclcv_src
                    GIT_REPOSITORY https://github.com/ethz-asl/iclcv
                    UPDATE_COMMAND ""
                  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${CATKIN_DEVEL_PREFIX} ${QT5_ROOT} -DBUILD_WITH_QT=ON -DBUILD_WITH_PCL=ON -DBUILD_WITH_OPENGL=ON -DBUILD_WITH_OPENCV=ON -DINSTALL_PATH_PREFIX= -DCMAKE_BUILD_TYPE:STRING=Release)

cs_add_library(${PROJECT_NAME} src/dependency_tracker.cc)
add_dependencies(${PROJECT_NAME} iclcv_src)
target_link_libraries(${PROJECT_NAME} ${CATKIN_DEVEL_PREFIX}/lib/libICLCV${CMAKE_SHARED_LIBRARY_SUFFIX})

cs_install()

cs_export(INCLUDE_DIRS ${CATKIN_DEVEL_PREFIX}/include
          CFG_EXTRAS iclcv.cmake)
