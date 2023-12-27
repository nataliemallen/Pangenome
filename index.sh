#index reference genomes 

#!/bin/bash
#SBATCH --job-name=swallow_calling
#SBATCH -A fnrdewoody
#SBATCH -t 5-00:00:00
#SBATCH -n 128
#SBATCH -N 1
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

module load biocontainers
module load samtools

cd /scratch/negishi/allen715/pangenome/forNA2/ref/

samtools faidx GCF_015227805.2_bHirRus1.pri.v3_genomic_renamed.fasta

samtools faidx GCA_015227815.3_bHirRus1.alt.v3_genomic_renamed.fasta
