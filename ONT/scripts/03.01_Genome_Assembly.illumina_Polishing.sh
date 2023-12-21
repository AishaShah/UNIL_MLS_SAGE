#!/bin/bash

####--------------------------------------
##SLURM options
####--------------------------------------
#SBATCH --job-name 03.01_Genome_Assembly.illumina_Polishing
#SBATCH --account jgianott_sage
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 8
#SBATCH --mem 16G
#SBATCH --time 03:00:00
#SBATCH --output /scratch/jgianott/SAGE/SAGE_2023-2024/ashah1/ONT/scripts/out/%x_%j.out
#SBATCH --error /scratch/jgianott/SAGE/SAGE_2023-2024/ashah1/ONT/scripts/err/%x_%j.err



####--------------------------------------
# load modules
####--------------------------------------

module load gcc
module load bowtie2
module load samtools
module load pilon

###===========================
##Priming the variables used 
echo -e "-------0. Priming the variables used"
###=========================== 

username=ashah1
sample_name=strain_12
sample_nr=12
threads=8

personal_home_directory=/scratch/jgianott/SAGE/SAGE_2023-2024/${username}/ONT
raw_data_directory_illumina=/scratch/jgianott/SAGE/SAGE_2023-2024/common_files/00_RawIllumina/
reference_fasta=${personal_home_directory}/02_assembly_ONT/Polishing_ONT/02_second_Racon_graphmap/assembly/${sample_name}_second_Racon_Assembly.fasta
polishing_outdir=${personal_home_directory}/02_assembly_ONT/Polishing_Illumina
rm -r ${polishing_outdir}



overall_polishing_counter=3


###===========================
##Starting the for-loop
echo -e "-------0. Starting the for-loop"
###===========================  

for Illumina_polishing_counter in $(echo "first second third")
do

echo -e "----"${Illumina_polishing_counter}" round of pilon polishing"

###===========================
##bowtie2 mapping
echo -e "-------1. First we map with bowtie2"
###===========================
mkdir -p $polishing_outdir/0${overall_polishing_counter}_${Illumina_polishing_counter}_pillon_bowtie2/{bowtie2,assembly}

bowtie2-build --quiet $reference_fasta $reference_fasta

bowtie2 -1 ${raw_data_directory_illumina}/${sample_nr}_R1_paired.fastq.gz \
        -2 ${raw_data_directory_illumina}/${sample_nr}_R2_paired.fastq.gz \
        -x  $reference_fasta \
        --threads ${threads} \
        --local --very-sensitive-local | samtools sort -O BAM -o $polishing_outdir/0${overall_polishing_counter}_${Illumina_polishing_counter}_pillon_bowtie2/bowtie2/${Illumina_polishing_counter}_pillon_ONT2FinalAssembly_sorted.bam -

###--------------------
##index bam file
###--------------------
samtools index $polishing_outdir/0${overall_polishing_counter}_${Illumina_polishing_counter}_pillon_bowtie2/bowtie2/${Illumina_polishing_counter}_pillon_ONT2FinalAssembly_sorted.bam

###===========================
##pilon polishing
echo -e "-------2. Second polish with pilon"
###===========================

pilon --threads ${threads} --genome $reference_fasta \
  --frags $polishing_outdir/0${overall_polishing_counter}_${Illumina_polishing_counter}_pillon_bowtie2/bowtie2/${Illumina_polishing_counter}_pillon_ONT2FinalAssembly_sorted.bam \
  --output ${sample_name}_${Illumina_polishing_counter}_Pilon_Assembly \
  --outdir $polishing_outdir/0${overall_polishing_counter}_${Illumina_polishing_counter}_pillon_bowtie2/assembly/ \
  --changes

###===========================
##reset the parameters
echo -e "-------3. Resetting the parameters"
###===========================

reference_fasta=$(echo $polishing_outdir/0${overall_polishing_counter}_${Illumina_polishing_counter}_pillon_bowtie2/assembly/${sample_name}_${Illumina_polishing_counter}_Pilon_Assembly.fasta)
echo $reference_fasta
overall_polishing_counter=$((overall_polishing_counter+1))

done #polishing round

