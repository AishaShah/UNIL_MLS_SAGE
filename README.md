# Genome Assembly

This repository contains data, scripts, and analysis results for the research project titled "Complete Genome Sequence of Acetobacteraceae Strain." The project involves the genome sequencing and analysis of a novel Bombella strain isolated from the gut microbiota of Geniotrigona thoracic stingless bees in Tenom, Malaysia.

## MGEs

The MGEs directory contains scripts for identifying and summarizing Mobile Genetic Elements (MGEs).

### Scripts

- `01.00.identify_MGEs.sh`: Script for identifying MGEs.
- `02.00.summarizing_MGEs.sh`: Script for summarizing MGEs.
- `assembly_names.out`: names of input assemblies to run script 01.00 for more than one genome in parallel using arrays.
- `logpipeline`: Directory containing logs for the pipeline.

## ONT

This directory contains scripts and analysis for assembling, polishing and annotating Bacterial genome

### 01_Analysis

- `strain_12_filtered_readLength.png`: PNG file showing read length stats for filtered reads.
- `strain_12_raw_readLength.png`: PNG file showing read length stats for raw reads.

### 02_assembly_ONT

- `graph.png`: PNG file displaying the assembly graph.

### Scripts

- `00.01_CopyFiles.sh`: Script for copying files.
- `00.02_readLength_rawReads.sh`: Script for analyzing raw read lengths.
- `01.00_filtlong.sh`: Script for filtering long reads.
- `02.00_Genome_Assembly.Flye.sh`: Script for genome assembly using Flye.
- `03.00_Genome_Assembly.ONT_Polishing.v2.sh`: Script for ONT polishing.
- `03.01_Genome_Assembly.illumina_Polishing.sh`: Script for Illumina polishing.
- `03.02_Genome_Assembly.Polished.QC.sh`: Script for quality control on polished assembly.
- `03.03_QuickCheck.sh`: Script for quick checks on assembly.
- `04.00_Genome_Assembly.CheckM.sh`: Script for assembly quality check using CheckM.
- `05.00_Genome_Assembly.Annotation_DRAM.sh`: Script for genome annotation using DRAM.
- `06.00_Genome_Assembly.GTBD-Tk.sh`: Script for taxonomy assignment using GTDB-Tk.
- `logpipeline`: Directory containing logs for the entire pipeline.
- `plot_read_length.R`: R script for plotting read length stats (see dir: 01_Analysis)
- `Readme`: Directory containing additional readme files.

