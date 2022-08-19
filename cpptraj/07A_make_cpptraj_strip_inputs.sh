#!/bin/bash

# This script generates the input for cpptraj strip and concatenation run for specific protein systems

# If not, prompt the user with a sample and exit.

# Run this script on the head node

##ADAPTED FROM DAN CHUNG##

# check if the input file already exists, and if it does remove
if [ -f strip_concat.in ]; then
    echo 'Remove strip_concat.in'
fi

if [ -f strip_inpcrd.in ]; then
    echo 'Remove strip_inpcrd.in'
fi

if [ -f strip_prmtop.in ]; then
    echo 'Remove strip_prmtop.in'
    exit
fi

# put comments in the input file
echo '# This is an input script for running cpptraj to concatenate and strip trajectories' > strip_$2_$3to$4_concat.in
echo '# It was written by 07_make_cpptraj_strip_inputs.sh.' >> strip_$2_$3to$4_concat.in
echo '# This is an input script for running cpptraj strip parameter files' > strip_$2_$3to$4_prmtop.in
echo '# It was written by 07_make_cpptraj_strip_inputs.sh.' >> strip_$2_$3to$4_prmtop.in
echo '# This is an input script for running cpptraj to strip coordinate files' > strip_$2_$3to$4_inpcrd.in
echo '# It was written by 07_make_cpptraj_strip_inputs.sh.' >> strip_$2_$3to$4_inpcrd.in

# instructions for loading parmtop file
echo parm $1$2.prmtop >> strip_$2_$3to$4_concat.in
echo parm $1$2.prmtop >> strip_$2_$3to$4_inpcrd.in

# write a line for each ns of trajectory to read
for i in $(seq $3 $4); do
    echo trajin $2_equil.$i.mdcrd 1 last $5 >> strip_$2_$3to$4_concat.in
done

# make strip_concat.in
echo autoimage >> strip_$2_$3to$4_concat.in
echo "# If you need to strip ligands" >> strip_$2_$3to$4_concat.in
echo "#strip :#-#" >> strip_$2_$3to$4_concat.in
echo strip :WAT >> strip_$2_$3to$4_concat.in
echo strip :Na+ >> strip_$2_$3to$4_concat.in
echo strip :Cl- >> strip_$2_$3to$4_concat.in
echo strip !@CA,C,N,O,H >> strip_$2_$3to$4_concat.in

# instructions for generating the stripped, imaged, and concatenated trajector without simulation box info
echo trajout ${2}_strip_${3}to${4}.trj nobox >> strip_$2_$3to$4_concat.in

# make strip_inpcrd.in
echo trajin $1${2}.inpcrd >> strip_$2_$3to$4_inpcrd.in
echo "# If you need to strip ligands" >> strip_$2_$3to$4_inpcrd.in
echo "#strip :#-#" >> strip_$2_$3to$4_inpcrd.in
echo center >> strip_$2_$3to$4_inpcrd.in
echo autoimage >> strip_$2_$3to$4_inpcrd.in
echo strip :WAT >> strip_$2_$3to$4_inpcrd.in
echo strip :Na+ >> strip_$2_$3to$4_inpcrd.in
echo strip :Cl- >> strip_$2_$3to$4_inpcrd.in
echo strip !@CA,C,O,N,H >> strip_$2_$3to$4_inpcrd.in
echo trajout ${2}_strip_$3to$4.inpcrd >> strip_$2_$3to$4_inpcrd.in
echo go >> strip_$2_$3to$4_inpcrd.in

# make strip_prmtop.in
echo parm ${2}.prmtop >> strip_$2_$3to$4_prmtop.in
echo "# If you need to strip lingands" >> strip_$2_$3to$4_prmtop.in
echo "#parmstrip :#-#" >> strip_$2_$3to$4_prmtop.in
echo center >> strip_$2_$3to$4_prmtop.in
echo parmstrip :WAT >> strip_$2_$3to$4_prmtop.in
echo parmstrip :Na+ >> strip_$2_$3to$4_prmtop.in
echo parmstrip :Cl- >> strip_$2_$3to$4_prmtop.in
echo parmstrip !@CA,C,O,N,H >> strip_$2_$3to$4_prmtop.in
echo parmwrite out ${2}_strip_$3to$4.prmtop >> strip_$2_$3to$4_prmtop.in
echo go >> strip_$2_$3to$4_prmtop.in

# make script that runs stripping
cat <<EOF > 07B_run_cpptraj_strip_inputs.sh
#!/bin/bash
#BSUB -q amber128
#BSUB -n 1
#BSUB -J ${SAMPLENAME}_STRIPPING
#BSUB -o out
#BSUB -e error

# This script strips waters and ions out of simuation as well as strip simulation to backbone atoms 

# cuda 8 & mpich *NEW* for AMBER18
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
export PATH=/usr/local/mpich-3.1.4/bin:/home/apps/amber/12cpu-only/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/mpich-3.1.4/lib:$LD_LIBRARY_PATH

# unique job scratch dirs *NEW* for AMBER18
MYSANSCRATCH=/sanscratch/
MYLOCALSCRATCH=/localscratch/
export MYSANSCRATCH MYLOCALSCRATCH

## AMBER we need to recreate env, /home/apps/amber/12cpu-only is already set
export PATH=/share/apps/CENTOS7/python/2.7.9/bin:$PATH
export LD_LIBRARY_PATH=/share/apps/CENTOS7/python/2.7.9/lib:$LD_LIBRARY_PATH
source /usr/local/amber18/amber.sh

cpptraj -i strip_$2_$3to$4_concat.in > cpptraj_strip_concat.log
cpptraj -i strip_$2_$3to$4_prmtop.in > cpptraj_strip_prmtop.log
cpptraj -i strip_$2_$3to$4_inpcrd.in > cpptraj_strip_inpcrd.log

EOF

chmod u+x 07B_run_cpptraj_strip_inputs.sh
