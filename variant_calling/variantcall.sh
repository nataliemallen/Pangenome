#!/bin/bash
#SBATCH --job-name=variantcall
#SBATCH -A fnrdewoody
#SBATCH -N 1
#SBATCH -n 128
#SBATCH -t 14-00:00:00
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

N=128 # number of cores
BASE=/scratch/negishi/allen715/pangenome/forNA2 # e.g., /scratch/negishi/jeon96/swallow
APP=/home/allen715/vgtoolkit_1.53 # e.g., /home/jeon96/app
PREFIX=short-swallow-out # please define PREFIX as whatever you which
MCPAN=/scratch/negishi/allen715/pangenome/forNA2/out # e.g., /scratch/negishi/jeon96/swallow/mcpan
REF=/scratch/negishi/allen715/pangenome/forNA2/ref # e.g., scratch/negishi/jeon96/swallow/original/ref 
CLEANED_SRA=/scratch/negishi/allen715/pangenome/forNA2/cleaned_sra # e.g., ${BASE}/original/sra/cleaned
DEPOT=/depot/fnrdewoody
RefInd=refp # your reference indivial's name from the Minigraph-Cactus seqFile e.g., bHirRus1_LinPan

# 17. Augmenting the graph pangenome
#cd ${MCPAN}/

## 17.1. Converting file type
#gunzip ${PREFIX}-pg.gfa.gz 
#${APP}/vg convert -g ${PREFIX}-pg.gfa -v > ${PREFIX}-pg.vg

## check graph genome stats; run this step on highmem queue 
# ${APP}/vg paths -M -x ${PREFIX}-pg.vg > paths_table.txt
# ${APP}/vg stats -lz ${PREFIX}-pg.vg
# ${APP}/vg paths -E -v ${PREFIX}-pg.vg > paths_lengths.txt
# ${APP}/vg stats -F ${PREFIX}-pg.vg

## 17.2. Modifying the pangenome to flip nodes' strands to reduce the number of times paths change strands
#cd ./${PREFIX}-pg/
# mkdir -p ./tmp/
# 
# ${APP}/vg mod -t ${N} -O ./${PREFIX}-pg.vg > ${PREFIX}_mod.vg
# ${APP}/vg index -p -t ${N} -x ${PREFIX}_mod.xg ${PREFIX}_mod.vg
# 
# ## 17.3. Chopping nodes in the graph so they are not more than 256 bp and index the graph
# ${APP}/vg mod -t ${N} -X 256 ${PREFIX}_mod.vg > ${PREFIX}_mod_chopped.vg
# ${APP}/vg index -t ${N} -x ${PREFIX}_mod_chopped.xg ${PREFIX}_mod_chopped.vg
# 
# ## 17.4. Pruning the graph with kmer size 45 and index the graph
# ${APP}/vg prune -t ${N} -k 45 ${PREFIX}_mod_chopped.vg > ${PREFIX}_mod_chopped_pruned.vg
# ${APP}/vg index -t ${N} -b ./tmp -p -g ${PREFIX}_mod_chopped_pruned.gcsa ${PREFIX}_mod_chopped_pruned.vg
# 
# ## 17.5. Indexing the graph with -L option
# ${APP}/vg index -t ${N} -L -b ./tmp ${PREFIX}_mod_chopped.vg -x ${PREFIX}_mod_chopped_new_L.xg #-L: preserve alt paths in the xg


# 18. Mapping test data reads

#cd ${MCPAN}/${PREFIX}-pg/
# cd ${MCPAN}/
# mkdir -p ./aligned/tmp
# cd ./aligned/
# 
# #for i in `cat ${BASE}/original/SRR_Acc_List.txt`; do
# for i in `cat ${BASE}/SRR_Acc_List.txt`; do
# 
# ## 18.1. Aligning the individuals
# #${APP}/vg map -t ${N} -f ${CLEANED_SRA}/${i}_1_val_1.fq -f ${CLEANED_SRA}/${i}_2_val_2.fq -x ${MCPAN}/${PREFIX}_mod_chopped.xg -g ${MCPAN}/${PREFIX}_mod_chopped_pruned.gcsa > ${i}_org_aln.gam
# 
# ## 18.2. Filtering secondary and ambiguous read mappings out of the gam (for SV detection for now)
# ${APP}/vg filter -t ${N} ${i}_org_aln.gam -r 0.90 -fu -m 1 -q 15 -D 999 -x ${MCPAN}/${PREFIX}_mod_chopped.xg > ${i}_org_aln.filtered.gam
# 
# done
# 
# cat *_org_aln.filtered.gam > combined_org_aln.filtered.gam

