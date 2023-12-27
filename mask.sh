# masks SRR genome files

#!/bin/bash
#SBATCH --job-name=mask
#SBATCH -A fnrdewoody
#SBATCH -t 5-00:00:00
#SBATCH -n 128
#SBATCH -N 1
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

module purge
module load biocontainers
module load repeatmasker
module load bedtools
export PATH=$PATH:/home/allen715/winmasker/ncbi_cxx--25_2_0/GCC850-ReleaseMT64/bin/

#214 primary
cd /scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588214/primary/

#windowmasker
#windowmasker -mk_counts -in SRR22588214_primary_purged.fasta -out stage1_SRR22588214_primary.counts
#windowmasker -ustat stage1_SRR22588214_primary.counts -in SRR22588214_primary_purged.fasta -outfmt fasta -out SRR22588214_primary_purged_winmask.fasta

#repeatmasker
#RepeatMasker -pa 32 -xsmall -species aves SRR22588214_primary_purged.fasta -dir .

awk 'BEGIN{OFS="\t"} {if($1 !~ /^#/) print $5, $6-1, $7, $11, $0}' SRR22588214_primary_purged.fasta.out | tail -n +4 > output.bed

##bedtools
bedtools maskfasta -soft -fi SRR22588214_primary_purged_winmask.fasta -bed output.bed -fo SRR22588214_primary_purged_masked.fasta

#214 alternate
cd /scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588214/alternate/

#windowmasker
#windowmasker -mk_counts -in SRR22588214_alternate_purged.fasta -out stage1_SRR22588214_alternate.counts
#windowmasker -ustat stage1_SRR22588214_alternate.counts -in SRR22588214_alternate_purged.fasta -outfmt fasta -out SRR22588214_alternate_purged_winmask.fasta

#repeatmasker
#RepeatMasker -pa 32 -xsmall -species aves SRR22588214_alternate_purged.fasta -dir .

awk 'BEGIN{OFS="\t"} {if($1 !~ /^#/) print $5, $6-1, $7, $11, $0}' SRR22588214_alternate_purged.fasta.out | tail -n +4 > output.bed

##bedtools
bedtools maskfasta -soft -fi SRR22588214_alternate_purged_winmask.fasta -bed output.bed -fo SRR22588214_alternate_purged_masked.fasta

########

#215 primary
cd /scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588215/primary/

#windowmasker
#windowmasker -mk_counts -in SRR22588215_primary_purged.fasta -out stage1_SRR22588215_primary.counts
#windowmasker -ustat stage1_SRR22588215_primary.counts -in SRR22588215_primary_purged.fasta -outfmt fasta -out SRR22588215_primary_purged_winmask.fasta

#repeatmasker
#RepeatMasker -pa 32 -xsmall -species aves SRR22588215_primary_purged.fasta -dir .

awk 'BEGIN{OFS="\t"} {if($1 !~ /^#/) print $5, $6-1, $7, $11, $0}' SRR22588215_primary_purged.fasta.out | tail -n +4 > output.bed

##bedtools
bedtools maskfasta -soft -fi SRR22588215_primary_purged_winmask.fasta -bed output.bed -fo SRR22588215_primary_purged_masked.fasta

#215 alternate
cd /scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588215/alternate/

#windowmasker
#windowmasker -mk_counts -in SRR22588215_alternate_purged.fasta -out stage1_SRR22588215_alternate.counts
#windowmasker -ustat stage1_SRR22588215_alternate.counts -in SRR22588215_alternate_purged.fasta -outfmt fasta -out SRR22588215_alternate_purged_winmask.fasta

#repeatmasker
#RepeatMasker -pa 32 -xsmall -species aves SRR22588215_alternate_purged.fasta -dir .

awk 'BEGIN{OFS="\t"} {if($1 !~ /^#/) print $5, $6-1, $7, $11, $0}' SRR22588215_alternate_purged.fasta.out | tail -n +4 > output.bed

##bedtools
bedtools maskfasta -soft -fi SRR22588215_alternate_purged_winmask.fasta -bed output.bed -fo SRR22588215_alternate_purged_masked.fasta

########

#216 primary
cd /scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588216/primary/

#windowmasker
#windowmasker -mk_counts -in SRR22588216_primary_purged.fasta -out stage1_SRR22588216_primary.counts
#windowmasker -ustat stage1_SRR22588216_primary.counts -in SRR22588216_primary_purged.fasta -outfmt fasta -out SRR22588216_primary_purged_winmask.fasta

#repeatmasker
#RepeatMasker -pa 32 -xsmall -species aves SRR22588216_primary_purged.fasta -dir .

awk 'BEGIN{OFS="\t"} {if($1 !~ /^#/) print $5, $6-1, $7, $11, $0}' SRR22588216_primary_purged.fasta.out | tail -n +4 > output.bed

