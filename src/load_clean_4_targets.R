#! /usr/bin/env Rscript 
# load_clean_3_targets.R
# Created by Reza, Modified by Iris
#
# This script takes the raw data,
# and combine the qualities into 4 targets: low, med_low, med_high, high.
# The output file is a clean csv file.
#
# Usage: Rscript load_clean_3_targets.R input_file output_file

# load libraries
suppressPackageStartupMessages(library(tidyverse))

# Reading the command line arguments
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_file <- args[2]

# The main function
main <- function(){
  
  # read the dataset
  data <- read.csv(input_file)
  
  #  Combining and categorizing the wine quality to remove the imbalance
  
  # Red wine dataset:
  # The wine qualitis of 3 and 4 will be named "low"
  # The wine qualitis of 5 will be named "med_low"
  # The wine qualitis of 6 will be named "med_high"
  # The wine qualitis of 7 or higher will be named "high"
  
  data <- data %>% mutate(target="med_low")
  data <- data %>%  mutate(target = ifelse(quality == 6, "med_high", target))
  data <- data %>%  mutate(target = ifelse(quality %in% c(3,4), "low", target))
  data <- data %>%  mutate(target = ifelse(quality >= 7, "high", target))
  
  # give the target level order
  data <- data %>% 
    mutate(target = factor(target)) %>% 
    mutate(target = fct_relevel(target, "low", "med_low","med_high", "high"))
  
  # Save the output csv file
  write.csv(data, file=output_file, row.names=FALSE)
  
}

# The main function
main()
