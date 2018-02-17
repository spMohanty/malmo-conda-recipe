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

export MALMO_XSD_PATH=${PREFIX}/Schemas/

cd ${SRC_DIR}
mkdir build
cd build

echo "XSD_PATH = ${MALMO_XSD_PATH}"
export TERM=${TERM:-dumb} #Dummy $TERM variable to make gradle happy

cmake \
  -DBUILD_DOCUMENTATION=Off \
  -DINCLUDE_CSHARP=Off \
  -DUSE_PYTHON_VERSIONS=${PYTHON_VERSION} \
  -DXSD_EXECUTABLE=$PREFIX/bin/xsd-marlo \
  -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} -L${PREFIX}/lib -lxerces-c -Wunused-command-line-argument" \
  -DBUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  ../

make -j${CPU_COUNT}
make install

# Copy over Minecraft to env root
cp -r ${SRC_DIR}/build/install/Minecraft ${PREFIX}/Minecraft
# Copy over MalmoPython.so to python site packages
cp ${SRC_DIR}/build/install/Python_Examples/MalmoPython.so ${SP_DIR}/

cp -r ${SRC_DIR}/build/install ${PREFIX}/install
cp ${RECIPE_DIR}/extra_files/malmo-server ${PREFIX}/bin/malmo-server
chmod +x ${PREFIX}/bin/malmo-server


# exit 1