# cd ${MCPAN}/aligned/
# 
# ## 18.3. Augmenting the graph with all variation from the GAM
# ${APP}/vg convert -t ${N} ${MCPAN}/${PREFIX}_mod_chopped_new_L.xg -p > ${PREFIX}_org.pg
# ${APP}/vg augment -t ${N} ${MCPAN}/${PREFIX}_org.pg ${MCPAN}/aligned/combined_org_aln.filtered.gam -s -m 3 -q 5 -Q 5 -A ${PREFIX}_orgSV.gam > ${PREFIX}_orgSV.pg 
# 
# 
# # 18.4. Indexing the augmented graph
# ${APP}/vg mod -t ${N} -X 256 ${PREFIX}_orgSV.pg > ${PREFIX}_orgSV_chopped.pg
# ${APP}/vg index -t ${N} -x ${PREFIX}_orgSV_chopped.xg ${PREFIX}_orgSV_chopped.pg
# ${APP}/vg prune -t ${N} -k 45 ${PREFIX}_orgSV_chopped.pg > ${PREFIX}_orgSV_chopped_pruned.pg
# ${APP}/vg index -t ${N} -b ./tmp -p -g ${PREFIX}_orgSV_chopped_pruned.gcsa ${PREFIX}_orgSV_chopped_pruned.pg
# 
# ## 18.5. Indexing the augmented graph with -L option
# ${APP}/vg index -t ${N} -L -b ./tmp ${PREFIX}_orgSV_chopped.pg -x ${PREFIX}_orgSV_chopped_new_L.xg #-L: preserve alt paths in the xg
# ${APP}/vg convert -t ${N} ${PREFIX}_orgSV_chopped_new_L.xg -p > ${PREFIX}_orgSV_new.pg


# # 19. Variant calling (for SVs) for each individual
# #use highmem
# cd ${MCPAN}/aligned/
# mkdir -p ../called/sv
# 
# # 19.1. Computing the snarls
# #${APP}/vg snarls -t ${N} ${PREFIX}_orgSV_new.pg > ${PREFIX}_orgSV.snarls
# 
# #19.2 times out on highmem, so running with a partial list of SSR_Acc
# for i in `cat ${BASE}/SRR_Acc_List.txt`; do
# 
# # 19.2. Aligning the individuals
# #${APP}/vg map -t ${N} -f ${CLEANED_SRA}/${i}_1_val_1.fq -f ${CLEANED_SRA}/${i}_2_val_2.fq -x ./${PREFIX}_orgSV_chopped.xg -g ./${PREFIX}_orgSV_chopped_pruned.gcsa > ${i}_orgSV_aln.gam
# 
# # 19.3. Filtering secondary and ambiguous read mappings out of the gam
# #${APP}/vg filter -t ${N} ${i}_orgSV_aln.gam -r 0.90 -fu -m 1 -q 15 -D 999 -x ./${PREFIX}_orgSV_chopped.xg > ${i}_orgSV_aln.filtered.gam
# 
# # 19.4. Computing the support
# ${APP}/vg pack -t ${N} -x ${PREFIX}_orgSV_new.pg -g ${i}_orgSV_aln.filtered.gam -Q 5 -o ${i}_orgSV.pack #-Q 5: ignore mapping and base qualitiy < 5
# done

# ## 19.5. Calling variants; run this step using highmem queue (otherwise it can't be finished)
# cd ${MCPAN}/aligned/
# for i in `cat ${BASE}/SRR_Acc_List_new.txt`; do
# ${APP}/vg call -t ${N} ${PREFIX}_orgSV_new.pg -r ${PREFIX}_orgSV.snarls -k ${i}_orgSV.pack -s ${i} -a -A -c 50 > ../called/sv/${i}_orgSV.vcf #-a: calling every snarl using the same coordinates and including reference calls; -c: minimum length of variants to be called
# done


# 20. Combining separately called SV vcf files
# cd ${MCPAN}/called/sv
# 
# module purge
# module load biocontainers
# module load bcftools
# module load vcftools

#before running this, need to change vcf file headers
## 20.1. Compressing and indexing each vcf file first
#for i in `cat ${BASE}/SRR_Acc_List.txt`; do
  ##sed 's/refp#0#//g' ${i}_orgSV.vcf > ${i}_orgSV2.vcf # polish the header line to be compatible with bcftools
  #bcftools sort ${i}_orgSV2.vcf -Oz -o ${i}_orgSV.sorted.vcf.gz
  #bcftools index ${i}_orgSV.sorted.vcf.gz --threads ${N}
  #bcftools view ${i}_orgSV.sorted.vcf.gz --threads ${N} | grep -v "##" | wc -l
  #rm ${i}_orgSV2.vcf
#done

#bcftools merge -m all -Oz -o ${PREFIX}_orgSV.merged.vcf.gz --threads ${N} *_orgSV.sorted.vcf.gz 

# 21. Variant calling (for SNPs using Sarek and for SVs using delly2) based on surjected bamfiles for each individual 
# cd ${MCPAN}/aligned/
# mkdir -p ../called/snp

