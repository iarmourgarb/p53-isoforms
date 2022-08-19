#!/bin/bash

#source /etc/profile
gpu1=0
gpu2=0
gpu3=0
gpu4=0

nvidia-smi | grep "pmemd" | awk '{print $2}' > o1
while read a
do
        if [ $a -eq 0 ]
        then
                gpu1=1
        fi
        if [ $a -eq 1 ]
        then
                gpu2=1
        fi
        if [ $a -eq 2 ]
        then
                gpu3=1
        fi
        if [ $a -eq 3 ]
        then
                gpu4=1
        fi
done < o1

        if [ $gpu1 -eq 0 ]
        then
                export CUDA_VISIBLE_DEVICES=0
        elif [ $gpu2 -eq 0 ]
        then
                export CUDA_VISIBLE_DEVICES=1
        elif [ $gpu3 -eq 0 ]
        then
                export CUDA_VISIBLE_DEVICES=2
        elif [ $gpu4 -eq 0 ]
        then
                export CUDA_VISIBLE_DEVICES=3
        else
                echo "NO GPU AVAILABLE. TRY LATER"
                exit
        fi

#export CUDA_VISIBLE_DEVICES=0
echo $CUDA_VISIBLE_DEVICES


############################################################ Job-Specific Variables  ############################################################
SAMPLENAME=1tup_2_HOH
FIRSTNS=6
FINALNS=125
FIRSTRES=1
FINALRES=348

INPCRD=${SAMPLENAME}.inpcrd
PRMTOP=${SAMPLENAME}.prmtop

############################################################ Subroutines: START  ############################################################

production()
{
    MYI=`expr ${FIRSTNS} - 1`
    i=$MYI
    echo $i >> temp.out
    echo ${MYI} >> temp.out
    echo ${FINALNS} >> temp.out

    while [ $i -lt ${FINALNS} ] ; do
    echo " " >> temp.out
    echo " variable i = ${i} " >> temp.out

    k=`expr ${i} + 1`
    echo " variable k = $k" >> temp.out

INPUT=${SAMPLENAME}_dyn.in
OUTPUT=${SAMPLENAME}_equil.${k}.out
RESTART=${SAMPLENAME}_equil.${k}.rst
RESTFRHT=${SAMPLENAME}_heat.rst
COORD=${SAMPLENAME}_equil.${k}.mdcrd
PDB=${SAMPLENAME}_equil.${k}.pdb

    if [ $k = 1 ];
    then
        echo "in first pass" >> temp.out

    # EXECUTE FIRST NS BLOCK OF PTT MD ON
        pmemd.cuda.MPI -O -i ${INPUT} -o ${OUTPUT} -p ${PRMTOP} -c ${RESTFRHT} -r ${RESTART} -x ${COORD}
        gzip ${COORD}

    else
        echo "in second pass" >> temp.out

    #  EXECUTE ALL SUBSEQUENT NS OF MD IN 1 NS BLOCKS
       RESTFROM=${SAMPLENAME}_equil.${i}.rst
       pmemd.cuda.MPI -O -i ${INPUT} -o ${OUTPUT} -p ${PRMTOP} -c ${RESTFROM} -r ${RESTART} -x ${COORD}
       gzip ${COORD}
    fi
    i=`expr ${i} + 1`
    echo "MD EQUILIBRATION STEP $k completed at " >> time.log
    date >> time.log
    done
}

############################################################ Subroutines: END  ############################################################

############################################################ MAIN SCRIPT BODY: START #######################################################

###################    Equilibration  #################

###################    Production     #################
production

###################    Finalizing     #################

############################################################ MAIN SCRIPT BODY: END ########################################################

exit
