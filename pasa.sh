#! ~/bin/bash

PASAHOME='/home/wangh/zx/Saussurea_genome/annotation/PASA/PASApipeline.v2.4.1'

####1. 普通用法Running the Alignment Assembly Pipeline
########																##
# 1. Trinity de novo RNA-Seq assemblies (ex. Trinity.fasta)				##
# 2. Trinity genome-guided RNA-Seq assemblies (ex. Trinity-GG.fasta)	##
# 3. (optionally)cufflinks transcript structures (ex. cufflinks.gtf)	##
########																##

cat Trinity.fasta Trinity.GG.fasta > transcripts.fasta

$PASAHOME/bin/seqclean  transcripts.fasta #Step A: cleaning the transcript sequences [Optional]

$PASAHOME/Launch_PASA_pipeline.pl \
           -c alignAssembly.config -C -R -g ../chr.fa \
           -t transcripts.fasta.clean -T -u transcripts.fasta \
            --ALIGNERS blat,gmap --CPU 12
			
####2. PASA结合RNA-seq数据来进行基因预测
#Build a comprehensive transcriptome database, integrating genome-guided and genome-free transcript reconstructions

$PASA_HOME/misc_utilities/accession_extractor.pl < Trinity.fasta > tdn.accs

$PASA_HOME/scripts/Launch_PASA_pipeline.pl \
-c alignAssembly.config -t transcripts.fasta \
-C -R -g ../chr.fa \
 --ALIGNERS blat,gmap --CPU 12 \
 --TDN tdn.accs --cufflinks_gtf cufflinks.gtf

$PASA_HOME/scripts/build_comprehensive_transcriptome.dbi \
           -c alignAssembly.config \
           -t transcripts.fasta \
           --min_per_ID 95 \
           --min_per_aligned 30
		   
####3. Annotation Comparisons and Annotation Updates

$PASA_HOME/misc_utilities/pasa_gff3_validator.pl EVM.gff3

$PASA_HOME/scripts/Load_Current_Gene_Annotations.dbi \
-c alignAssembly.config \
-g ../chr.fa  -P EVM.gff3

$PASA_HOME/scripts/Launch_PASA_pipeline.pl \
-c annotCompare.config \
-A -g ../chr.fa \
-t transcripts.fasta.clean


