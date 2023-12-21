#!/bin/bash

####--------------------------------------
##SLURM options
####--------------------------------------
#SBATCH --job-name filtlong_rawReads
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
sample_name=strain_12

data_dir=${personal_home_directory}/ONT/00_Data/rawReads_ONT/
analysis_dir=${personal_home_directory}/ONT/01_Analysis/log/
out_dir=${personal_home_directory}/ONT/00_Data/filtReads_ONT/
mkdir -p ${out_dir}


####--------------------------------------
# load modules
####--------------------------------------

source /dcsrsoft/spack/bin/setup_dcsrsoft
module load gcc
module load filtlong


####--------------------------------------
## Filtering raw Reads using filtlong
echo -e "2. Filtering raw Reads using filtlong"
####--------------------------------------
target_bases=400000000
MINIMUM_read_LENGTH=1000
min_mean_q_CHANGED=10
length_weight=10

filtlong -t  ${target_bases} \
      --min_length ${MINIMUM_read_LENGTH} \
      --min_mean_q  ${min_mean_q_CHANGED}\
      --length_weight ${length_weight} \
      ${data_dir}/${sample_name}.fastq.gz  > \
      ${out_dir}/${sample_name}_filtered.fastq

less ${out_dir}/${sample_name}_filtered.fastq | awk '{if(NR%4==2) print length($1)}' > ${analysis_dir}/${sample_name}_filtered_readLength.txt



: '
filtlong -t <keep only the best reads up to this many total bases> \
      --min_length <minimum length threshold> \
      --min_mean_q <minimum mean quality threshold> \
      --length_weight <weight given to the length score> 
'
