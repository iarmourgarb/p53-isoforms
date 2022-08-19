#!/bin/bash

# BEFORE YOU START PLEASE READ DIRECTIONS CAREFULLY

# This script makes the input and submission scripts for cpptraj to run RMSD calculations 
# This part will create input script for RMSD

# Full System Path:
# /home33/{USER}/{PROTEIN}/{SAMPLENAME}/

# Run this script on the head node

## ADAPTED FROM DAN CHUNG ##


if [ $# -ne 6 ]; then
    echo
    echo Please enter the correct number of commandline arguments
    echo
    echo "Sample Input:"
    echo
    echo './08A_make_cpptraj_strip_inputs.sh' /home33/djchung/GPX4/NEW_STUFF/GPX4_WT/ GPX4_WT 1 100 1 165
    echo
    echo '$1 = Path to {SAMPLENAME}: /home33/{USER}/{PROTEIN}/{SAMPLENAME}/'
    echo '$2 = {SAMPLENAME}'
    echo '$3 = {FIRSTNS}'
    echo '$4 = {FINALNS}'
    echo '$5 = {FIRSTRES}'
    echo '$6 = {FINALRES}'
    echo
    exit
fi

#PATH=$1
#SAMPLENAME=$2
#FIRSTNS=$3
#FINALNS=$4
#FIRSTRES=$5
#FINALRES=$6

echo parm $1$2_strip_$3to$4.prmtop > rmsd_$2_$3to$4.in
echo trajin $1$2_strip_$3to$4.trj parm $1$2_strip_$3to$4.prmtop >> rmsd_$2_$3to$4.in
echo autoimage >> rmsd_$2_$3to$4.in
echo rms first :$5-$6@N,CA,C,O,H out rmsd_$2_$3to$4.dat >> rmsd_$2_$3to$4.in
echo average $2_avg_$3to$4.pdb >> rmsd_$2_$3to$4.in
echo go >> rmsd_$2_$3to$4.in

# This part will create submission script for RMSD

echo "\
#!/bin/bash

# This script will run RMSD calcuations

# cuda 8 & mpich *NEW* for AMBER16
export PATH=/usr/local/cuda/bin:\$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:\$LD_LIBRARY_PATH
export PATH=/usr/local/mpich-3.1.4/bin:/home/apps/amber/12cpu-only/bin:\$PATH
export LD_LIBRARY_PATH=/usr/local/mpich-3.1.4/lib:\$LD_LIBRARY_PATH

# unique job scratch dirs *NEW* for AMBER16
MYSANSCRATCH=/sanscratch/
MYLOCALSCRATCH=/localscratch/
export MYSANSCRATCH MYLOCALSCRATCH

## AMBER we need to recreate env, /home/apps/amber/12cpu-only is already set
export PATH=/share/apps/CENTOS6/python/2.7.9/bin:\$PATH
export LD_LIBRARY_PATH=/share/apps/CENTOS6/python/2.7.9/lib:\$LD_LIBRARY_PATH
source /usr/local/amber18/amber.sh

cpptraj -i rmsd_$2_$3to$4.in > cpptraj_rmsd.log" > 08B_run_rmsd.sh

chmod u+x 08B_run_rmsd.sh

echo You are so amazing! You are an incredible coder and this lab is lucky to have you!
echo ' '
echo 'Make sure you check rmsd.in, but after that go ahead and bsub < 08B_run_rmsd.sh!!!'
