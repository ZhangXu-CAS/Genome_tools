library(ggplot2)
library(reshape2)

ks<-read.csv("Ks_HRB.csv")

ks2<-na.omit( melt(ks,variable.name = "Species",value.name = "Ks"))


########LTR insertion time#########
ltr<- read.csv("LTR_inset.csv")
ltr=na.omit(ltr)


ggplot(ltr, aes(Time,fill =Type, color=Type)) + 
  #geom_histogram(aes(y = ..density..), alpha = 0.5,bins = 300,center = 0) + 
  geom_density(aes(y = ..density..),alpha = 0.5,size=1) + 
  theme_bw() +
  coord_cartesian(xlim =c(0, 3e+06))
  
ggplot(ltr,aes(Time,fill=Type,color=Type))  +
  geom_histogram(binwidth = 10000)   +
  xlim(0, 3e+06)  + theme_bw()  + ylim(0, 2000) +
  theme(axis.title = element_text(size=16),axis.text=element_text(size=16))
#####################################################


ggplot(data=ks2,aes(x=Ks,colour=Species))+
  #geom_histogram(aes(y=..density..),alpha=0.5,binwidth = 0.05,center = 0)+
  geom_density(position="identity",size=1) + 
  coord_cartesian(xlim =c(0, 3))+
  theme_bw()
ggplot(ks2,aes(Ks,color=Species))  +
  geom_line(stat="density",size=1)  + xlim(0,2)  + theme_bw()  +
  theme(axis.title = element_text(size=16),axis.text=element_text(size=16))

Sab <- ks2[ks2$Species=="Artichoke",]
Saa <- ks2[ks2$Species=="Sunflower",]
Sbb <- ks2[ks2$Species=="Snow_lotus",]
densFindPeak <- function(x){
  td <- density(x)
  maxDens <- which.max(td$y)
  list(x=td$x[maxDens],y=td$y[maxDens])
}

Sab_limit <- Sab$Ks[Sab$Ks>=0 & Sab$Ks<=2]
Saa_limit <- Saa$Ks[Saa$Ks>=0 & Saa$Ks<=2]
Sbb_limit <- Sbb$Ks[Sbb$Ks>=0 & Sbb$Ks<=2]

abPeak = densFindPeak(Sab_limit)
aaPeak = densFindPeak(Saa_limit)
bbPeak = densFindPeak(Sbb_limit)



ggplot(ks2,aes(Ks,fill=Species,color=Species,alpha=0.8)) +
  geom_density() + xlim(0,2) + theme_classic() +
  #geom_vline(xintercept = abPeak[[1]],colour="red",linetype="dashed") +
  #geom_text(aes(x=abPeak[[1]], y= abPeak[[2]]+0.3,label=paste("Ks =",round(abPeak[[1]],4))),color="black") +
  #geom_vline(xintercept = aaPeak[[1]],colour="red",linetype="dashed") +
  #geom_text(aes(x=aaPeak[[1]]-0.02, y= aaPeak[[2]]+0.3,label=paste("Ks =",round(aaPeak[[1]],4))),color="black") +
  #geom_vline(xintercept = bbPeak[[1]],colour="red",linetype="dashed") +
  #geom_text(aes(x=bbPeak[[1]]+0.02, y= bbPeak[[2]]+0.7,label=paste("Ks =",round(bbPeak[[1]],4))),color="black") +
  guides(alpha=FALSE) +
  theme(axis.title = element_text(size=16),axis.text=element_text(size=16),legend.position = "top")
