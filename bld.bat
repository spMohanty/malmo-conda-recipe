#!/bin/bash

set INCLUDE_PATH=%PREFIX%\includes
set LIBRARY_PATH=%PREFIX%\lib

@echo Source DIR : %SRC_DIR%
@echo PREFIX : %PREFIX%
@echo RECIPE DIR : %RECIPE_DIR%

@echo "Copying x3sp.xsl in Schemas directory..."
@echo F | xcopy /S /Q /Y /F %RECIPE_DIR%\extra_files\xs3p.xsl %SRC_DIR%\Schemas\xs3p.xsl
xcopy %SRC_DIR%\Schemas %PREFIX%\Schemas\ /i

@echo F | xcopy /S /Q /Y /F  %RECIPE_DIR%\extra_files\FindBoost.cmake %SRC_DIR%\cmake\FindBoost.cmake

python -c "import platform; print(platform.python_version()[:3])" > python_version
SET /P PYTHON_VERSION= < python_version

@echo Python Version %PYTHON_VERSION%
@echo CONDA_PY %CONDA_PY%

set MALMO_XSD_PATH=%PREFIX%\Schemas\

cd %SRC_DIR%
mkdir build
cd build

@echo XSD_PATH = %MALMO_XSD_PATH%
set TERM=%TERM%:-dumb 

cmake -DBUILD_DOCUMENTATION=Off -DINCLUDE_CSHARP=Off -DCMAKE_C_COMPILER=gcc -DCMAKE_INSTALL_PREFIX=%PREFIX% -DSTATIC_BOOST=On -DUSE_PYTHON_VERSIONS_DESC=%PYTHON_VERSION% ../

make -j30
make install
