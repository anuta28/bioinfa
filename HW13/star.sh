#!/bin/bash
#SBATCH --job-name=star       
#SBATCH --output=star.log     
#SBATCH --error=star.err      
#SBATCH --time=02:00:00                
#SBATCH --cpus-per-task=8               
#SBATCH --mem=48G                        
#SBATCH --partition=short  

source ~/miniconda3/etc/profile.d/conda.sh
conda activate star

STAR --genomeDir /projects/mipt_dbmp_biotechnology/GRCh38/ \
--readFilesIn trimmed_R1.fastq trimmed_R2.fastq \
--runThreadN 8 \
--outFileNamePrefix star_output/ \
--outSAMtype BAM SortedByCoordinate \
--quantMode GeneCounts
