#!/bin/bash
#BSUB -q amber128
#BSUB -n 1
#BSUB -J _STRIPPING
#BSUB -o out
#BSUB -e error

# This script strips waters and ions out of simulation as well as strip simulation to backbone atoms 

##ADAPTED FROM DAN CHUNG##

# cuda 8 & mpich *NEW* for AMBER16
export PATH=/usr/local/cuda/bin:/usr/local/amber18/bin:/usr/local/mpich-3.1.4/bin:/usr/local/amber18/bin:/usr/local/cuda/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/Isabel/.local/bin:/home/Isabel/bin
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/amber18/lib:/usr/local/cuda/lib:/usr/local/cuda/lib64:
export PATH=/usr/local/mpich-3.1.4/bin:/home/apps/amber/12cpu-only/bin:/usr/local/amber18/bin:/usr/local/mpich-3.1.4/bin:/usr/local/amber18/bin:/usr/local/cuda/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/Isabel/.local/bin:/home/Isabel/bin
export LD_LIBRARY_PATH=/usr/local/mpich-3.1.4/lib:/usr/local/amber18/lib:/usr/local/cuda/lib:/usr/local/cuda/lib64:

# unique job scratch dirs *NEW* for AMBER16
MYSANSCRATCH=/sanscratch/
MYLOCALSCRATCH=/localscratch/
export MYSANSCRATCH MYLOCALSCRATCH

## AMBER we need to recreate env, /home/apps/amber/12cpu-only is already set
export PATH=/share/apps/CENTOS6/python/2.7.9/bin:/usr/local/amber18/bin:/usr/local/mpich-3.1.4/bin:/usr/local/amber18/bin:/usr/local/cuda/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/Isabel/.local/bin:/home/Isabel/bin
export LD_LIBRARY_PATH=/share/apps/CENTOS6/python/2.7.9/lib:/usr/local/amber18/lib:/usr/local/cuda/lib:/usr/local/cuda/lib64:
source /usr/local/amber18/amber.sh

cpptraj -i strip_1tup_2_HOH_1to200_concat.in > cpptraj_strip_concat.log
cpptraj -i strip_1tup_2_HOH_1to200_prmtop.in > cpptraj_strip_prmtop.log
