# **Annotating phages and plasmids in 411 bacterial genomes**

This repository contains a set of scripts for annotating phages and plasmids in a number of genome sin parallel using gnomAD tool

## **1. Storing Assembly Names**

To store assembly names in a given directory, execute the following command:

`ls "${common_files}/all_student_assemblies/assemblies" > assembly_names.out`

## **2. Running Genome Analysis**

Run the genome analysis using the following script:

`sbatch 01.00.identify_MGEs.sh`

## **3. Merging Files**

Merge files using the summarizing script:


`sbatch 02.00.summarizing_MGEs.sh`

## **4. Concatenating Genome Files**

Concatenate genome files for a specified user and generate an output fasta file. Replace **`username`** with the desired username:

`username=ashah1
indir=/scratch/jgianott/SAGE/SAGE_2023-2024/${username}/MGEs/01_genomad
outfasta=/scratch/jgianott/SAGE/SAGE_2023-2024/${username}/MGEs/01_genomad/all_viruses.fasta
cat ${indir}/*/*_summary/*_virus.fna > ${outfasta}`

## **5. Running for 411 Genomes**

Run the analysis for 411 genomes by listing assembly names and removing the file extension:

`ls "/scratch/jgianott/SAGE/SAGE_2023-2024/common_files/SAGE2_DB/SAGE2_fna" > assembly_names.411_genomes.out
sed 's/\.fna$//' assembly_names.411_genomes.out`

