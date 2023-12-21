#!/bin/bash

####--------------------------------------
##SLURM options
####--------------------------------------
#SBATCH --job-name 01.00.identify_MGEs 
#SBATCH --account jgianott_sage
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 8
#SBATCH --mem 50G
#SBATCH --time 02:00:00
#SBATCH --array=1-20
#SBATCH --output /scratch/jgianott/SAGE/SAGE_2023-2024/ashah1/MGEs/scripts/out/%x_%j_%a.out
#SBATCH --error /scratch/jgianott/SAGE/SAGE_2023-2024/ashah1/MGEs/scripts/err/%x_%j_%a.err


####--------------------------------------
## set variables
####--------------------------------------

echo "---1. Setting variables"

username=ashah1
common_files=/scratch/jgianott/SAGE/SAGE_2023-2024/common_files
conda_path=${common_files}/conda_envs/genomad
genomad_db=${common_files}/conda_envs/genomad_db
personal_home_directory=/scratch/jgianott/SAGE/SAGE_2023-2024/${username}
assembly_dir=${common_files}/all_student_assemblies/assemblies
assembly_ids=${personal_home_directory}/MGEs/scripts/assembly_names.out
assembly_name=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${assembly_ids})
outdir=${personal_home_directory}/MGEs/01_genomad/${assembly_name}



echo "Creating directory: $outdir"
rm -rf ${outdir}
mkdir -p "$outdir"


####--------------------------------------
## open conda environment
####--------------------------------------

echo "---2. Activating conda environment"

source ~/.bashrc
conda activate ${conda_path}

####--------------------------------------
## run genomad on all assemblies
####--------------------------------------

echo "---3. Running genomad on all assemblies"

input_file=${assembly_dir}/${assembly_name}.fna
genomad end-to-end ${input_file} ${outdir} ${genomad_db}
