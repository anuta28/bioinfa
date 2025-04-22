#!/bin/bash
#SBATCH --job-name=fastqc_analysis
#SBATCH --output=fastqc_%j.log
#SBATCH --error=fastqc_%j.err
#SBATCH --time=01:00:00
#SBATCH --mem=2G
#SBATCH --cpus-per-task=2
#SBATCH --partition=short

exec 2> >(tee -a debug.log)  
set -x   

echo " STARTING JOB "
echo "Job ID: $SLURM_JOB_ID"
echo "Node: $(hostname)"
echo "Date: $(date)"
echo "Working dir: $(pwd)"

export PATH="/path/to/fastqc:/path/to/multiqc:$PATH"

echo -e "\n TOOL CHECK "
command -v fastqc >/dev/null || { echo "FastQC not found!"; exit 1; }
command -v multiqc >/dev/null || { echo "MultiQC not found!"; exit 1; }
fastqc --version || exit 1
multiqc --version || exit 1

INPUT_DIR="raw_data"
FASTQC_DIR="fastqc_results"
MULTIQC_DIR="multiqc_results"

file_count=$(ls -1 "$INPUT_DIR"/*.fastq.gz 2>/dev/null | wc -l)

echo "Found $file_count input files"
ls -lh "$INPUT_DIR"/*.fastq.gz || exit 1

echo -e "\n RUNNING FASTQC "
mkdir -p "$FASTQC_DIR" || exit 1

fastqc \
    -o "$FASTQC_DIR" \
    -t "$SLURM_CPUS_PER_TASK" \
    --noextract \
    "$INPUT_DIR"/*.fastq.gz || {
    echo "ERROR: FastQC failed"
    exit 1
}

echo -e "\n RUNNING MULTIQC "
mkdir -p "$MULTIQC_DIR" || exit 1

multiqc \
    -o "$MULTIQC_DIR" \
    --force \
    --title "PRJEB84057_Analysis" \
    "$FASTQC_DIR" || {
    echo "ERROR: MultiQC failed"
    exit 1
}

echo -e "\n JOB COMPLETED "
echo "Date: $(date)"
echo "FastQC results:"
ls -lh "$FASTQC_DIR" || echo "No FastQC results"
echo -e "\nMultiQC report:"
ls -lh "$MULTIQC_DIR" || echo "No MultiQC results"

touch "JOB_SUCCESS_$SLURM_JOB_ID" || echo "Warning: could not create success marker"

exit 0
