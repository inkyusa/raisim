#  #!/bin/bash

# Written and tested by Inkyu Sa, inkyu.sa@csiro.au, 2019


#check args
if [ "$#" -ne 1 ]
then
    echo "This is a build script for raisim. Raisim has 5 dependencies and this repo submoduled them and tried to manage them in a single repo in order to reduce complexities. This script performs simple building and clenaing procedures."
    echo "Usage: $0 <MODE build or clean>"
    exit 1
fi

#CC=/usr/bin/gcc
#CXX=/usr/bin/g++

echo "========================================================="    
echo "                  Checking software versions             "    
echo "========================================================="    

gcc_version="$($CC -dumpversion)"   
gcc_required_version="6.0.0"    
if [ "$(printf '%s\n' "$gcc_required_version" "$gcc_version" | sort -V | head -n1)" = "$gcc_required_version" ]; then   
    echo ">>>>>>>>>>>gcc Version checking passed"   
else    
    echo "Less than 6.0.0, please use the right version"    
    echo "You can get more information regarding software installation required by raisim from https://github.com/jhwangbo/raisimHelp"  
    exit 1  
fi  

gpp_version="$($CXX -dumpversion)"  
gpp_required_version="6.0.0"    
if [ "$(printf '%s\n' "$gpp_required_version" "$gpp_version" | sort -V | head -n1)" = "$gpp_required_version" ]; then   
    echo ">>>>>>>>>>g++ Version checking passed"    
else    
    echo "Less than 6.0.0, please use the right version"    
    echo "You can get more information regarding software installation required by raisim from https://github.com/jhwangbo/raisimHelp"  
    exit 1  
fi  


cmake --version 

echo "=========================================================="   
echo "  Raisim is using cmake>3.10, please check if you are using correct version.    " 
echo "=========================================================="   

sudo apt-get install -y libyaml-cpp-dev cmake libeigen3-dev libgles2-mesa-dev libxt-dev libxaw7-dev libsdl2-dev libzzip-dev libfreeimage-dev libfreetype6-dev libpugixml-dev


MODE=$1

echo "========================================================="
echo "                  You chose $MODE                        "
echo "========================================================="

#Predefine some necessary variables.

CUR_DIR=$(pwd)
echo "You are running this script at $CUR_DIR"
cd $CUR_DIR

#============================================
# !!!!! IMPOARTANT !!!!!!!!!!!
# The name of these two environment variables (i.e., WORKSPACE or LOCAL_BUILD) should be maunally changed since these are widiely used in the subequent procedures.
#============================================
WORKSPACE=${CUR_DIR}
LOCAL_BUILD="${WORKSPACE}/raisim_local_build"


if [ $MODE == "build" ]
then
    echo "========================================================="
    echo "                  Entering build mode                    "
    echo "========================================================="

    # check LOCAL_BUILD
    if [ ! -d "${LOCAL_BUILD}" ]
    then 
        echo "Output folder \"${LOCAL_BUILD}\" not found, creating new folder"
        mkdir ${LOCAL_BUILD}
    fi

    #Add LD_LIBRARY_PATH into bashrc for later use.
    #if you run this script n times, this will appear n time in your bashrc
    echo "export LD_LIBRARY_PATH=${LOCAL_BUILD}/lib:$LD_LIBRARY_PATH" >> ~/.bashrc

    # to ensure that ld finds Ogre3D shared objects.
    export LD_LIBRARY_PATH=${LOCAL_BUILD}/lib:$LD_LIBRARY_PATH

    # Compilers setup
    #export CXX=/usr/bin/g++-8 && export CC=/usr/bin/gcc-8


    # Building order should be in the following order.
    # -----------------------------
    # 1. raisim-lib build
    # -----------------------------
    echo "========================================================="
    echo "                  Building raisimLib                     "
    echo "========================================================="
    cd raisimLib/
    mkdir build
    cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=$LOCAL_BUILD
    make install
    cd $WORKSPACE

    # -----------------------------
    # 2. ogre build
    # -----------------------------
    echo "========================================================="
    echo "                  Building ogre                          "
    echo "========================================================="
    cd ogre/
    mkdir build
    cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$LOCAL_BUILD -DOGRE_BUILD_COMPONENT_BITES=ON -OGRE_BUILD_COMPONENT_JAVA=OFF -DOGRE_BUILD_DEPENDENCIES=OFF -DOGRE_BUILD_SAMPLES=False
    make install -j8
    cd $WORKSPACE

    # -----------------------------
    # 3. raisimOgre build
    # -----------------------------
    echo "========================================================="
    echo "                  Building raisimOgre                    "
    echo "========================================================="
    cd raisimOgre
    mkdir build
    cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$LOCAL_BUILD -DCMAKE_INSTALL_PREFIX=$LOCAL_BUILD -DRAISIM_OGRE_EXAMPLES=True
    make install -j8
    cd $WORKSPACE

    # -----------------------------
    # 4. pybind11 build
    # -----------------------------
    echo "========================================================="
    echo "                  Building pybind11                      "
    echo "========================================================="
    cd pybind11
    mkdir build
    cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=$LOCAL_BUILD -DPYBIND11_TEST=OFF
    make install -j8
    cd $WORKSPACE

    # -----------------------------
    # 5. raisimGym build
    # -----------------------------
    echo "========================================================="
    echo "                  Building raisimGym                     "
    echo "========================================================="
    cd raisimGym
    python3 setup.py install --CMAKE_PREFIX_PATH $LOCAL_BUILD --env anymal

    # Training
    # python3 scripts/anymal_blind_locomotion.py -m train
    # cd $WORKSPACE

    # Testing.
    python3 scripts/anymal_blind_locomotion.py -m test -w ./weights/ANYmal_blind_locomotion/anymal_running_weights.pkl

    cd $WORKSPACE

elif [ $MODE == "clean" ]
then
    echo "========================================================="
    echo "                  Entering clean mode                    "
    echo "========================================================="
    cd $WORKSPACE
    rm -rf ${LOCAL_BUILD}
    
    cd $WORKSPACE
    rm -rf raisimLib/build
    
    cd $WORKSPACE
    rm -rf ogre/build
    
    cd $WORKSPACE
    rm -rf raisimOgre/build
    
    cd $WORKSPACE
    rm -rf pybind11/build

    cd $WORKSPACE
    rm -rf raisimGym/build
    
    echo ""
    echo "========================================================="
    echo "       Clean done: all local libs has been deleted.      "
    echo "========================================================="
fi