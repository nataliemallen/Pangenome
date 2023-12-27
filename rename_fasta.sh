#renames headings of SRR fasta files

#SBATCH --job-name=pangenome
#SBATCH -A fnrdewoody
#SBATCH -t 2-00:00:00
#SBATCH -n 128
#SBATCH -N 1
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

# Array of specific fasta file paths
files=("/scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588214/alternate/SRR22588214_alternate_purged.fasta" "/scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588214/primary/SRR22588214_primary_purged.fasta" "/scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588215/alternate/SRR22588215_alternate_purged.fasta" "/scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588215/primary/SRR22588215_primary_purged.fasta" "/scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588216/alternate/SRR22588216_alternate_purged.fasta" "/scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588216/primary/SRR22588216_primary_purged.fasta" "/scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588217/alternate/SRR22588217_alternate_purged.fasta" "/scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588217/primary/SRR22588217_primary_purged.fasta" "/scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588218/alternate/SRR22588218_alternate_purged.fasta" "/scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588218/primary/SRR22588218_primary_purged.fasta")

# Loop through the array of files
for file_path in "${files[@]}"; do
    # Check if the fasta file exists
    if [ -e "$file_path" ]; then
        # Create a temporary file to store the modified content
        temp_file="${file_path}.tmp"

        # Counter for contig renaming
        count=1

        # Read the original fasta file and modify contig names
        while IFS= read -r line; do
            # Check if the line starts with ">"
            if [[ $line == ">"* ]]; then
                # Rename the contig according to the specified convention
                echo ">A1_pri$count" >> "$temp_file"
                ((count++))
            else
                # Keep other lines unchanged
                echo "$line" >> "$temp_file"
            fi
        done < "$file_path"

        # Replace the original file with the modified content
        mv "$temp_file" "$file_path"

        echo "Contigs in $file_path renamed successfully."
    else
        echo "Fasta file $file_path not found."
    fi
done
