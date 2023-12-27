!/bin/bash
#SBATCH --job-name=swallow_calling
#SBATCH -A fnrdewoody
#SBATCH -t 10:00:00
#SBATCH -n 128
#SBATCH -N 1
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

#renames fasta headings of reference files. primary should be "chr", alt should be "contig" (must change in script)

cd /scratch/negishi/allen715/pangenome/forNA2/ref/

# Define input file
genome_file="GCA_015227815.3_bHirRus1.alt.v3_genomic.fna" 
# Define output file
genome_output="GCA_015227815.3_bHirRus1.alt.v3_genomic_renamed.fasta" 

# Function to rename chromosomes in a genome file
rename_chromosomes() {
    input_file=$1
    output_file=$2

    # Use awk to rename chromosomes
    awk '/^>/{print ">contig" ++i; next}{print}' < "$input_file" > "$output_file"
}

# Rename chromosomes in the genome
rename_chromosomes "$genome_file" "$genome_output"

echo "Chromosome renaming completed. Check $genome_output"
