#!/bin/bash

#installer.sh

directory=`pwd`
file=$directory/GUI_Alpha_6_installer.txt

zenity --text-info \
       --title "ETENLNC INSTALLER" \
       --filename=$file \
       --checkbox="I read and accept the terms"
 
#Creating a bin directory at $HOME
mkdir -p $directory/bin
bin_loc=$directory/bin

#Asking user for bin location 
bin=`zenity --file-selection \
	--title="Please select location to create binaries required for the pipeline to run" \
	--filename "/home/${USER}/" \
	--directory`
	
#Moving bin directory to assigned location
mv $bin_loc $bin

(
# =================================================================
echo "# Installing FASTP" ; sleep 5
for i in fastp hisat2 fastqc stringtie zenity samtools gffread subread salmon r-base ncbi-blast+; do
sudo apt-get install -y $i
done

# 2. CPC2
# =================================================================
echo "80"
echo "# Compiling CPC2" ; sleep 2
wget https://github.com/gao-lab/CPC2_standalone/archive/refs/tags/v1.0.1.tar.gz
gunzip v1.0.1.tar.gz
tar xvf v1.0.1.tar
cd CPC2_standalone-1.0.1 
export CPC_HOME="$PWD"
cd libs/libsvm
gunzip libsvm-3.18.tar.gz 
tar xvf libsvm-3.18.tar
cd libsvm-3.18
make clean && make

# 3. LncTar
# =================================================================
echo 85"
echo "# Compiling LncTar" ; sleep 2
cd $bin
wget http://www.cuilab.cn/lnctarapp/download
unzip download

# 4. miRanda
# =================================================================
echo "90"
echo "# Compiling miRanda" ; sleep 2
cd $bin
wget http://cbio.mskcc.org/miRNA2003/src1.9/binaries/miRanda-1.9-i686-linux-gnu.tar.gz
tar xvzf miRanda-1.9-i686-linux-gnu.tar.gz

cd miRanda-1.9-i686-linux-gnu/bin
chmod u+x miranda

# 5. Capsule-LPI
# =================================================================
echo "93"
echo "# Compiling Capsule-LPI" ; sleep 2
cd $bin
wget http://39.100.104.29:8080/static/clf/code/Capsule_LPI_sources.zip
unzip Capsule_LPI_sources.zip
cd Capsule_LPI_sources/data/tools/
chmod u+x RNAFold

cd $bin 
# protein prediction pending

# 6. SEEKR
# =================================================================
echo "98"
echo "# Compiling SEEKR" ; sleep 2
cd $bin


# =================================================================
echo "# All finished." ; sleep 2
echo "100"


) |
zenity --progress \
  --title="Installing Dependencies" \
  --text="First Task." \
  --percentage=0 \
  --auto-close \
  --auto-kill

(( $? != 0 )) && zenity --error --text="Error in zenity command."

exit 0
