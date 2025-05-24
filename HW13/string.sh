#!/bin/bash
#SBATCH --job-name=stringtie      
#SBATCH --output=stringtie.log     
#SBATCH --error=stringtie.err      
#SBATCH --time=02:00:00                 
#SBATCH --cpus-per-task=8               
#SBATCH --mem=48G                      
#SBATCH --partition=short            

source ~/miniconda3/etc/profile.d/conda.sh
conda activate stringtie
mkdir results_stringtie
stringtie Aligned.sortedByCoord.out.bam \
-G /projects/mipt_dbmp_biotechnology/GRCh38/Homo_sapiens.GRCh38.110.chr.gtf \
-o results_stringtie/transcripts.gtf \
-p 8