# module purge
# module load biocontainers
# module load samtools
# module load bwa
# module load picard
# module load nf-core
# module load bbmap

## 21.1. Creating a list of reference paths
#${APP}/vg paths -x ${MCPAN}/${PREFIX}.full.gbz -S ${RefInd} -L > ../${RefInd}.${PREFIX}-pg_paths.txt # use .full graph just to make path lists (used updated version of vg for this - v.1.53)

## 21.2. Projecting each sample's reads to the RefInd
# for i in `cat ${BASE}/SRR_Acc_List.txt`; do
#   ${APP}/vg filter -t ${N} ${i}_org_aln.gam -r 0.90 -fu -m 1 -q 15 -D 999 -i -x ../${PREFIX}_mod_chopped.xg > ${i}_org_interleaved_aln.filtered.gam
#   ${APP}/vg surject -x ../${PREFIX}_mod_chopped.xg ${i}_org_interleaved_aln.filtered.gam --threads ${N} --prune-low-cplx --interleaved -F ../${RefInd}.${PREFIX}-pg_paths.txt -b -N ${i} -R "ID:1 LB:lib1 SM:${i} PL:illumina PU:unit1" > ${i}.${PREFIX}-pg_surject.bam
# done


# 
# 21.3 Calling SNPs (and small SVs < 50 bp) using nf-core Sarek pipeline
### 21.3.1. Indexing bam files
# for i in `cat ${BASE}/SRR_Acc_List.txt`; do
#   samtools sort -@ ${N} -o ${i}.${PREFIX}-pg_surject.sorted.bam ${i}.${PREFIX}-pg_surject.bam 
#   samtools index -@ ${N} -b ${i}.${PREFIX}-pg_surject.sorted.bam   
# done
# 

### 21.4.1. Preprocessing the reference genome and bam files
module purge
module load biocontainers
module load gatk4
module load picard
module load samtools
module load bcftools
module load boost

# cd ${REF}
# PicardCommandLine CreateSequenceDictionary --REFERENCE ref.renamed.sorted.fa --OUTPUT ref.renamed.sorted.dict
# bwa index -a bwtsw ref.renamed.sorted.fa

# cd ${MCPAN}/aligned/
### 2.3.3. GATK HaplotypeCaller
 
# for i in `cat ${BASE}/SRR_Acc_List_new.txt`; do
# mkdir -p /scratch/negishi/allen715/pangenome/forNA2/out/called/snp/variant_calling/${i}/
# gatk  --java-options "-Xmx100G -XX:ParallelGCThreads=128" HaplotypeCaller -R ${REF}/ref.renamed.sorted.fa -I /scratch/negishi/allen715/pangenome/forNA2/out/called/snp/preprocessing/markduplicates/${i}/${i}.md.cram  -O /scratch/negishi/allen715/pangenome/forNA2/out/called/snp/variant_calling/${i}/${i}.haplotypecaller.vcf.gz --tmp-dir .
# done

#### use sorted file instead of just renamed 
# 
# ## 21.4. Calling SVs using delly2
# ### 21.4.1. Preprocessing the reference genome and bam files
# cd ${REF}
# PicardCommandLine CreateSequenceDictionary --REFERENCE ref.renamed.fa --OUTPUT ref.renamed.dict
# bwa index -a bwtsw ref.renamed.fa

cd ${MCPAN}/aligned/
# mkdir -p ../called/sv/delly
# 
# for i in `cat ${BASE}/SRR_Acc_List.txt`; do
#   PicardCommandLine MarkDuplicates --INPUT ${i}.${PREFIX}-pg_surject.sorted.bam --OUTPUT ${i}.${PREFIX}-pg_surject.sorted.marked.bam --METRICS_FILE ${i}.${PREFIX}-pg_surject_metrics.txt
#   PicardCommandLine BuildBamIndex --INPUT ${i}.${PREFIX}-pg_surject.sorted.marked.bam
# done
# 
### 21.4.2. Running delly2
cd ../called/sv/delly

# export OMP_NUM_THREADS=25 # equal or less than the number of samples
# samples=""
# for i in `cat ${BASE}/SRR_Acc_List.txt`; do
#   samples+="${MCPAN}/aligned/${i}.${PREFIX}-pg_surject.sorted.marked.bam "
# done
# #used ref.renamed.sorted.fa not ref.renamed.fa 
# ${DEPOT}/apps/delly/src/delly call -g ${REF}/ref.renamed.sorted.fa ${samples} > orgpan_delly.vcf


bcftools view -Oz -o  orgpan_delly.bcf --threads ${N} orgpan_delly.vcf
bcftools index orgpan_delly.bcf

${DEPOT}/apps/delly/src/delly filter -f germline -o orgpan_delly.filtered.bcf orgpan_delly.bcf
bcftools view -Ov -o orgpan_delly.filtered.vcf orgpan_delly.filtered.bcf 
