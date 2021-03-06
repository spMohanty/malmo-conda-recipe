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
echo "CONDA_PY ${CONDA_PY}"
echo "===================================================="
printenv
echo "===================================================="
# Custom changes for py36 and py37
# TODO: Send pullrequest to Microsoft/Malmo
# Ideally these should be handled by the Malmo CMakeLists.txt
if [ ${PY3K} -eq 1 ]; then
    sed -i -e "s/\"python3\"/\"python$CONDA_PY\"/g" CMakeLists.txt
    # This changes the line here : https://github.com/Microsoft/malmo/blob/master/CMakeLists.txt#L112
    # from : SET( BOOST_PYTHON_MODULE_NAME "python3" )
    # to : SET( BOOST_PYTHON_MODULE_NAME "python36" ) (or "python37") depending on the python build.
    # This lets FindBoost find where boost and boost_python are    
  echo "pass"
fi

export MALMO_XSD_PATH=${PREFIX}/Schemas/

cd ${SRC_DIR}
if [ -d "build" ]; then
    rm -rf build
fi
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
  # Copy over Schemas Directory to env root
  cp -r ${SRC_DIR}/build/install/Schemas ${PREFIX}/MalmoSchemas
  # Copy over MalmoPython.so to python site packages
  cp ${SRC_DIR}/build/install/Python_Examples/MalmoPython.so ${SP_DIR}/

  # Copy Over env vars setup scripts
  mkdir -p ${PREFIX}/etc/conda/activate.d
  mkdir -p ${PREFIX}/etc/conda/deactivate.d
  cp ${RECIPE_DIR}/extra_files/env_setup/env_activate.sh ${PREFIX}/etc/conda/activate.d/malmo.sh
  cp ${RECIPE_DIR}/extra_files/env_setup/env_deactivate.sh ${PREFIX}/etc/conda/deactivate.d/malmo.sh
  # This sets the MALMO_XSD_PATH path variable and any other required variables


  cp -r ${SRC_DIR}/build/install ${PREFIX}/install
fi

if [ "$(uname)" == "Linux" ]; then
  cmake \
    -DBUILD_DOCUMENTATION=Off \
    -DINCLUDE_CSHARP=Off \
    -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} -L${PREFIX}/lib -lpthread -lstdc++" \
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
  # Copy over Schemas Directory to env root
  cp -r ${SRC_DIR}/build/install/Schemas ${PREFIX}/MalmoSchemas
  # Copy over MalmoPython.so to python site packages
  cp ${SRC_DIR}/build/install/Python_Examples/MalmoPython.so ${SP_DIR}/
  
  # Copy Over env vars setup scripts
  mkdir -p ${PREFIX}/etc/conda/activate.d
  mkdir -p ${PREFIX}/etc/conda/deactivate.d
  cp ${RECIPE_DIR}/extra_files/env_setup/env_activate.sh ${PREFIX}/etc/conda/activate.d/malmo.sh
  cp ${RECIPE_DIR}/extra_files/env_setup/env_deactivate.sh ${PREFIX}/etc/conda/deactivate.d/malmo.sh
  # This sets the MALMO_XSD_PATH path variable and any other required variables

  cp -r ${SRC_DIR}/build/install ${PREFIX}/install
fi

# exit 1
