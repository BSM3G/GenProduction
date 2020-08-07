#!/bin/sh
JOBS="jobs"
TEMP="templatecards"
PROC="VBF_ADM"
PARTN1="_mN1-"
PARTLAMBDA="_mLAMBDA-"

#VBF_ADM_mN1-%MN1%_mLAMBDA-%MLAMBDA%

### Create cards and SLHAs for all mass points

for MN1 in 0.1 1 10 50 100 200 300 400 500 750 1000; do
#for MN2 in 250; do
#for MN2 in 120; do
    #for DM in 7.5 10 15 20 30 40; do
    #for DM in 50; do
    for MLAMBDA in 500 750 1000 1250 1500 1750 2000; do
	MN1STR=${MN1/./p}
	MLAMBDASTR=${MLAMBDA/./p}
        MODEL=${PROC}${PARTN1}${MN1STR}${PARTLAMBDA}${MLAMBDASTR}
	mkdir -p "${JOBS}/${MODEL}"
	cp ${TEMP}/${PROC}_run_card.dat "${JOBS}/${MODEL}/${MODEL}_run_card.dat"
	sed "s/%MN1%/${MN1STR}/g;s/%MLAMBDA%/${MLAMBDASTR}/g" ${TEMP}/${PROC}_proc_card.dat > "${JOBS}/${MODEL}/${MODEL}_proc_card.dat"
	sed "s/%MN1%/${MN1}/g;s/%MLAMBDA%/${MLAMBDA}/g" ${TEMP}/${PROC}_customizecards.dat > "${JOBS}/${MODEL}/${MODEL}_customizecards.dat"
	sed "s/%MN1%/${MN1}/g;s/%MLAMBDA%/${MLAMBDA}/g" ${TEMP}/${PROC}.slha > ${JOBS}/${MODEL}/${MODEL}.slha
	sed "s/%MN1%/${MN1}/g;s/%MLAMBDA%/${MLAMBDA}/g" ${TEMP}/${PROC}_param_card.dat > ${JOBS}/${MODEL}/${MODEL}_param_card.dat
    done
done
