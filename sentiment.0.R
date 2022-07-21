
##Loading the required packages
library(dplyr) #data handling
library(tidytext)
library(tm)
library(ggplot2) #plotting
library(syuzhet) #sentiment analysis
library(ggrepel) #comparison analysis

#loading ted_talks data
data(ted_talks)


MyData <- ted_talks %>%
filter(speaker %in% c("Rodney Brooks", "Nathan Wolfe"))
head(MyData) #ensuring the data is loaded successfully


#tockenising the sample data
tidy_data <- MyData %>% tidytext::unnest_tokens(word, text)



#removing stop words
MyData_nostop <- tidy_data %>% dplyr::anti_join((get_stopwords()))




#Rodney Brooks frequent words, sought from most frequent to least frequent
Rodney_words <- MyData_nostop %>% dplyr::filter(speaker == "Rodney Brooks") %>%
  dplyr::count(speaker, word, sort = TRUE)

#Rodney Brooks frequent words, sought from most frequent to least frequent
Nathan_words <- MyData_nostop %>% dplyr::filter(speaker == "Nathan Wolfe") %>%
  dplyr::count(speaker, word, sort = TRUE)


#Visualizing the Word Frequency for both speakers
# Rodney Brooks
Rodney_words %>% dplyr::slice(n, n, 15) %>% dplyr::mutate(word = reorder(word, n)) %>%
  ggplot2::ggplot(aes(n, word)) + ggplot2::geom_col()+ggplot2::ggtitle("15 Most Frequent spoken words by Rodney Brooks")


#Nathan Wolfe
Nathan_words %>% dplyr::slice(n, n, 15) %>% dplyr::mutate(word = reorder(word, n)) %>%
  ggplot2::ggplot(aes(n, word)) + ggplot2::geom_col()+ggplot2::ggtitle("15 Most Frequent spoken words by Nathan Wolfe")


dplyr::bind_rows(Rodney_words, Nathan_words) %>% group_by(word) %>%
  filter(sum(n)>10) %>% ungroup() %>% 
  pivot_wider(names_from = "speaker", values_from = "n", values_fill = 0) %>%
  ggplot(aes(`Rodney Brooks`,`Nathan Wolfe`)) + geom_abline(color = "red", size = 1.5, alpha = 0.6, lty = 4) +
  geom_text_repel(aes(label = word), max.overlaps = 15) + coord_fixed()

### Emotion Analysis

# sentiment analysis
# emotions analysis based on the NRC dictionary
#there are 8 emotions calculated
text.Mydata <- tibble(text = str_to_lower(MyData$text))
emotions <- get_nrc_sentiment(text.Mydata$text) #extracting text
head(emotions)


emotions_summations <- colSums(emotions)
emotions_summations <- data.frame(count = emotions_summations, emotion = names(emotions_summations))
emotions_summations

#creating as plot for the summation of the emotions in all talks
ggplot(emotions_summations, aes(x = reorder(emotion, count), y = count))+
  geom_bar(stat = "identity")+ xlab("Emotions")+ ylab("Word Counts")

MyData.Rodney <- MyData[c(1,4),] #selecting Rodney's talks
MyData.Nathan <- MyData[c(2,3),] #selecting Nathan's talks

text.Mydata.Rodney <- tibble(text = str_to_lower(MyData.Rodney$text))
Rodney_emotions <- get_nrc_sentiment(text.Mydata.Rodney$text) #extracting Rodney's text

text.Mydata.Nathan <- tibble(text = str_to_lower(MyData.Nathan$text))
Nathan_emotions <- get_nrc_sentiment(text.Mydata.Nathan$text) #extracting Rodney's text

#obtaining the sums of column arrays for Rodney emotions
Rodney_emotions_summations <- colSums(Rodney_emotions)
Rodney_emotions_summations <- data.frame(count = Rodney_emotions_summations, Rodney_emotion = names(Rodney_emotions_summations))

#obtaining the sums of column arrays for Rodney emotions
Nathan_emotions_summations <- colSums(Nathan_emotions)
Nathan_emotions_summations <- data.frame(count = Nathan_emotions_summations, Nathan_emotion = names(Nathan_emotions_summations))

#plotting Rodney's emotions
ggplot(Rodney_emotions_summations, aes(x = reorder(Rodney_emotion, count), y = count))+

#plotting Nathan's emotions
ggplot(Nathan_emotions_summations, aes(x = reorder(Nathan_emotion, count), y = count))+

syuzhet_vector <- get_sentiment(Rodney_words, method = "syuzhet")
syuzhet_vector
