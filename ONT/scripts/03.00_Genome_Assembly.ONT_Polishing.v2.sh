#!/bin/bash

####--------------------------------------
##SLURM options
####--------------------------------------
#SBATCH --job-name 03.00_Genome_Assembly.ONT_Polishing
#SBATCH --account jgianott_sage
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 8
#SBATCH --mem 16G
#SBATCH --time 03:00:00
#SBATCH --output /scratch/jgianott/SAGE/SAGE_2023-2024/ashah1/ONT/scripts/out/%x_%j.out
#SBATCH --error /scratch/jgianott/SAGE/SAGE_2023-2024/ashah1/ONT/scripts/err/%x_%j.err




###===========================
##Priming the variables used 
echo -e "-------0. Priming the variables used"
###=========================== 

username=ashah1
sample_name=strain_12


personal_home_directory=/scratch/jgianott/SAGE/SAGE_2023-2024/${username}/ONT
Overall_output_directory=${personal_home_directory}/02_assembly_ONT/Polishing_ONT/
reference_fasta=${personal_home_directory}/02_assembly_ONT/assembly.fasta
filtered_ONT_reads_dir=${personal_home_directory}/00_Data/filtReads_ONT
ont_reads=${filtered_ONT_reads_dir}/${sample_name}_filtered.fastq


####--------------------------------------
##modules
####--------------------------------------
module load gcc
module load graphmap
module load racon

###===========================
##Priming the variables used and starting the for-loop
echo -e "-------0. Priming the variables used and starting the for-loop"
###===========================

overall_polishing_counter=1
rm -r ${Overall_output_directory}

for ONT_polishing_counter in $(echo "first second")
do
echo -e "----"${ONT_polishing_counter}" round of Racon polishing"

###===========================
##graphmap mapping
echo -e "-------1. First we map with graphmap"
###===========================

##only run this line if you do not have a fastq file yet.

mkdir -p $Overall_output_directory/0${overall_polishing_counter}_${ONT_polishing_counter}_Racon_graphmap/{Graphmap_ONT,assembly}

graphmap align --rebuild-index \
        --circular  \
        -r $reference_fasta \
        -d $ont_reads \
        -o $Overall_output_directory/0${overall_polishing_counter}_${ONT_polishing_counter}_Racon_graphmap/Graphmap_ONT/${ONT_polishing_counter}_Racon_ONT2FinalAssembly_sorted.sam

###===========================
##racon polishing
echo -e "-------2. Second polish with Racon"
###===========================

racon $ont_reads  \
$Overall_output_directory/0${overall_polishing_counter}_${ONT_polishing_counter}_Racon_graphmap/Graphmap_ONT/${ONT_polishing_counter}_Racon_ONT2FinalAssembly_sorted.sam  \
$reference_fasta \
>  $Overall_output_directory/0${overall_polishing_counter}_${ONT_polishing_counter}_Racon_graphmap/assembly/${sample_name}_${ONT_polishing_counter}_Racon_Assembly.fasta

###===========================
##reset the parameters
echo -e "-------3. Resetting the parameters"
###===========================

reference_fasta=$(echo $Overall_output_directory/0${overall_polishing_counter}_${ONT_polishing_counter}_Racon_graphmap/assembly/${sample_name}_${ONT_polishing_counter}_Racon_Assembly.fasta)
overall_polishing_counter=$((overall_polishing_counter+1))

done #polishing round
