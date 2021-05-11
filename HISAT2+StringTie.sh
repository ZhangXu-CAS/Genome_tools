#!~/bin/bash:
WD=/home/wangh/zx/Saussurea_genome/annotation/trans_evi
cd $WD

mkdir index
hisat2-build chr.fa index/chr
hisat2 --dta -p 12 -x index/chr -1 BX-L_clean_1.fq.gz -2 BX-L_clean_2.fq.gz| samtools sort -@ 10 > BX-L.bam & 
hisat2 --dta -p 12 -x index/chr -1 BX-F_clean_1.fq.gz -2 BX-F_clean_2.fq.gz| samtools sort -@ 10 > BX-F.bam &
hisat2 --dta -p 12 -x index/chr -1 BX-B_clean_1.fq.gz -2 BX-B_clean_2.fq.gz| samtools sort -@ 10 > BX-B.bam &
samtools merge -@ 20 merged.bam BX-L.bam BX-F.bam  BX-B.bam 
stringtie -p 20 -o HISAT2+StringTie.gtf merged.bam

######
#tophat2 --output-dir ./tophat_out_BX-B --library-type fr-unstranded --num-threads 12 chr BX-L_clean_1.fq.gz BX-L_clean_2.fq.gz &
#tophat2 --output-dir ./tophat_out_BX-F --library-type fr-unstranded --num-threads 12 chr BX-F_clean_1.fq.gz BX-F_clean_2.fq.gz &
#tophat2 --output-dir ./tophat_out_BX-L --library-type fr-unstranded --num-threads 12 chr BX-B_clean_1.fq.gz BX-B_clean_2.fq.gz &
#
#cufflinks -o ./cuffout_BX-B -p 12  --library-type fr-unstranded -u -L BX-B BX-B.toph.bam &
#cufflinks -o ./cuffout_BX-F -p 12  --library-type fr-unstranded -u -L BX-F BX-F.toph.bam &
#cufflinks -o ./cuffout_BX-L -p 12  --library-type fr-unstranded -u -L BX-L BX-L.toph.bam &
#cuffmerge -o ./Cuffmerge -g  -p 16 assembly_GTF_list.txt
#echo 'hisat2+stringtie done'
####

####TransDecoder进行编码区预测
./util/gtf_genome_to_cdna_fasta.pl HISAT2+StringTie.gtf ../chr.fa > transcripts.fasta
./util/gtf_to_alignment_gff3.pl HISAT2+StringTie.gtf > transcripts.gff3
./TransDecoder.LongOrfs -t transcripts.fasta
./TransDecoder.Predict -t transcripts.fasta
./util/cdna_alignment_orf_to_genome_orf.pl \
     transcripts.fasta.transdecoder.gff3 \
     transcripts.gff3 \
     transcripts.fasta > transcripts.fasta.transdecoder.genome.gff3
echo 'TransDecoder done'

###最后结果transcripts.fasta.transdecoder.gff3用于提供给EvidenceModeler