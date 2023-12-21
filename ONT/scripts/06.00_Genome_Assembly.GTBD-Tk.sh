#!/bin/bash

####--------------------------------------
##SLURM options
####--------------------------------------
#SBATCH --job-name 06.00_Genome_Assembly.GTBD-TK
#SBATCH --account jgianott_sage
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --mem 150G
#SBATCH --time 01:00:00
#SBATCH --output /scratch/jgianott/SAGE/SAGE_2023-2024/ashah1/ONT/scripts/out/%x_%j.out
#SBATCH --error /scratch/jgianott/SAGE/SAGE_2023-2024/ashah1/ONT/scripts/err/%x_%j.err




###===========================
##Priming the variables used 
echo -e "-------0. Priming the variables used"
###=========================== 

username=ashah1
sample_name=strain_12
inputfolder=/scratch/jgianott/SAGE/SAGE_2023-2024/${username}/ONT/03_Genome_QC_and_annotation/00_polished_genome
outdir=/scratch/jgianott/SAGE/SAGE_2023-2024/${username}/ONT/03_Genome_QC_and_annotation/01_${sample_name}_GTBD_polished_QC
rm -r ${outdir}
mkdir ${outdir}



####--------------------------------------
##modules
####--------------------------------------

# Activate conda environment - DO NOT MODIFY!
eval "$(conda shell.bash hook)"
conda activate /scratch/jgianott/SAGE/SAGE_2023-2024/dgarrido/GTDB-Tk/GTDB_env


###===========================
## GTBD
echo -e "-------1. First run GTBD"
###===========================

#run GTBD-Tk
gtdbtk classify_wf --genome_dir ${inputfolder} --out_dir ${outdir} --extension fasta --cpus 16

