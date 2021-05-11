trimmomatic PE -phred33 -threads 4 \
BX-B_FRAS202422945-2r_1.fq.gz BX-B_FRAS202422945-2r_2.fq.gz \
BX-B_clean_1.fq.gz output_forward_unpaired.fq.gz BX-B_clean_2.fq.gz \
output_reverse_unpaired.fq.gz \
ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 \
LEADING:3 TRAILING:3 \
SLIDINGWINDOW:4:15 MINLEN:36
#
#This will perform the following:

#Remove adapters (ILLUMINACLIP:TruSeq3-PE.fa:2:30:10)
#Remove leading low quality or N bases (below quality 3) (LEADING:3)
#Remove trailing low quality or N bases (below quality 3) (TRAILING:3)
#Scan the read with a 4-base wide sliding window, cutting when the average quality per base drops below 15 (SLIDINGWINDOW:4:15)
#Drop reads below the 50 bases long (MINLEN:50)
##HEADCROP: The number of bases to remove from the start of the read.