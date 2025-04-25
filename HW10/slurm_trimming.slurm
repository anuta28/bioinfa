#!/bin/bash
#SBATCH --job-name=trimmomatic
#SBATCH --output=trimming.log
#SBATCH --error=trimming.err
#SBATCH --time=1:30:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --partition=short

export PATH="/opt/conda/bin:$PATH"
source /opt/conda/etc/profile.d/conda.sh

conda activate trimming

TRIMMOMATIC_JAR="/home/arumyantseva/.conda/envs/trimming/share/trimmomatic-0.39-2/trimmomatic.jar"

java -jar $TRIMMOMATIC_JAR PE -threads $SLURM_CPUS_PER_TASK \
  ~/../../projects/mipt_dbmp_biotechnology/genome/illumina_reads_R1_001.fastq \
  ~/../../projects/mipt_dbmp_biotechnology/genome/illumina_reads_R2_001.fastq \
  R1_trimmed.fastq R1_unpaired.fastq \
  R2_trimmed.fastq R2_unpaired.fastq \
  ILLUMINACLIP:~/../../projects/mipt_dbmp_biotechnology/genome/adapters.fa:2:25:8:1:true \
    LEADING:25 \
    TRAILING:25 \
    SLIDINGWINDOW:5:25 \
    MINLEN:75 \
    HEADCROP:10 \
    CROP:140
