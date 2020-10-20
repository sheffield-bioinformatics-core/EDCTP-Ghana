#!/bin/bash

# 1st list the available data directories

let i=0 # define counting variable
W=() # define working array
while read -r line; do # process file by file
    let i=$i+1
    W+=($i "$line")
done < <( ls -ld /data/*/ | cut -f3 -d"/" )
FILE=$(dialog --title "SARSCOV2 Sequencing Runs" --menu "Choose a MinION Run" 24 80 17 "${W[@]}" 3>&2 2>&1 1>&3) # show dialog and store output
clear
if [ $? -eq 0 ]; then # Exit with OK
    RUN_FOLDER=$(ls -1d /data/*/ | sed -n "`echo "$FILE p" | sed 's/ //'`")
    USER_RUN_NAME=`echo ${RUN_FOLDER} | cut -f3 -d"/"`
fi

# now data directory has been chosen show dialog to enter samples and barcodes

BACKTITLE="Some backtitle"
FILENAME="filename.txt"
echo $RUN_FOLDER
NANOPORE_FOLDER=`ls -d ${RUN_FOLDER}*/*/`
echo ${NANOPORE_FOLDER}
NANOPORE_NAME=`echo ${NANOPORE_FOLDER} | cut -f5 -d"/"`
echo ${NANOPORE_NAME}
ANALYSIS_FOLDER="/analysis/${NANOPORE_NAME}"
echo ${ANALYSIS_FOLDER}

mkdir $ANALYSIS_FOLDER


INPUT="$ANALYSIS_FOLDER/samples.csv"

touch INPUT

ret=0

dialog --title "Enter Sample Names and Barcodes for ${USER_RUN_NAME}" --editbox $FILENAME 100 60 2> "${INPUT}"

ret=$?
option=$(<"${INPUT}")


cd $ANALYSIS_FOLDER

conda activate sarscov2

snakemake --config user_run_name=${USER_RUN_NAME} --snakefile ~/wc/EDCTP-Ghana/workflow/Snakefile --rerun-incomplete --use-conda --jobs 30 --latency-wait 120 --verbose --printshellcmds --stats snakemake_stats.json all --cluster 'qsub -V'