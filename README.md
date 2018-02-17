# malmo-conda-recipe

Conda recipes for building [Project Malmo](https://github.com/Microsoft/malmo)

The idea is to be able to install [Project Malmo](https://github.com/Microsoft/malmo) just by doing :
```
conda install -c crowdai malmo

python -c "import MalmoPython" #for use of the Python API
malmo-server -port 10001 # For launching the minecraft client
```

# Builds available

* Malmo version `0.31.0`
- [x] osx64/py27
- [x] osx64/py35
- [x] osx64/py36
- [x] linux64/py27
- [x] linux64/py35
- [x] linux64/py36
- [ ] win64/py27
- [ ] win64/py35
- [ ] win64/py36
- [ ] win32/py27
- [ ] win32/py35
- [ ] win32/py36



# Usage
Assuming you have [Anaconda](http://anaconda.org/) installed.
```
git clone https://github.com/spMohanty/malmo-conda-recipe
cd malmo-conda-recipe
conda build .
```

# Author
Sharada Mohanty <sharada.mohanty@epfl.ch>   
