#!/bin/bash

INCLUDE_PATH=$PREFIX/include
LIBRARY_PATH=$PREFIX/lib

export PYTHON_INCLUDE_DIR=`python -c "from __future__ import print_function; import distutils.sysconfig; print(distutils.sysconfig.get_python_inc(True))"`

echo "Copying x3sp.xsl in Schemas directory..."
echo "Source DIR : ${SRC_DIR}"
echo "PREFIX : ${PREFIX}"
echo "RECIPE DIR : ${RECIPE_DIR}"

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
  -DINCLUDE_JAVA=Off \
  -DSTATIC_BOOST=On \
  -DXSD_EXECUTABLE=$PREFIX/bin/xsd-marlo \
  -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} -L${PREFIX}/lib -lxerces-c -Wunused-command-line-argument" \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  ../

make #-j${CPU_COUNT}
make install
