#!/bin/bash -e

#SBATCH --account       [project number]
#SBATCH --job-name      cutadapt
#SBATCH --time          1-00:00:00
#SBATCH --mem           10GB
#SBATCH --cpus-per-task 2
#SBATCH --error         %x_%A_%a.err
#SBATCH --output        %x_%A_%a.out

# Working directory
cd [set working directory]
#mkdir trimmed_reads

module purge
module load cutadapt/4.4-gimkl-2022a-Python-3.11.3

## Define reverse primer (5'→3') and its reverse complement
REVPRIMER="TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG"
REVCOMP="CTGTCTCTTATACACATCTCCGAGCCCACGAGAC"   

# Loop over all R1 files
for R1 in *_R1.fastq.gz
do
    R2=${R1/_R1/_R2}

    OUT_R1=trimmed_reads/$(basename ${R1%.fastq.gz}.trimmed.fastq.gz)
    OUT_R2=trimmed_reads/$(basename ${R2%.fastq.gz}.trimmed.fastq.gz)

    echo "Trimming $R1 and $R2..."

    cutadapt \
        -A ${REVPRIMER}... \
        -A ${REVCOMP}... \
        -o $OUT_R1 \
        -p $OUT_R2 \
        $R1 $R2
done

