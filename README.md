## This repo contains a gitmodule file that links the following repos as submodules:

https://github.com/inkyusa/raisimGymTutorial.git

https://github.com/inkyusa/raisimOgre.git

https://github.com/inkyusa/raisimLib.git

https://github.com/inkyusa/ogre.git

https://github.com/inkyusa/raisimGym.git

The following procedure should allow not only cloning this repo but cloning all other submodules.

```
$git clone https://github.com/inkyusa/raisim
```

```
$cd raisim
```
```
$git submodule update --init --recursive (only once after clone this repo)
```
```
$git submodule update --recursive
```

Now cloned all repos, and let's build them one by one. In this example we defined the following two environment variables:

(TODO: Inkyu, create a shell script that executes the following commands).

LOCAL_BUILD=~/workspace/raisim_env

WORKSPACE=~/workspace



Building order should be in the order.
-----------------------------
1. raisim-lib build
-----------------------------
```
$cmake .. -DCMAKE_INSTALL_PREFIX=$LOCAL_BUILD
```
```
$make install
```
-----------------------------
2. ogre build
-----------------------------
```
$cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$LOCAL_BUILD -DOGRE_BUILD_COMPONENT_BITES=ON -OGRE_BUILD_COMPONENT_JAVA=OFF -DOGRE_BUILD_DEPENDENCIES=OFF -DOGRE_BUILD_SAMPLES=False
```
```
$make install -j8
```
-----------------------------
3. raisimOgre build
-----------------------------
```
$cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$LOCAL_BUILD -DCMAKE_INSTALL_PREFIX=$LOCAL_BUILD -DRAISIM_OGRE_EXAMPLES=True
```
```
$make install -j8
```
-----------------------------
3. pybind11 build
-----------------------------
```
$cmake .. -DCMAKE_INSTALL_PREFIX=$LOCAL_BUILD -DPYBIND11_TEST=OFF
```
```
$make install -j8
```
-----------------------------
4. raisimGym build
-----------------------------
```
$python3 setup.py install --CMAKE_PREFIX_PATH $LOCAL_BUILD --env anymal
```
-----------------------------
Training
-----------------------------
```
$python3 scripts/anymal_blind_locomotion.py -m train
```
