#!/bin/bash

####--------------------------------------
##SLURM options
####--------------------------------------
#SBATCH --job-name 04.00_Genome_Assembly.CheckM
#SBATCH --account jgianott_sage
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 14
#SBATCH --mem 100G
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
inputfolder=/scratch/jgianott/SAGE/SAGE_2023-2024/${username}/ONT/03_Genome_QC_and_annotation/00_polished_genome
outdir=/scratch/jgianott/SAGE/SAGE_2023-2024/${username}/ONT/03_Genome_QC_and_annotation/01_${sample_name}_checkm_polished_QC
rm -r ${outdir}
mkdir ${outdir}
outfile=${outdir}/${sample_name}_checkm_polished_QC_stats.tsv



####--------------------------------------
##modules
####--------------------------------------

# Activate conda environment - DO NOT MODIFY!
eval "$(conda shell.bash hook)"
conda activate /scratch/jgianott/SAGE/SAGE_2023-2024/dgarrido/checkM/checkM_env

###===========================
##CheckM
echo -e "-------1. First run CheckM"
###===========================

#set CheckM data path:
checkm data setRoot /scratch/jgianott/SAGE/SAGE_2023-2024/dgarrido/checkM/checkM_data #DO NOT MODIFY!

#run CheckM
checkm lineage_wf ${inputfolder} ${outdir} -x fasta -t 16
checkm qa ${outdir}/lineage.ms ${outdir} -o 2 -f ${outfile} --tab_table

#generate plots
checkm marker_plot ${outdir} ${inputfolder} ${outdir}/plots -x fasta
checkm gc_plot ${inputfolder} ${outdir}/plots 95 -x fasta
checkm coding_plot ${outdir} ${inputfolder} ${outdir}/plots 95 -x fasta
checkm nx_plot ${inputfolder} ${outdir}/plots -x fasta


