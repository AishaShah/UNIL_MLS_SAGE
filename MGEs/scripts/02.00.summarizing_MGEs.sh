#!/bin/bash

####--------------------------------------
##SLURM options
####--------------------------------------
#SBATCH --job-name 02.00.summarizing_MGEs.411_Genomes 
#SBATCH --account jgianott_sage
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 8
#SBATCH --mem 50G
#SBATCH --time 04:00:00
#SBATCH --output /scratch/jgianott/SAGE/SAGE_2023-2024/ashah1/MGEs/scripts/out/%x_%j_%a.out
#SBATCH --error /scratch/jgianott/SAGE/SAGE_2023-2024/ashah1/MGEs/scripts/err/%x_%j_%a.err


####--------------------------------------
## set variables
####--------------------------------------

echo "---1. Setting variables"
username=ashah1
indir=/scratch/jgianott/SAGE/SAGE_2023-2024/${username}/MGEs/01_genomad.411_genomes
outphage=/scratch/jgianott/SAGE/SAGE_2023-2024/${username}/MGEs/01_genomad.411_genomes/phage_info.txt
outplasmid=/scratch/jgianott/SAGE/SAGE_2023-2024/${username}/MGEs/01_genomad.411_genomes/plasmid_info.txt


for dir in ${indir}/*
do
    #get the name of the the directory as the strain name
    strain=$(basename ${dir})
    echo "Processing ${strain}"
    # go in the directory <xxx> and copy the file <xxx>.tsv in the file ${outplasmid} without the first line
    # if file is empty, copy entire file
    if [ -f ${outplasmid} ]
    then
        echo "File ${outplasmid} exists"
        #tail -n +2 ${dir}/${strain}_summary/${strain}_plasmid_summary.tsv >> ${outplasmid}
	tail -n +2 "${dir}/${strain}_summary/${strain}_plasmid_summary.tsv" | awk -v strain="${strain}" '{print strain "\t" $0}' >> ${outplasmid}
	
    else
        echo "File ${outplasmid} does not exist"
        #cat ${dir}/${strain}_summary/${strain}_plasmid_summary.tsv > ${outplasmid}
	awk -v strain="${strain}" 'NR==1 {print "strain_name\t" $0} NR>1 {print strain "\t" $0}' "${dir}/${strain}_summary/${strain}_plasmid_summary.tsv" > ${outplasmid}
    fi

    # go in the directory strain_summary and copy the file ${strain}_virus_summary.tsv in the file ${outphage} without the first line
    # if file is empty, copy entire file
    if [ -f ${outphage} ]
    then
        echo "File ${outphage} exists"
        #tail -n +2 ${dir}/${strain}_summary/${strain}_virus_summary.tsv >> ${outphage}
	tail -n +2 "${dir}/${strain}_summary/${strain}_virus_summary.tsv" | awk -v strain="${strain}" '{print strain "\t" $0}' >> ${outphage}
    else
        echo "File ${outphage} does not exist"
        #cat ${dir}/${strain}_summary/${strain}_virus_summary.tsv > ${outphage}
	awk -v strain="${strain}" 'NR==1 {print "strain_name\t" $0} NR>1 {print strain "\t" $0}' "${dir}/${strain}_summary/${strain}_virus_summary.tsv" > ${outphage}
    fi
done
