# sentiment-Analysis
Natural Language Processing, Text analysis, Computational Linguistics
##
---
title: "MA331-Coursework"
subtitle: "Text analytics of the TED talks by Rodney Brooks and Nathan Wolfe"
author: "2112290-Kunal-Solanki"
output: html_document
---

```{r setup, include=FALSE}
#this chunk initializes our html file, so that the code chunks are not printed.
knitr::opts_chunk$set(echo = FALSE)   ## DON'T ALTER THIS.
```

# **INTRODUCTION**
The main focus of this paper is to carry out a comparative classification analysis between 2 speakers,
and establish a comparison between different field of studies and topics. To further see the difference, I perform an emotional analysis. The TED Talk speakers analyzed in this 
paper are Rodney Brooks and Nathan Wolfe.\
Rodney Brooks talks in two scenarios;

a) On the topic of robots entering our life, he contends that it will occur sooner than most people anticipate. However, he asserts, there must first be an obnoxious robot, followed by a less obnoxious robot. As a result, Rodney Brooks retains a positive view toward robots.\
\
b) On the question of how humans may be able to totally depend on robots, he explains how we currently do so in a number of contexts. He tackles all sides of the discussion, from when robots may be useful to when they may represent a danger to humans.\
\
On the other hand, Nathan Wolfe discusses on two issues in different talks;\
\
a) The origin of the HIV virus, together with the issues on how to spot pandemics fast and efficient, and ohw to control this situation, since viruses often come from animal, and not human beings in many cases.\ 
\
b) The issue on exploration of the earth, on matter of life forms especially microorganisms.

From Rodney Brooks talk, it is much expected that his emotions will majorly entail emotions of anticipation, fear and trust. Nathan Wolfe's emotions might seem to be of huge difference with that of Rodney Brooks, since Nathan is giving an account on interesting features of the earth. However, this analysis will distinguish between the four talks.\

# **METHODS**
To accomplish the objectives of this project, Rstudio was used, which contains a variety
of packages to help in text analytics. The following procedures were undertaken:

## 1. Installing and Loading R packages
The following packages are useful in this project, and they were installed and loaded:\
* **dsEssex**, which contained the Ted Talk text data.\
* **wordcloud** package, which was used in plotting a wordcloud (Sanil, 2020).\
* **ggplot2** which is used as a plotting tool\
* **tidytext** and tidyverse, which are used in cleaning the data.\
* **snowballc**, which is used for stemming advanced words into their natural form.\
Other useful packages are mainly contained in tidyverse and tidytext.

```{r include = FALSE}
##Loading the required packages
###library(dplyr) #data handling
#library(tidytext)
#library(tm)
#library(ggplot2) #plotting
#library(syuzhet) #sentiment analysis
#library(ggrepel) #comparison analysis
#loading ted_talks data
data(ted_talks)
```

## 2. Reading the TED Talk data set and sub-setting it appropriately
From the dsEssex package, the text data "ted_talk" was loaded. Next, since analysis is not based on the whole data set,
I filtered the data to obtain only talks by Rodney Brooks and Nathan Wolfe. This was stored in an object called 
"MyData." 

## 3. Cleaning the data set
The cleaning and organization of text data starts with small adjustments such as the deletion of special characters. For special characters such as /, @, and #, the tmmap function in the tidytext package substitutes a space. Following that, the text is converted to lower case and any extraneous white space is removed. The most frequently occurring terms in a language are subsequently removed as they convey little meaningful information. They should be removed before proceeding with the analysis. This will also involve tockenising, stopword removal and converting to lowercase.\

Finally, stemming was used to return the text to its original state. Stemming lowers the sentence to its most basic form. Because individual words must be examined in their totality, this step is typically optional.

## 4. Establishing Occurence of words
After cleaning the text data, I count the occurrences of each phrase to discover hot or trending themes. This may be performed by using the text mining package's TermDocumentMatrix function, which creates a Document Matrix (a table containing the frequency of terms)(Sanil, 2020). Further, these frequent words were then plotted to access the distribution, and then a plot was constructed to visualize keywords. 

