#!/bin/bash

# This script will run RMSD calcuations

## ADAPTED FROM DAN CHUNG ##

# cuda 8 & mpich *NEW* for AMBER16
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
export PATH=/usr/local/mpich-3.1.4/bin:/home/apps/amber/12cpu-only/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/mpich-3.1.4/lib:$LD_LIBRARY_PATH

# unique job scratch dirs *NEW* for AMBER16
MYSANSCRATCH=/sanscratch/
MYLOCALSCRATCH=/localscratch/
export MYSANSCRATCH MYLOCALSCRATCH

## AMBER we need to recreate env, /home/apps/amber/12cpu-only is already set
export PATH=/share/apps/CENTOS6/python/2.7.9/bin:$PATH
export LD_LIBRARY_PATH=/share/apps/CENTOS6/python/2.7.9/lib:$LD_LIBRARY_PATH
source /usr/local/amber18/amber.sh

cpptraj -i rmsd_1tup_2_HOH_1to200.in > cpptraj_rmsd.log
