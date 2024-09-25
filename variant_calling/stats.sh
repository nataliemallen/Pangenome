#!/bin/bash
#SBATCH --job-name=variantcall_stats
#SBATCH -A fnrdewoody
#SBATCH -N 1
#SBATCH -n 64
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
cd ${MCPAN}/

## 17.1. Converting file type
#gunzip ${PREFIX}-pg.gfa.gz 
#${APP}/vg convert -g ${PREFIX}-pg.gfa -v > ${PREFIX}-pg.vg

## check graph genome stats; run this step on highmem queue 
# ${APP}/vg paths -M -x ${PREFIX}-pg.vg > paths_table.txt
# ${APP}/vg stats -lz ${PREFIX}-pg.vg
# ${APP}/vg paths -E -v ${PREFIX}-pg.vg > paths_lengths.txt
# ${APP}/vg stats -F ${PREFIX}-pg.vg

# ${APP}/vg stats -lz ${PREFIX}.gbz
# ${APP}/vg stats -lz ${PREFIX}.full.gbz

${APP}/vg stats -lz ${PREFIX}-pg.vg
${APP}/vg stats -lz ${PREFIX}.gbz
${APP}/vg stats -lz ${PREFIX}.full.gbz