## 5. Word Association and Sentiment Analysis
In this section, I perform a correlation analysis in order to assess existing relationships between words. This technique is be used to discover which words appear most frequently in connection with the most regularly occurring keywords in survey answers, providing for a better understanding of the context surrounding these phrases. This forms the basis of classifying words with their emotions. Sentiment analysis helps me to categorize emotions as good, neutral, or negative. They may also be presented quantitatively in order to better comprehend the level of positive or negative emotional intensity transmitted in a text.

## 6. Emotion and Sentiment Classification
This process entailed the main mission of this project. The two sorts of emotions are primary emotion, which comprises joy, sadness, wrath, fear, contempt, and surprise, and secondary emotion, which creates a mental image associated with the memory or primary emotion.\
To understand how this works, explore the getnrcsentiments function, which produces a data frame with each row representing a sentence from the original file. The next stage is to produce two plot charts to aid in the visual understanding of the emotions contained in this survey text, which will require some extra data processing and cleaning prior to plotting charts.

# **RESULTS**
In this section, I perform an analysis in R markdown and present my finding, with an accompanying critical evaluation and explanation of the Ted Talk of the two speakers. Visualizations are made and important tables presented, in order to graps the distributions of words in the Ted Talks, and help examine the emotions in the talks.\
Based on the  methods described above the same process is adhered to in this section, in ensure readability.


### Loading, Tockenising and Cleaning
First, loading, sub-setting the data set, and tockenising the data. The table of the resulting sample was obtained as:
```{r}
# creating a data frame for two speakers allocated to
# Rodney Brooks and Nathan Wolfe
# storing in object "MyData"

#MyData <- ted_talks %>%
  #filter(speaker %in% c("Rodney Brooks", "Nathan Wolfe"))
#head(MyData) #ensuring the data is loaded successfully
```

```{r}
#tockenising the sample data
tidy_data <- MyData %>% tidytext::unnest_tokens(word, text)
```

Next, removing stopwords, filler words and commonly used words with no crucial meaning were cleaned out, and join by "word":
```{r}
#removing stop words
MyData_nostop <- tidy_data %>% dplyr::anti_join((get_stopwords()))
```

### Speakers' Word Identification
Here, I use the count function to count the words of Rodney Brooks and Nathan Wolfe. It is important to sought out the most frequent words to the least frequent words. After soughting, visualizing the frequent words produced the visualization below. It is worth noting that there are too many words that are in this context. We thus visualize the first 15 frequent words for each speaker.

```{r}
#Rodney Brooks frequent words, sought from most frequent to least frequent
Rodney_words <- MyData_nostop %>% dplyr::filter(speaker == "Rodney Brooks") %>%
  dplyr::count(speaker, word, sort = TRUE)

#Rodney Brooks frequent words, sought from most frequent to least frequent
Nathan_words <- MyData_nostop %>% dplyr::filter(speaker == "Nathan Wolfe") %>%
  dplyr::count(speaker, word, sort = TRUE)
```

```{r}
#Visualizing the Word Frequency for both speakers
# Rodney Brooks
Rodney_words %>% dplyr::slice(n, n, 15) %>% dplyr::mutate(word = reorder(word, n)) %>%
  ggplot2::ggplot(aes(n, word)) + ggplot2::geom_col()+ggplot2::ggtitle("15 Most Frequent spoken words by Rodney Brooks")
```

```{r}
#Nathan Wolfe
Nathan_words %>% dplyr::slice(n, n, 15) %>% dplyr::mutate(word = reorder(word, n)) %>%
  ggplot2::ggplot(aes(n, word)) + ggplot2::geom_col()+ggplot2::ggtitle("15 Most Frequent spoken words by Nathan Wolfe")
```
\
From the plots above, it is seen that Rodney and Nathan speak of totally different subjects. The most words Nathan use in his talks are "robot" and "robots", "going" and "think". Nathan's most spoken words are "us", "information", and "viruses."

