
REF=/home/wangh/zx/Saussurea_genome/depth/ndasm2_ndph_pilon_purged.fa

R1=/home/wangh/zx/Saussurea_genome/illumina_reads/sr.1.fq.gz
R2=/home/wangh/zx/Saussurea_genome/illumina_reads/sr.2.fq.gz
bwa index $REF
bwa mem -t 12  $REF  $R1 $R2 |samtools view -Sb -@ 12 > ndasm2_ndph_pilon_purged.bam && 
samtools sort -@ 12 -O bam -o ndasm2_ndph_pilon_purged.sort.bam ndasm2_ndph_pilon_purged.bam
echo "** bwa mapping done **"
