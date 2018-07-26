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

@echo PATH : %PATH%

xcopy /S /Q /Y /F %RECIPE_DIR%\extra_files\CMakeLists.txt %SRC_DIR%\CMakeLists.txt

set JAVA_INCLUDE_PATH2=%PREFIX%\Library\include
@echo JAVA_INCLUDE_PATH2 : %JAVA_INCLUDE_PATH2%

REM sed -i -e "s/\"python3\"/\"python%CONDA_PY%\"/g" CMakeLists.txt
REM  from : SET( BOOST_PYTHON_MODULE_NAME "python3" )
REM  to : SET( BOOST_PYTHON_MODULE_NAME "python36" ) (or "python37") depending on the python build.
REM  This lets FindBoost find where boost and boost_python are

cmake -DBUILD_DOCUMENTATION=Off -DJAVA_INCLUDE_PATH2=%JAVA_INCLUDE_PATH2% -DINCLUDE_CSHARP=Off -DCMAKE_INSTALL_PREFIX=%PREFIX% -DSTATIC_BOOST=On -DUSE_PYTHON_VERSIONS_DESC=%PYTHON_VERSION% ../

REM  -j%NUMBER_OF_PROCESSORS%
cmake --build . --config Release --target install