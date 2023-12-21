#!/bin/bash

####--------------------------------------
##SLURM options
####--------------------------------------
#SBATCH --job-name 03.02_Genome_Assembly.Polished.QC
#SBATCH --account jgianott_sage
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 8
#SBATCH --mem 8G
#SBATCH --time 04:00:00
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
module load mummer
module load samtools

###===========================
##Quast
echo -e "-------1. First run Quast"
###===========================

rm -r ${personal_home_directory}/01_Analysis/log/quast_after_polishing/
mkdir -p ${personal_home_directory}/01_Analysis/log/quast_after_polishing/

python3.6 /software/UHTS/Quality_control/quast/4.6.0/bin/quast.py \
      -l "FlyeAssembly,first_ONT_racon,second_ONT_racon,first_Illumina_pilon,second_Illumina_pilon" \
      -R ${personal_home_directory}/02_assembly_ONT/Polishing_Illumina/05_third_pillon_bowtie2/assembly/${sample_name}_third_Pilon_Assembly.fasta \
      ${personal_home_directory}/02_assembly_ONT/assembly.fasta \
      ${personal_home_directory}/02_assembly_ONT/Polishing_ONT/01_first_Racon_graphmap/assembly/${sample_name}_first_Racon_Assembly.fasta \
      ${personal_home_directory}/02_assembly_ONT/Polishing_ONT/02_second_Racon_graphmap/assembly/${sample_name}_second_Racon_Assembly.fasta \
      ${personal_home_directory}/02_assembly_ONT/Polishing_Illumina/03_first_pillon_bowtie2/assembly/${sample_name}_first_Pilon_Assembly.fasta \
      ${personal_home_directory}/02_assembly_ONT/Polishing_Illumina/04_second_pillon_bowtie2/assembly/${sample_name}_second_Pilon_Assembly.fasta \
      -o  ${personal_home_directory}/01_Analysis/log/quast_after_polishing/

###===========================
##check mapping
echo -e "-------2. Second check mapping"
###===========================
rm -r ${personal_home_directory}/01_Analysis/log/mapping
mkdir -p ${personal_home_directory}/01_Analysis/log/mapping

samtools flagstat ${personal_home_directory}/02_assembly_ONT/Polishing_Illumina/04_second_pillon_bowtie2/bowtie2/second_pillon_ONT2FinalAssembly_sorted.bam >  ${personal_home_directory}/01_Analysis/log/mapping/${sample_name}_mapping.txt