### Comparative Study between Rodney Brooks and Nathan Wolfe.
In this section, I derive the relationshp between the two speaker's talks. Here, I select 10-times similar words in each speaker.\
\
```{r}
dplyr::bind_rows(Rodney_words, Nathan_words) %>% group_by(word) %>%
  filter(sum(n)>10) %>% ungroup() %>% 
  pivot_wider(names_from = "speaker", values_from = "n", values_fill = 0) %>%
  ggplot(aes(`Rodney Brooks`,`Nathan Wolfe`)) + geom_abline(color = "red", size = 1.5, alpha = 0.6, lty = 4) +
  geom_text_repel(aes(label = word), max.overlaps = 15) + coord_fixed()
```
\
\
From the comparison above, it is seen that similarities in choice of words is not that strong, since the maximum number of words is set to 10, and most of the words fall away from the line.\

### Emotion Analysis
Next, we assess the NRC sentiment to derive different emotions in each of the talks, and the distribution of each type of emotion. The NRC dictionary was used, which contains 8 emotional features; anger, anticipation, disgust, fear, joy, sadness, surprise, trust, negative and positive. The following was obtained.

```{r}
# sentiment analysis
# emotions analysis based on the NRC dictionary
#there are 8 emotions calculated
text.Mydata <- tibble(text = str_to_lower(MyData$text))
emotions <- get_nrc_sentiment(text.Mydata$text) #extracting text
head(emotions)
```

\
Viewing the head of the emotions calculated in each of the talks, it is observed that overall, each talk has positive sentiments. The first and last talks are for Rodney Brooks, the second and third for Nathan Wolfe.To assess the summary by columns for each of the emotions, it was observe that the talks were more positive, followed by negative and trust. The least appearing emotion is anger and anticipation. The distribution of emotions is:\
\

```{r}
emotions_summations <- colSums(emotions)
emotions_summations <- data.frame(count = emotions_summations, emotion = names(emotions_summations))
emotions_summations
```
The above distribution can be visualized as:
```{r}
#creating as plot for the summation of the emotions in all talks
ggplot(emotions_summations, aes(x = reorder(emotion, count), y = count))+
  geom_bar(stat = "identity")+ xlab("Emotions")+ ylab("Word Counts")
```
\
\The above is the summation of emotions, which can be used a lot to describe the type of talk are in Ted Talks. We can also find out the emotion in each of the speakers, and visualize it as shown below:\
\
```{r}
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
  geom_bar(stat = "identity")+ xlab("Emotions")+ ylab("Word Counts") + ggtitle("Rodney's Emotion Distribution")
```
```{r}
#plotting Nathan's emotions
ggplot(Nathan_emotions_summations, aes(x = reorder(Nathan_emotion, count), y = count))+
  geom_bar(stat = "identity")+ xlab("Emotions")+ ylab("Word Counts") + ggtitle("Nathan's Emotion Distribution")
```
\
\Accessing sentiment scores, we derive the syuzhet vector. According to the Syuzhet vector, the first member has a value of 19.05. This means that the total of all significant words in the text file's first response(line) equals 19.05. The syuzhet approach utilizes a decimal scale for gauging emotions, ranging from negative to positive values (marking the most negative) (indicating most positive) (indicating most positive).
```{r}
syuzhet_vector <- get_sentiment(Rodney_words, method = "syuzhet")
syuzhet_vector
```


# **DISCUSSION**
The objectives of this paper have been achieved since we have established the major differences and similarities in the talks between Rodney Brooks and Nathan Wolfe. The difference is in the choice of words, since their similarities are very different. This confirms the claim that they are from different profession and areas of study; Rodney is in to technology and speaks technological terms, while Nathan is more of a biologist and historian. Their similarities is in the emotion they produce in their talk, despite their difference in subject.\
\
The main challenge in this project is limited by employing advance tools to evaluate my ideas about text analytics. However, important aspects have been evaluated.Future investigations could try and develop machine learning in text analytics, to make predictive models on text.
