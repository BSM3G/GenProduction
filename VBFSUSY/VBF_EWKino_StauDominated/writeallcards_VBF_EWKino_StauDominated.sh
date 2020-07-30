#!/bin/sh
JOBS="jobs"
TEMP="templatecards"
PROC="VBF_EWKino_StauDominated"
PARTN2="_mN2-"
PARTN1="_mN1-"
PARTST="_mStau-"

#VBF_EWKino_StauDominated_mN2-%MN2%_mStau-%MNLSP%_mN1-%MN1%

### Create cards and SLHAs for all mass points

for MN2 in 100 125 150 175 200 225 250 275 300 325 350 375 400; do
#for MN2 in 250; do
#for MN2 in 120; do
    #for DM in 7.5 10 15 20 30 40; do
    #for DM in 50; do
    for DM in 1 5 10 15 20 30 40 50 60 75; do
	MN1=`awk "BEGIN {printf \"%.2f\n\", (${MN2}-${DM})}"`	
	MNLSP=`awk "BEGIN {printf \"%.2f\n\", ((${MN1}+${MN2})/2)}"`
	MN2STR=${MN2/./p}
	MN1STR=${MN1/./p}
	MC1STR=${MN2/./p}
	MSTSTR=${MNLSP/./p}
	MODEL=${PROC}${PARTN2}${MN2STR}${PARTST}${MSTSTR}${PARTN1}${MN1STR}
	mkdir -p "${JOBS}/${MODEL}"
	cp ${TEMP}/${PROC}_run_card.dat "${JOBS}/${MODEL}/${MODEL}_run_card.dat"
	sed "s/%MN2%/${MN2STR}/g;s/%MNLSP%/${MSTSTR}/g;s/%MN1%/${MN1STR}/g" ${TEMP}/${PROC}_proc_card.dat > "${JOBS}/${MODEL}/${MODEL}_proc_card.dat"
	sed "s/%MN2%/${MN2}/g;s/%MN1%/${MN1}/g;s/%MC1%/${MN2}/g;s/%MNLSP%/${MNLSP}/g" ${TEMP}/${PROC}_customizecards.dat > "${JOBS}/${MODEL}/${MODEL}_customizecards.dat"
	sed "s/%MN2%/${MN2}/g;s/%MN1%/${MN1}/g;s/%MC1%/${MN2}/g;s/%MNLSP%/${MNLSP}/g" ${TEMP}/${PROC}.slha > ${JOBS}/${MODEL}/${MODEL}.slha
	#sed "s/%MN2%/${MN2}/g;s/%MN1%/${MN1}/g;s/%MC1%/${MN2}/g;s/%MNLSP%/${MNLSP}/g" ${TEMP}/${PROC}_param_card.dat > ${JOBS}/${MODEL}/${MODEL}_param_card.dat
    done
done
