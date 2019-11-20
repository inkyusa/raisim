### This repo assumes that you already installed a tensorflow (1.xx) environments (e.g., using Virtual env or Conda)

## This repo contains a gitmodule file that links the following repos as submodules:

https://github.com/inkyusa/raisimGymTutorial.git

https://github.com/inkyusa/raisimOgre.git

https://github.com/inkyusa/raisimLib.git

https://github.com/inkyusa/ogre.git

https://github.com/inkyusa/raisimGym.git

The following procedure should allow not only cloning this repo but cloning all other submodules.

```
$git clone https://github.com/inkyusa/raisim
$cd raisim
$git submodule update --init --recursive
```
You can update your submodules with
```
$git submodule update --recursive
```
after the initialisation.


After cloning all repos, all you need to do is (w/o source below, you can't update environmental variables such as LD_LIBRARY_PATH)

```
$cd raisim
$source ./build_script.sh build
```
You should be able to see

<img src="http://drive.google.com/uc?export=view&id=1f4qj2jbs5RuAC8OaSyupXUAFWPfWVj1B" height=300px>

and if you want to clean all packages,

```
$source ./build_script.sh clean
```
this command will delete all sub-build folders and $LOCAL_BUILD directory.

### git versioning tools

You can use git termnal commands of course, but it is highly recommended to use GUI-based git versioning tools such as [Git Kraken](https://www.gitkraken.com/) or Git Cola especially for managing multiple submodules.
