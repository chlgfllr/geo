##Analyse des resultats obtenus chez les deux locuteurs georgiens enregistres a Paris
##Nino - s08
##Nodo - s09

library(ggplot2)
library(dplyr)
library(readr)

theme_set(theme_minimal())

##Set working directory
setwd("C:/Users/chloe_000/OneDrive/Documents/M2/Georgian/Data/Recordings/Expe/xp_vot/annotated")
mydata <- read_csv2("ejec_020.csv")
attach(mydata)
View(mydata)

########For some reason iff the duration measures do not show the dot/comma for decimals, run these
mydata <- mutate(mydata, Total_duration = Total_duration / 100)
mydata <- mutate(mydata, Duration_of_foll = Duration_of_foll / 100)
mydata <- mutate(mydata, Extended_vot = Extended_vot / 100)
mydata <- mutate(mydata, vot = vot / 100)

#################################################################################
########  Description of the variables used in the dataset
##  - Speaker             code of the speaker recorded: s08/s09
##  - Filename            name of the file as saved on the computer
##  - Focus_word          focus word the segment under study is taken from
##  - Number_of_syll      number of syllables in the focus word
##  - Segment             1=p> 2=t> 3=k>
##  - Corresponding_syll  which syllable does the segment belong to (1/2/3)
##  - Position            initial or medial position?
##  - Total_duration      not total duration but duration of the constriction
##  - Glottal_burst       is there a glottal release on the egg wave (0/1)
##  - Following_segment   what is the next vowel 
##  - Duration_of_foll    how long is the following vowel
##  - Glottalization      is the vowel glottalized (0/1)
##  - Extended_vot        duration from oral release to modal voice (0 for aspirates)
##  - vot                 duration from glottal release for ejectives, from oral release for aspirates
##  - Interburst          duration between the two releases (0 for aspirates)
##  - Focus               is the target word in focus or not
#################################################################################
##Creation de subsets
wd_init <- filter(mydata, Initial == "1")
wd_med <- filter(mydata, Initial == "2")
foc <- filter(mydata, Focus == "1")
nofoc <- filter(mydata, Focus == "0")
foc_in <- filter(wd_init, Focus == "1")
foc_med <- filter(wd_med, Focus == "1")
nofoc_in <- filter(wd_init, Focus == "0")
nofoc_med <- filter(wd_med, Focus == "0")

##Tests statistiques
##Faire t-test pour Position et Focus
##Sur toutes ejectives confondues
##On fait varier la variable avant le tilde
require(graphics)
summary(fm1 <- kruskal.test(vot ~ Initial, data = her))
TukeyHSD(fm1, "Focus", ordered = TRUE)
plot(TukeyHSD(fm1, "Segment"))


##########################################################
##Sur ejectives en position initiale vs. mediane
require(graphics)
summary(fm1 <- aov(Interburst ~ Segment, data = foc_med))
TukeyHSD(fm1, "Segment", ordered = TRUE)
plot(TukeyHSD(fm1, "Segment"))

##########################################################
##Sur ejectives en focus vs. non-focus
##Tout, initial, medial
require(graphics)
summary(fm1 <- aov(Interburst ~ Segment, data = nofoc_in))
TukeyHSD(fm1, "Segment", ordered = TRUE)
plot(TukeyHSD(fm1, "Segment"))

#########################################################
##T-test pour echelles binaires

#########################################################
qplot(Glottal_burst, Segment, data = mydata) +
  
  facet_grid(Speaker~Initial) 
#########################################################
##Analysis of results
install.packages("psych")
library(pastecs)
foc <- filter(mydata, Focus=="1")
nofoc <- filter(mydata, Focus != "1")
foc_in <- filter(foc, Initial =="1")
foc_med <- filter(foc, Initial != "1")
nofoc_in <- filter(nofoc, Initial=="1")
nofoc_med <- filter(nofoc, Initial !="1")
her_if <- filter(foc_in, Speaker =="s08")
her_inf <- filter(nofoc_in, Speaker =="s08")
her_mf <- filter(foc_med, Speaker == "s08")
her_mnf <- filter(nofoc_med, Speaker=="s08")
his_if <- filter(foc_in, Speaker =="s09")
his_inf <- filter(nofoc_in, Speaker =="s09")
his_mf <- filter(foc_med, Speaker =="s09")
his_mnf <- filter(nofoc_med, Speaker =="s09")
describe(hisdata_if$vot[Segment=="P"])

qplot(Segm_num, Ratio_NMV, data = mydata) +
  geom_boxplot(aes(fill = factor(Segment))) +
  facet_grid(Focus ~ Speaker * Initial, margins = FALSE) +
  scale_fill_manual(values = c("#694966", "#2374AB", "#F9AB55"),
                    name="Ejective stops",
                    breaks=c("P", "T", "K"),
                    labels=c("p'", "t'", "k'"))
  
  ggtitle("Interburst duration by segment as a\n function of focus and position in the target word") +
  xlab("Place of articulation of the ejective stop") + ylab("Duration of interburst in milliseconds") +
  theme(text=element_text(size=10, family="Times New Roman")) +

  
  facet_grid(Initial ~ Focus * Speaker, labeller = labeller(Initial = label_x, Focus = label_y), switch = "y") +
  theme(strip.text.x = element_text(size=8, family = "Times New Roman"),
        strip.text.y = element_text(size=8, family = "Times New Roman"),
        strip.background = element_rect(colour="grey80", fill="grey80")) +
  scale_fill_manual(values=c("#694966", "#2374AB", "#F9AB55"), 
                    name="Ejective stops",
                    breaks=c("P", "T", "K"),
                    labels=c("p'", "t'", "k'"))

a <- filter(mydata, Glottalization =="1")
##az selects the speaker you study
az <- filter(a, Speaker =="s09")
##aze selects whether you take initial (1) or medial (2) segments
aze <- filter(a, Initial=="2")
##azer selects the focus 1/0
azer <- filter(aze, Focus =="0")
##q selects the segment P/T/K
q <- filter(azer, Segment=="P")

a <- filter(mydata, Glottal_burst=="1")
az <- filter(a, Speaker =="s09")
aze <- filter(a, Initial=="1")
azer <- filter(aze, Focus =="1")
