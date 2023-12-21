#!/bin/bash

####--------------------------------------
##SLURM options
####--------------------------------------
#SBATCH --job-name 05.00_Genome_Assembly.Annotation_DRAM
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
strain_nr=12
threads=8
infile=/scratch/jgianott/SAGE/SAGE_2023-2024/${username}/ONT/03_Genome_QC_and_annotation/00_polished_genome/${sample_name}_polished_contigs.fasta
checkm_stats=/scratch/jgianott/SAGE/SAGE_2023-2024/${username}/ONT/03_Genome_QC_and_annotation/01_${sample_name}_checkm_polished_QC/${sample_name}_checkm_polished_QC_stats.tsv
outdir=/scratch/jgianott/SAGE/SAGE_2023-2024/${username}/ONT/03_Genome_QC_and_annotation/02_${sample_name}_DRAM
rm -r ${outdir}



####--------------------------------------
##modules
####--------------------------------------

# Activate conda environment - DO NOT MODIFY!
eval "$(conda shell.bash hook)"
conda activate /scratch/jgianott/SAGE/SAGE_2023-2024/dgarrido/DRAM/DRAM_env


###===========================
## DRAM
echo -e "-------2. Annotating Genome"
###===========================

#Execute DRAM
DRAM.py annotate -i ${infile} -o ${outdir} --checkm_quality ${checkm_stats} --threads 16
DRAM.py distill -i ${outdir}/annotations.tsv -o ${outdir}/distill --trna_path ${outdir}/trnas.tsv --rrna_path ${outdir}/rrnas.tsv


