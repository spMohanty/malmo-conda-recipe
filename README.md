# malmo-conda-recipe

Conda recipes for building [Project Malmo](https://github.com/Microsoft/malmo)

The idea is to be able to install [Project Malmo](https://github.com/Microsoft/malmo) just by doing :
```
conda config --add channels conda-forge 
conda install -c crowdai malmo

python -c "import MalmoPython" #for use of the Python API
launchClient.sh -port 10001 # For launching the minecraft client
```

# Builds available

* Malmo version `0.35.6`
- [x] osx64/py35
- [x] osx64/py36
- [x] linux64/py35
- [x] linux64/py36
- [ ] win64/py35
- [ ] win64/py36
- [ ] win32/py35
- [ ] win32/py36


# Notes
* conda-forge `toolchain` doesnt work with py36+boost1.67, hence we use it only for py37+boost1.67
and for py36, we use the usual `gcc` instead.

# Usage
Assuming you have [Anaconda](http://anaconda.org/) installed.
```
git clone https://github.com/spMohanty/malmo-conda-recipe
cd malmo-conda-recipe
conda build -c conda-forge .
```

# Author
Sharada Mohanty <sharada.mohanty@epfl.ch>   
