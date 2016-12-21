cmake_minimum_required(VERSION 2.8.11)
project(iclcv_catkin)

find_package(catkin_simple REQUIRED)
catkin_simple()

set(ICLCV_CATKIN_INCLUDE ${CATKIN_DEVEL_PREFIX}/include)
file(MAKE_DIRECTORY ${ICLCV_CATKIN_INCLUDE})

include(ExternalProject)
find_package(Qt5Core QUIET)
if (NOT Qt5Core_FOUND AND APPLE)
  message(STATUS "Qt5Core not found and system is apple, trying default OSX "
                 "QT5_ROOT path: /usr/local/opt/qt5.")
  set(QT5_ROOT "-DQT_ROOT=/usr/local/opt/qt5 ")
  set(BUILD_WITH_QT "ON")
elseif (NOT Qt5Core_FOUND AND NOT APPLE)
  message(STATUS "QT5 not found, building without QT.")
  set(BUILD_WITH_QT "OFF")
else()
  set(BUILD_WITH_QT "ON")
endif()

ExternalProject_Add(iclcv_src
                    GIT_REPOSITORY https://github.com/ethz-asl/iclcv
                    UPDATE_COMMAND ""
                    BUILD_COMMAND "$(MAKE)" "-$(MAKEFLAGS)"
                    CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX:PATH=${CATKIN_DEVEL_PREFIX} ${QT5_ROOT} -DBUILD_WITH_QT=${BUILD_WITH_QT} -DBUILD_WITH_PCL=ON -DBUILD_WITH_OPENGL=ON -DBUILD_WITH_OPENCV=ON -DCMAKE_BUILD_TYPE:STRING=Release"
                    INSTALL_COMMAND
                         ${CMAKE_CURRENT_SOURCE_DIR}/scripts/install.sh
                              ${CMAKE_CURRENT_BINARY_DIR}/iclcv_src-prefix/src/iclcv_src/ICL*/src/ ${CMAKE_CURRENT_BINARY_DIR}/iclcv_src-prefix/src/iclcv_src-build/src/
                              ${ICLCV_CATKIN_INCLUDE})

cs_add_library(${PROJECT_NAME} src/dependency_tracker.cc)

add_dependencies(${PROJECT_NAME} iclcv_src)
include_directories(${ICLCV_CATKIN_INCLUDE})
cs_install()

cs_export(INCLUDE_DIRS ${CATKIN_DEVEL_PREFIX}/include
          CFG_EXTRAS iclcv.cmake)
