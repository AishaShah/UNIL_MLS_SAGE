#!/bin/bash

####--------------------------------------
##SLURM options
####--------------------------------------
#SBATCH --job-name readLength_rawReads
#SBATCH --account jgianott_sage
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 2
#SBATCH --mem 6G
#SBATCH --time 1:00:00
#SBATCH --output /scratch/jgianott/SAGE/SAGE_2023-2024/ashah1/ONT/scripts/out/%x_%j.out
#SBATCH --error /scratch/jgianott/SAGE/SAGE_2023-2024/ashah1/ONT/scripts/err/%x_%j.err

####--------------------------------------
##preparation
##setting bash variables
####--------------------------------------

username=ashah1
personal_home_directory=/scratch/jgianott/SAGE/SAGE_2023-2024/${username}
raw_data_directory=/scratch/jgianott/SAGE/SAGE_2023-2024/common_files/raw_ONT_data
sample_name=strain_12

####--------------------------------------
#Copying file
####--------------------------------------

data_dir=${personal_home_directory}/ONT/00_Data/rawReads_ONT/
analysis_dir=${personal_home_directory}/ONT/01_Analysis/log/
mkdir -p ${analysis_dir}

####--------------------------------------
##Calculate raw read statistics
echo -e "1. First calculate the read length"
####--------------------------------------
##each read length
less ${data_dir}/${sample_name}.fastq.gz | awk '{if(NR%4==2) print length($1)}' > ${analysis_dir}/${sample_name}_raw_readLength.txt

