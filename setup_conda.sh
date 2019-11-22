CUR_DIR=$(pwd)
echo "You are running this script at $CUR_DIR"
cd $CUR_DIR

#============================================
# !!!!! IMPOARTANT !!!!!!!!!!!
# The name of these two environment variables (i.e., WORKSPACE or LOCAL_BUILD) should be maunally changed since these are widiely used in the subequent procedures.
#============================================
WORKSPACE=${CUR_DIR}

#Try to set up conda environemtns, experimental feature for those who haven't installed conda or tensorflow yet.
echo "========================================================="
echo "                  Installing miniconda and               "
echo "                  setup conda_raisim environment         "
echo "========================================================="
conda_file_name="Miniconda3-latest-Linux-x86_64.sh"
conda_URL="https://repo.anaconda.com/miniconda/${conda_file_name}"
cd ~/Downloads
#Check if conda install file exist
if [ -f "${conda_file_name}" ]
then
    echo "You already have ${conda_file_name}."
    echo "Skip downloading"
else
    wget $conda_URL -P ~/Downloads
fi

chmod 755 ./${conda_file_name}
./${conda_file_name}
conda create -n conda_raisim tensorflow=1.15 python
echo "alias conda_raisim='conda activate conda_raisim'" >> ~/.bashrc
echo "alias conda_off='conda deactivate'" >> ~/.bashrc
source ~/.bashrc
conda_raisim
echo "========================================================="
echo "                  Activate conda_raimsim env             "
echo "========================================================="
conda install -c conda-forge ruamel.yaml
conda config --set auto_activate_base false
cd ${WORKSPACE}
