#!/bin/bash                                                                                                                                                                   
#BSUB -q amber128                                                                                                                                                                
#BSUB -n 1                                                                                                                                                                    
#BSUB -J 1tup_emin                                                                                                                                                    
#BSUB -o emin.out                                                                                                                                                                  
#BSUB -e err


NAME=1tup_2_HOH
                                                                               
cd /home33/iarmourgarb/new_p53/iso2/EMIN/
 
/home/apps/CENTOS7/amber/amber18/bin/sander -O -i emin1_1tup.in -p ${NAME}.prmtop -c ${NAME}.inpcrd -r ${NAME}_emin1.rst -ref ${NAME}.inpcrd -o ${NAME}_emin1.out

/home/apps/CENTOS7/amber/amber18/bin/sander -O -i emin2_1tup.in -p ${NAME}.prmtop -c ${NAME}_emin1.rst -r ${NAME}_emin2.rst -ref ${NAME}_emin1.rst -o ${NAME}_emin2.out

/home/apps/CENTOS7/amber/amber18/bin/sander -O -i emin3_1tup.in -p ${NAME}.prmtop -c ${NAME}_emin2.rst -r ${NAME}_emin3.rst -ref ${NAME}_emin2.rst -o ${NAME}_emin3.out

/home/apps/CENTOS7/amber/amber18/bin/sander -O -i emin4_1tup.in -p ${NAME}.prmtop -c ${NAME}_emin3.rst -r ${NAME}_emin4.rst -ref ${NAME}_emin3.rst -o ${NAME}_emin4.out

/home/apps/CENTOS7/amber/amber18/bin/sander -O -i emin5_1tup.in -p ${NAME}.prmtop -c ${NAME}_emin4.rst -r ${NAME}_emin5.rst -ref ${NAME}_emin4.rst -o ${NAME}_emin5.out

/home/apps/CENTOS7/amber/amber18/bin/sander -O -i emin6_1tup.in -p ${NAME}.prmtop -c ${NAME}_emin5.rst -r ${NAME}_emin6.rst -ref ${NAME}_emin5.rst -o ${NAME}_emin6.out
