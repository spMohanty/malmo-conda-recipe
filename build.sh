#!/bin/bash

INCLUDE_PATH=$PREFIX/include
LIBRARY_PATH=$PREFIX/lib

echo "Source DIR : ${SRC_DIR}"
echo "PREFIX : ${PREFIX}"
echo "RECIPE DIR : ${RECIPE_DIR}"

echo "Copying x3sp.xsl in Schemas directory..."
cp ${RECIPE_DIR}/extra_files/xs3p.xsl ${SRC_DIR}/Schemas/
cp -r ${SRC_DIR}/Schemas/ ${PREFIX}/Schemas/

cp ${RECIPE_DIR}/extra_files/FindBoost.cmake ${SRC_DIR}/cmake/

export PYTHON_VERSION="`python -c 'import platform; print(platform.python_version()[:3])'`"
echo "Python Version ${PYTHON_VERSION}"

# Custom changes for py35 and py36
# TODO: Send pullrequest to Microsoft/Malmo
# Ideally these should be handled by the Malmo CMakeLists.txt
if [ ${PY3K} -eq 1 ]; then
  # sed -i -e 's/date_time filesystem iostreams program_options python regex system/date_time filesystem iostreams program_options python3 regex system/g' CMakeLists.txt
  # sed -i -e 's/USE_PYTHON_VERSIONS 2.7/USE_PYTHON_VERSIONS ${PYTHON_VERSION}/g' CMakeLists.txt
  echo "pass"
fi

export MALMO_XSD_PATH=${PREFIX}/Schemas/

cd ${SRC_DIR}
mkdir build
cd build

echo "XSD_PATH = ${MALMO_XSD_PATH}"
export TERM=${TERM:-dumb} #Dummy $TERM variable to make gradle happy



if [ "$(uname)" == "Darwin" ]; then

  cmake \
    -DBUILD_DOCUMENTATION=Off \
    -DINCLUDE_CSHARP=Off \
    -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} -L${PREFIX}/lib -Wunused-command-line-argument" \
    -DBUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DSTATIC_BOOST=On \
    -DBOOST_INCLUDEDIR=${PREFIX}/include/ \
    -DBOOST_LIBRARYDIR=${PREFIX}/lib \
    -DUSE_PYTHON_VERSIONS_DESC=${PYTHON_VERSION} \
    -DMACOS_USE_PYTHON_MODULE=python${CONDA_PY} \
    ../

  make -j${CPU_COUNT}
  make install

  # Copy over Minecraft to env root
  cp -r ${SRC_DIR}/build/install/Minecraft ${PREFIX}/Minecraft
  # Copy over MalmoPython.so to python site packages
  cp ${SRC_DIR}/build/install/Python_Examples/MalmoPython.so ${SP_DIR}/

  cp -r ${SRC_DIR}/build/install ${PREFIX}/install
  ln -s ${PREFIX}/Minecraft/launchClient.sh ${PREFIX}/bin/launchClient.sh
  chmod +x ${PREFIX}/bin/launchClient.sh

fi

if [ "$(uname)" == "Linux" ]; then
  cmake \
    -DBUILD_DOCUMENTATION=Off \
    -DINCLUDE_CSHARP=Off \
    -DINCLUDE_LUA=Off \
    -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} -L${PREFIX}/lib -lpthread" \
    -DBUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DSTATIC_BOOST=On \
    -DBOOST_INCLUDEDIR=${PREFIX}/include \
    -DBOOST_LIBRARYDIR=${PREFIX}/lib \
    -DUSE_PYTHON_VERSIONS_DESC=${PYTHON_VERSION} \
    ../

  make -j${CPU_COUNT}
  make install

  # Copy over Minecraft to env root
  cp -r ${SRC_DIR}/build/install/Minecraft ${PREFIX}/Minecraft
  # Copy over MalmoPython.so to python site packages
  cp ${SRC_DIR}/build/install/Python_Examples/MalmoPython.so ${SP_DIR}/

  cp -r ${SRC_DIR}/build/install ${PREFIX}/install
  ln -s ${PREFIX}/Minecraft/launchClient.sh ${PREFIX}/bin/launchClient.sh
  chmod +x ${PREFIX}/bin/launchClient.sh
fi

# exit 1
