
library(readr)
ted_talks_1 <- read_csv("C:/Users/admin/Desktop/Stack/ted_talks-1.csv")
View(ted_talks_1)

# load the data set
data("ted_talks_1")
library(magrittr)

#Filtering the two speakers from the data set.
Mydata <- ted_talks_1 %>%
 filter(speaker %in% c("Arthur Benjamin", "Philip Zimbardo"))




# show the first few rows of the data
head(ted_talks_1)

library(tidytext)
library(tidyverse) # to use %>%
tidy_talks <- ted_talks_1 %>% 
  tidytext::unnest_tokens(word, text)




#Identification of top words for certain speakers

Lewinsky_words <- ted_talks_nonstop %>%
  dplyr::filter(speaker == "Arthur Benjamin") %>% 
  dplyr::count(speaker, word, sort = TRUE)

#Visualization of top words

Lewinsky_words %>%
  dplyr::slice_max(n, n = 25) %>%
  dplyr::mutate(word = reorder(word, n)) %>%
  ggplot2::ggplot(aes(n, word)) + ggplot2::geom_col()


#Visualization of top words for a different speaker
Zander_words <- ted_talks_nonstop %>%
  dplyr::filter(speaker == "Philip Zimbardo") %>% 
  dplyr::count(speaker, word, sort = TRUE)
Zander_words %>% 
  dplyr::slice_max(n, n = 25) %>%
  dplyr::mutate(word = reorder(word, n)) %>%
  ggplot2::ggplot(aes(n, word)) + ggplot2::geom_col()

#Comparing speaker words using visualization
library(ggrepel)
dplyr::bind_rows(Lewinsky_words, Zander_words) %>%
  group_by(word) %>%
  filter(sum(n) > 10) %>%
  ungroup() %>%
  pivot_wider(names_from = "speaker", values_from = "n", values_fill = 0) %>%
  ggplot(aes(`Arthur Benjamin`, `Philip Zimbardo`)) +
  geom_abline(color = "black", size = 1.2, alpha = 0.75, lty = 3) +
  geom_text_repel(aes(label = word), max.overlaps = 15) +
  coord_fixed()


















