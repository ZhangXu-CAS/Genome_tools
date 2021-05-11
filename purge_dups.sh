#!/bin/bash
####purge_dups for delete redundans  ---xu zhang, last run 2021/1/29
asm=/home/wangh/zx/Saussurea_genome/BUSCO/necat_racon3_pilon.fasta
reads=/home/wangh/zx/Saussurea_genome/ont.fasta
minimap2 -t 12 -x map-ont $asm $reads | pigz -c - > pb_aln.paf.gz
# 统计paf, 输出PB.base.cov和PB.stat文件
./bin/pbcstat pb_aln.paf.gz
./bin/calcuts PB.stat > cutoffs 2> calcults.log
# Split an assembly
./bin/split_fa $asm > asm.split
# do a self-self alignment
minimap2 -t 12 -xasm5 -DP asm.split asm.split | pigz -c > asm.split.self.paf.gz
# purge haplotigs and overlap
./bin/purge_dups -2 -T cutoffs -c PB.base.cov asm.split.self.paf.gz > dups.bed 2> purge_dups.log
# get the purged primary and haplotigs sequences from draft assembly
./bin/get_seqs dups.bed $asm
