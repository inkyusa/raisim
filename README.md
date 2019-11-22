## This repo contains a gitmodule file that links to the following repos as submodules:

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

After cloning all repos, all you need to do is (w/o source below, you can't update environmental variables such as LD_LIBRARY_PATH)

## if you are using Ubuntu 18.04 and haven't installed tensorflow 1.xx, then

```
$cd raisim
$source ./build_script.sh build_with_conda
```
This will install and setup your conda environment (i.e., conda_raisim)

## else you have Ubuntu 18.04 and tensorflow 1.xx

```
$cd raisim
$source ./build_script.sh build
```
You may need to install `ruamel.yaml` dependency into your python environment and we are currently only supporting Ubuntu 18.04. But it is possible if you can match the gcc, g++, cmake versions on any other distributions (e.g., 16.04).


If all installation procedures successfully finished, you should be able to see

<img src="http://drive.google.com/uc?export=view&id=1f4qj2jbs5RuAC8OaSyupXUAFWPfWVj1B" height=300px>

This script has been tested with a valliaba Ubuntu 18.04.


If you want to clean all packages,

```
$source ./build_script.sh clean
```
this command will delete all sub-build folders and $LOCAL_BUILD directory.

### git versioning tools

You can use git termnal commands of course, but it is highly recommended to use GUI-based git versioning tools such as [Git Kraken](https://www.gitkraken.com/) or Git Cola especially for managing multiple submodules.

### I have a GPU(s) and want to use them for training?
According to [Tensorflow](https://www.tensorflow.org/install/pip), the version we installed in this tutorial (1.15) is the final 1.xx version can support both CPU and GPU. It should support GPUs seamlessly. Otherwise you can try `tensorflow-gpu=1.14`.
