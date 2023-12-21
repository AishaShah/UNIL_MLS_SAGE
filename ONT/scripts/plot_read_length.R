
## Install and load required packages
required_packages <- c("ggplot2", "readr", "dplyr", "patchwork", "optparse")

# Check if packages are not installed, then install
for (package in required_packages) {
  if (!requireNamespace(package, quietly = TRUE)) {
    install.packages(package)
  }
}


## ---------------------------
## Loading Libraries
## ---------------------------

library(ggplot2)
library(readr)
library(dplyr)
library(patchwork)
library(optparse)

## ---------------------------
## Command Line Option Parsing
## ---------------------------


option_list = list(
  make_option(c("-i", "--input"), type="character", default=NULL, help="Input file path for rawdata_readLength"),
  make_option(c("-o", "--output"), type="character", default=NULL, help="Output file path for the plot"),
  make_option(c("-n", "--name"), type="character", default="output_plot.png", help="Output file name for the plot"),
  make_option(c("-t", "--title"), type="character", default=NULL, help="Title for the plot")
)

opt_parser = OptionParser(usage="Usage: %prog [options]", option_list=option_list)
opt = parse_args(opt_parser)

if (is.null(opt$input) | opt$help) {
  cat("Usage: Rscript script_name.R -i input_file_path [-o output_path] [-n output_file_name]\n")
  cat("Options:\n")
  print(opt_parser)
  quit()
}

## ---------------------------
## Input File and variables
## ---------------------------

rawdata_readLength <- read_csv(opt$input, col_names = "read_length") %>%
  arrange(., read_length)

# Set the desired width and height for figure
width <- 9
height <- 5
plot_title <- ifelse(!is.null(opt$title), opt$title, "Read distribution for strain 12")
out_file_name = ifelse(!is.null(opt$output), paste0(opt$output, "/", opt$name), opt$name)
output = paste0(out_file_name)


## --------------------------
## Plot Caption
##---------------------------


sample_name="strain_12" 
genome_size= 2103190 #Expected by illumina assembly
expected_genome_coverage=50
bases_needed <- genome_size*expected_genome_coverage

##-------------------------1.01. Calculations

number_reads <- nrow(rawdata_readLength)
mean_read <- round(mean(rawdata_readLength$read_length),digits = 0)
longest_read <- max(rawdata_readLength$read_length)
shortest_read <- min(rawdata_readLength$read_length)


## ------------------------1.02 Here we calculate the which amount half of the sequencing output is 
rawdata_readLength$Cumsum_forward <- cumsum(rawdata_readLength$read_length)
rawdata_readLength$Cumsum_reverse <- max(rawdata_readLength$Cumsum_forward) - cumsum(rawdata_readLength$read_length)

Full_sequencing_Output <- max(rawdata_readLength$Cumsum_forward)
Half_sequencing_output <- max(rawdata_readLength$Cumsum_forward)/2

##-------------------------1.03. total sequenced bases
bases_sequenced=max(rawdata_readLength$Cumsum_forward)


caption_01=paste0("Number of reads : ",number_reads,
                  "\nMean read length: ",mean_read,
                  "\nMax read length : ",longest_read,
                  "\nMin read length : ",shortest_read,
                  "\nTotal number of sequenced bases: ", Full_sequencing_Output,
                  "\nN50 (Half of Total number of sequenced bases): ", Half_sequencing_output,
                  "\nThe total number of sequenced bases: ",bases_sequenced,
                  "\nThe total number of bases needed for ",expected_genome_coverage,"x coverage of a ",genome_size," bp genome are  ",bases_needed,"\n")

cat(paste0("Strain_12\n",caption_01))


## ---------------------------
## Plotting data
## ---------------------------

# Read distribution histogram
# Calculating N50

# The N50 value is the length for which the cumulative size of all 
# sequences of that length or longer represents at least 50% of the 
# total size of all sequences.

##-------------------------2. Histogram

histoPlot_01 <- ggplot(rawdata_readLength,aes(x=read_length))+
  geom_histogram(binwidth = 500)+theme_classic()+
  geom_vline(xintercept = 5000,color="blue")+
  lims(x=c(-250,longest_read))  +
  annotate("text", x = 15500, y = Inf, vjust = 5, label = "rRNA length", color = "blue") 

##-------------------------3. Here we plot the histogram and the cumulative summary

cumSumPlot_01 <- ggplot(rawdata_readLength,aes(x=read_length,y=Cumsum_forward))+
  geom_point()+theme_classic()+
  geom_vline(xintercept = 5000,color="blue")+
  geom_hline(yintercept = Half_sequencing_output,color="red")+
  labs(y="Cummulative read length")+
  lims(x=c(-250,longest_read))


combined_plot <- (histoPlot_01 | cumSumPlot_01) + 
  plot_annotation(title=plot_title,
                  caption=caption_01, 
                  tag_levels = 'A') 

# Save the plot to a PNG file
ggsave(output, combined_plot, width = width, height = height)

