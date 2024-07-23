#!/bin/bash
#SBATCH --job-name=pangenome
#SBATCH -A fnrdewoody
#SBATCH -t 5-00:00:00
#SBATCH -n 128
#SBATCH -N 1
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

module purge
module load anaconda
conda activate cactus_env
source /home/allen715/cactus/cactus-bin-v2.7.0/venv-cactus-v2.7.0/bin/activate

REF=refp
OUT=/scratch/negishi/allen715/pangenome/forNA2/out
REFDIR=/scratch/negishi/allen715/pangenome/forNA2/ref/
GENOME=GCF_015227805.2_bHirRus1.pri.v3_genomic_renamed

#to run step by step
cactus-minigraph ./jobstore seqfile.txt short-swallow-gfa.gfa --reference $REF --binariesMode local
cactus-graphmap ./jobstore seqfile.txt short-swallow-gfa.gfa short-swallow-paf.paf --outputFasta short-swallow-paf.gfa.fa --reference $REF --binariesMode local --delFilter 10000000 # This option is needed to filter out potentially spurious minigraph-based structural variants based on the developer’s tutorial.
keep_contigs=$(awk '{print $1}' ${REFDIR}/${GENOME}.fasta.fai) #${GENOME}.fna.fai file is the reference genome’s index file.
cactus-graphmap-split ./jobstore seqfile.txt short-swallow-gfa.gfa short-swallow-paf.paf --reference $REF --outDir $OUT --binariesMode local --otherContig contigOther --refContigs $(for i in $keep_contigs; do echo ${i}; done) # These two options are needed to distinguish major contigs from the reference genome and the other ones that are not contained in the reference genome.
cactus-align ./jobstore $OUT/chromfile.txt $OUT/chrom-alignments --batch --pangenome --reference $REF --outVG --maxLen 10000 --binariesMode local
cactus-graphmap-join ./jobstore --vg $OUT/chrom-alignments/*.vg --hal $OUT/chrom-alignments/*.hal --outDir $OUT --outName short-swallow-out --reference $REF --binariesMode local --gbz clip full --gfa --filter 1 --clip 10000 --giraffe clip --vcf --chrom-vg --chrom-og --viz --xg --draw # “--gbz clip full” and “--gfa” options are needed for downstream steps. “--filter 1” and “--clip 10000” options are needed to filter out spurious results (a parameter for “—filter” should be the 10% of the number of total haplotypes in the analysis. So as you are using 12 haplotypes, it should be the integer of “1.2”.). The other output options are not necessary but can be useful for visualization and stat comparison.
