#Goal 4 & 5: Sarah Eyoas & Chin Chin

#Goal 4 Cleaning the Data 
#_____________________________________________________________________________________________________________________________________________
#1. loading the readr dataset so that the files can be read into the program
    library(dplyr)    
    library(readr)
    dataset <- read_csv("~/Data Science Folder/dataset.csv")

#2. One is a dataset with informtion about the canidates, qty of hatecrimes, and he publicity each canidate recieved. 
  #using the melt function we are trying to concatinate them into one colum (from "wide" to "long")
    library(reshape2)
    One = dataset %>% select(state, state_abbr,hate_crimes_per_100k_splc,`Rates of 2016`, `Rates of 2015`, `Rates of 2014`,
                         Clinton..2016., Trump..2016.)
    One_y <- One %>% melt(id = c("state", "state_abbr","hate_crimes_per_100k_splc", 'Rates of 2016', 'Rates of 2015', 'Rates of 2014'))

#3. Two is a dataset with information about the total votes for each party.
  #using melt again we are trying to concatinate the data into one colum (from "wide" to "long")
    Two = dataset %>% select(state, votes_dem_2016, votes_gop_2016)
    Two_y <- Two %>% melt(id = c("state"))

#4. Final is a dataset with both One and Two altertered contents and column names that reflect what the data does. 
Final = cbind(One_y, Two_y)
colnames(Final)= c("State", "Abbr","Hate_Crimes", "Unemp2016", "Unemp2015", "Unemp2014", "Candidate", "Publicity",
                   "State2","Party", "Votes" )
#_____________________________________________________________________________________________________________________________________________
                                #Goal 5 Mulipilating the data 
##____________________________________________________________________________________________________________________________________________
##PlOT 1- 
Final2 <- Final %>% mutate(mean_unemp = (Unemp2016 + Unemp2015 + Unemp2014) / 3) %>% select(State, mean_unemp) 
Final22=Final2 %>% group_by(State) %>% summarize(mean_unemp = mean(mean_unemp))%>% 
  arrange(mean_unemp)
##
Final_V = Final[!is.na(Final$Votes),]
Votes = Final_V %>% group_by(Party) %>% summarize(total_votes = sum(Votes))

##
Publicity <- Final %>% group_by(Candidate) %>% summarise(Average_Publicity = mean(Publicity))
library(ggplot2)
ggplot(Publicity, aes(x = Candidate, y = Average_Publicity, fill = Candidate)) + geom_bar(stat = "identity")
##
Rates = Final %>% select(Hate_Crimes, Unemp2016, Unemp2014, Unemp2015, Abbr)
Rates = na.omit(Rates)

Rates_ = Rates %>% select(Hate_Crimes, Unemp2016, Unemp2014, Unemp2015)
k=kmeans(Rates_, centers=3, nstart= 25)
Rates2 = Rates %>% mutate(clusters = factor(k$cluster))



ggplot(Rates2, aes(x = Hate_Crimes, y = Unemp2014, color = clusters, label = Abbr)) + 
  geom_point()+geom_text(hjust = 0, vjust = 0)


##
ratio <- dataset %>% mutate(ratio = votes_dem_2016/votes_gop_2016) %>% select(state, ratio)

ratio_noDC = ratio %>% filter (state != "District of Columbia")
ggplot(ratio, aes(x= state, y = ratio)) + geom_bar(stat = "identity") + coord_flip() + 
  theme(text = element_text(size = 10))

###DR morrison\

##with DC
ratio <- dataset %>% mutate(ratio = votes_dem_2016/votes_gop_2016) %>% select(state, ratio)
ggplot(ratio, aes(x= reorder(state, ratio), y = ratio)) + 
  geom_bar(stat = "identity",color="black", fill="skyblue") + coord_flip() + 
  theme(text = element_text(size = 10))

##NO  DC
ggplot(ratio_noDC, aes(x= reorder(state, ratio), y = ratio)) + 
  geom_bar(stat = "identity",color="black", fill="skyblue") + coord_flip() + 
  theme(text = element_text(size = 10))


##
ggplot(Final, aes(x = Unemp2016, y = Votes/100000, color = Candidate)) + geom_point() + geom_smooth(method = lm, se = FALSE)
