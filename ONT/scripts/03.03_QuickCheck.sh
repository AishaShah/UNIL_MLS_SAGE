#!/bin/bash

####--------------------------------------
##SLURM options
####--------------------------------------
#SBATCH --job-name 03.03_QuickCheck
#SBATCH --account jgianott_sage
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 8
#SBATCH --mem 8G
#SBATCH --time 01:00:00
#SBATCH --output /scratch/jgianott/SAGE/SAGE_2023-2024/ashah1/ONT/scripts/out/%x_%j.out
#SBATCH --error /scratch/jgianott/SAGE/SAGE_2023-2024/ashah1/ONT/scripts/err/%x_%j.err




###===========================
##Priming the variables used 
echo -e "-------0. Priming the variables used"
###=========================== 

username=ashah1
sample_name=strain_12
strain_nr=12
threads=8

personal_home_directory=/scratch/jgianott/SAGE/SAGE_2023-2024/${username}/ONT



####--------------------------------------
##modules
####--------------------------------------

module load gcc
module load samtools

###===========================
##calculating depth of the coverage at every location
echo -e "-------1. calculating depth of the coverage at every location"
###===========================   

samtools depth -a ${personal_home_directory}/02_assembly_ONT/Polishing_Illumina/04_second_pillon_bowtie2/bowtie2/second_pillon_ONT2FinalAssembly_sorted.bam > ${personal_home_directory}/01_Analysis/log/mapping/${sample_name}_Read_mapping_per_base.txt