##bedtools
bedtools maskfasta -soft -fi SRR22588216_primary_purged_winmask.fasta -bed output.bed -fo SRR22588216_primary_purged_masked.fasta

#216 alternate
cd /scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588216/alternate/

#windowmasker
#windowmasker -mk_counts -in SRR22588216_alternate_purged.fasta -out stage1_SRR22588216_alternate.counts
#windowmasker -ustat stage1_SRR22588216_alternate.counts -in SRR22588216_alternate_purged.fasta -outfmt fasta -out SRR22588216_alternate_purged_winmask.fasta

#repeatmasker
#RepeatMasker -pa 32 -xsmall -species aves SRR22588216_alternate_purged.fasta -dir .

awk 'BEGIN{OFS="\t"} {if($1 !~ /^#/) print $5, $6-1, $7, $11, $0}' SRR22588216_alternate_purged.fasta.out | tail -n +4 > output.bed

##bedtools
bedtools maskfasta -soft -fi SRR22588216_alternate_purged_winmask.fasta -bed output.bed -fo SRR22588216_alternate_purged_masked.fasta

########

#217 primary
cd /scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588217/primary/

#windowmasker
#windowmasker -mk_counts -in SRR22588217_primary_purged.fasta -out stage1_SRR22588217_primary.counts
#windowmasker -ustat stage1_SRR22588217_primary.counts -in SRR22588217_primary_purged.fasta -outfmt fasta -out SRR22588217_primary_purged_winmask.fasta

#repeatmasker
#RepeatMasker -pa 32 -xsmall -species aves SRR22588217_primary_purged.fasta -dir .

awk 'BEGIN{OFS="\t"} {if($1 !~ /^#/) print $5, $6-1, $7, $11, $0}' SRR22588217_primary_purged.fasta.out | tail -n +4 > output.bed

##bedtools
bedtools maskfasta -soft -fi SRR22588217_primary_purged_winmask.fasta -bed output.bed -fo SRR22588217_primary_purged_masked.fasta

#217 alternate
cd /scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588217/alternate/

#windowmasker
#windowmasker -mk_counts -in SRR22588217_alternate_purged.fasta -out stage1_SRR22588217_alternate.counts
#windowmasker -ustat stage1_SRR22588217_alternate.counts -in SRR22588217_alternate_purged.fasta -outfmt fasta -out SRR22588217_alternate_purged_winmask.fasta

#repeatmasker
#RepeatMasker -pa 32 -xsmall -species aves SRR22588217_alternate_purged.fasta -dir .

awk 'BEGIN{OFS="\t"} {if($1 !~ /^#/) print $5, $6-1, $7, $11, $0}' SRR22588217_alternate_purged.fasta.out | tail -n +4 > output.bed

##bedtools
bedtools maskfasta -soft -fi SRR22588217_alternate_purged_winmask.fasta -bed output.bed -fo SRR22588217_alternate_purged_masked.fasta

########

#218 primary
cd /scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588218/primary/

#windowmasker
#windowmasker -mk_counts -in SRR22588218_primary_purged.fasta -out stage1_SRR22588218_primary.counts
#windowmasker -ustat stage1_SRR22588218_primary.counts -in SRR22588218_primary_purged.fasta -outfmt fasta -out SRR22588218_primary_purged_winmask.fasta

#repeatmasker
#RepeatMasker -pa 32 -xsmall -species aves SRR22588218_primary_purged.fasta -dir .

awk 'BEGIN{OFS="\t"} {if($1 !~ /^#/) print $5, $6-1, $7, $11, $0}' SRR22588218_primary_purged.fasta.out | tail -n +4 > output.bed

##bedtools
bedtools maskfasta -soft -fi SRR22588218_primary_purged_winmask.fasta -bed output.bed -fo SRR22588218_primary_purged_masked.fasta

#218 alternate
cd /scratch/negishi/allen715/pangenome/forNA2/purged_hifi/SRR22588218/alternate/

#windowmasker
#windowmasker -mk_cSRR22588218ounts -in SRR22588218_alternate_purged.fasta -out stage1_SRR22588218_alternate.counts
#windowmasker -ustat stage1_SRR22588218_alternate.counts -in SRR22588218_alternate_purged.fasta -outfmt fasta -out SRR22588218_alternate_purged_winmask.fasta

#repeatmasker
#RepeatMasker -pa 32 -xsmall -species aves SRR22588218_alternate_purged.fasta -dir .

awk 'BEGIN{OFS="\t"} {if($1 !~ /^#/) print $5, $6-1, $7, $11, $0}' SRR22588218_alternate_purged.fasta.out | tail -n +4 > output.bed

##bedtools
bedtools maskfasta -soft -fi SRR22588218_alternate_purged_winmask.fasta -bed output.bed -fo SRR22588218_alternate_purged_masked.fasta

