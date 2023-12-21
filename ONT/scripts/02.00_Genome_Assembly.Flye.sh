#!/bin/bash

####--------------------------------------
##SLURM options
####--------------------------------------
#SBATCH --job-name 02.00_Genome_Assembly.Flye
#SBATCH --account jgianott_sage
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 8
#SBATCH --mem 64G
#SBATCH --time 03:00:00
#SBATCH --output /scratch/jgianott/SAGE/SAGE_2023-2024/ashah1/ONT/scripts/out/%x_%j.out
#SBATCH --error /scratch/jgianott/SAGE/SAGE_2023-2024/ashah1/ONT/scripts/err/%x_%j.err

####--------------------------------------
##preparation
##setting bash variables
####--------------------------------------

username=ashah1
personal_home_directory=/scratch/jgianott/SAGE/SAGE_2023-2024/${username}
sample_name=strain_12

filtered_reads_dir=${personal_home_directory}/ONT/00_Data/filtReads_ONT/
assembly_dir=${personal_home_directory}/ONT/02_assembly_ONT/
rm -r ${assembly_dir}
mkdir -p ${assembly_dir}


GENOME_SIZE=2.5m


####--------------------------------------
# load modules
####--------------------------------------

module load gcc
module load flye

####--------------------------------------
## Assmebling filtered ONT raw reads by flye
echo -e "3. Assmebling filtered ONT raw reads by flye"
####--------------------------------------

flye --nano-raw ${filtered_reads_dir}/${sample_name}_filtered.fastq \
    --genome-size ${GENOME_SIZE} \
    --out-dir ${assembly_dir} \
    --threads 8 \
    --iterations 5







