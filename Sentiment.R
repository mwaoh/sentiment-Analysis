### Extracted automatically from the index.Rmd file using 
### knitr::purl("../W7/index.Rmd", output = "../W7/R-script.R")
###============================================================

library(tidyverse)
library(tidytext)
library(stopwords)
library(ggrepel)
library(scales)
library(plotly)
library(here)
library(gradethis)
require(dsEssex)
library(ggrepel)


theme_set(theme_light())

data(ted_talks)
tidy_talks <- ted_talks %>% unnest_tokens(word, text)


## ----library-tidytext, exercise=TRUE--------------------------------------------------------------------------------------------------------------------------------------------
# load the tidytext package



## ----library-tidytext-solution--------------------------------------------------------------------------------------------------------------------------------------------------
# load the tidytext package
library(tidytext)


## ----library-tidytext-check-----------------------------------------------------------------------------------------------------------------------------------------------------
grade_code("Make sure to click \"Submit Answer \" on exercises throughout the tutorial to check the step you have done. There are also hints, solutions, and other content you can view at some exercise.")


## ----library-tidyverse, exercise=TRUE-------------------------------------------------------------------------------------------------------------------------------------------
# load the tidyverse and tidytext packages
library(___)
library(___)


## ----library-tidyverse-solution-------------------------------------------------------------------------------------------------------------------------------------------------
# load the tidyverse and tidytext packages
library(tidyverse)
library(tidytext)


## ----library-tidyverse-check----------------------------------------------------------------------------------------------------------------------------------------------------
grade_code("The tidyverse metapackage contains dplyr, ggplot2, tidyr, and other R packages for data science. The tidytext contains functions for text analysis using tidy data principles.")


## ----ted-talks, exercise=TRUE---------------------------------------------------------------------------------------------------------------------------------------------------
# load the 'dsEssex' package
library(___)
# load the 'ted_talks' data
data(___)
# glimpse `ted_talks` to see what is in the data set
dplyr::glimpse(___)


## ----ted-talks-solution---------------------------------------------------------------------------------------------------------------------------------------------------------
# load the 'dsEssex' package
library(dsEssex)
# load the 'ted_talks' data
data(ted_talks)
# glimpse `ted_talks` to see what is in the data set
dplyr::glimpse(ted_talks)


## ----ted-talks-check------------------------------------------------------------------------------------------------------------------------------------------------------------
grade_code()


## ----tidy-talks, exercise=TRUE--------------------------------------------------------------------------------------------------------------------------------------------------
tidy_talks <- ted_talks %>% 
  ___(word, text)


## ----tidy-talks-solution--------------------------------------------------------------------------------------------------------------------------------------------------------
tidy_talks <- ted_talks %>% 
  unnest_tokens(word, text)


## ----tidy-talks-check-----------------------------------------------------------------------------------------------------------------------------------------------------------
grade_code("Think about the syntax of this function a bit, because you'll be using it over and over again. We piped in the original, non-tidy data set. We gave an argument that we want to tokenize _into_ and an argument that we are tokenizing from.")


## ----display-tidy-ted, exercise=TRUE--------------------------------------------------------------------------------------------------------------------------------------------
# display the output of the tidy_talks
___


## ----display-tidy-ted-solution--------------------------------------------------------------------------------------------------------------------------------------------------
# display the output of the tidy_talks
tidy_talks


## ----display-tidy-ted-check-----------------------------------------------------------------------------------------------------------------------------------------------------
grade_code("Think about what `unnest_tokens()` did here.")


## ----ted-bigram, exercise=TRUE--------------------------------------------------------------------------------------------------------------------------------------------------
ted_bigrams <- ted_talks %>% 
  ___(bigram, text, token = "ngrams", n = 2)

ted_bigrams


## ----ted-bigram-solution--------------------------------------------------------------------------------------------------------------------------------------------------------
ted_bigrams <- ted_talks %>% 
  unnest_tokens(bigram, text, token = "ngrams", n = 2)

ted_bigrams


## ----ted-bigram-check-----------------------------------------------------------------------------------------------------------------------------------------------------------
grade_code("The bigrams slide along the text to create overlapping sequences of two words. Notice what did and did not change in the arguments of the `unnest_tokens()` function from tokenizing to single words. We used the `token` argument to specify a non-default tokenizer, and we specified the n-gram order of 2.")


## ----top-ted-term, exercise=TRUE, warning=FALSE, message=FALSE, error=FALSE-----------------------------------------------------------------------------------------------------
tidy_talks %>%
  ___(word, sort = TRUE)


## ----top-ted-term-solution------------------------------------------------------------------------------------------------------------------------------------------------------
tidy_talks %>%
  count(word, sort = TRUE)


## ----top-ted-term-check---------------------------------------------------------------------------------------------------------------------------------------------------------
grade_code(correct = "That was just one line of code, but these identified words are not very interesting!")


## ----display-stop-words, exercise=TRUE------------------------------------------------------------------------------------------------------------------------------------------
get_stopwords()
get_stopwords(language = ___)


## ----display-language-codes-----------------------------------------------------------------------------------------------------------------------------------------------------
stopwords_getlanguages(source = "snowball")


## ----stop-word, exercise=TRUE, warning=FALSE, message=FALSE, error=FALSE--------------------------------------------------------------------------------------------------------
tidy_talks %>%
  anti_join(___) %>%           # remove stop words
  count(___)                   # count words & sort them by n (the counts)


## ----stop-word-solution---------------------------------------------------------------------------------------------------------------------------------------------------------
tidy_talks %>%
  anti_join(get_stopwords()) %>%    # remove stop words
  count(word, sort = TRUE)          # count words & sort them by n (the counts)


## ----stop-word-check------------------------------------------------------------------------------------------------------------------------------------------------------------
grade_code(correct = "These are now more interesting words and show the focus of TED talks.")


## ----stop-word-viz, exercise=TRUE, warning=FALSE, message=FALSE, error=FALSE----------------------------------------------------------------------------------------------------
tidy_talks %>%
  ___ %>%         # remove stop words
  count(word, sort = TRUE) %>%      # count words & sort them by n (the counts)
  slice_max(n, n = 20) %>%          # select the top 20 rows ordered by n (redundant because they are already sorted, but this argument is mandatory for this function)
  mutate(word = reorder(word, n)) %>%     # To convert the `word` from character into factor to maintain the order. Otherwise, ggplot2 would plot them in an alphabetic order!
  ggplot(aes(___, ___)) + geom_col()    # insert `n` on the x-axis and `word` on the y-axis


## ----stop-word-viz-solution-----------------------------------------------------------------------------------------------------------------------------------------------------
tidy_talks %>%
  anti_join(get_stopwords()) %>%    # remove stop words
  count(word, sort = TRUE) %>%      # count words & sort them by n (the counts)
  slice_max(n, n = 20) %>%          # select the top 20 rows ordered by n (redundant because they are already sorted, but this argument is mandatory for this function)
  mutate(word = reorder(word, n)) %>%     # To convert the `word` from character into factor to maintain the order. Otherwise, ggplot2 would plot them in an alphabetic order!
  ggplot(aes(n, word)) + geom_col()    # insert `n` on the x-axis and `word` on the y-axis


## ----stop-word-viz-check--------------------------------------------------------------------------------------------------------------------------------------------------------
grade_code(correct = "The word \"laughter\" is so high because the transcripts include it when the audience laughed!")


## ----ted-final-pivot, exercise=TRUE, warning=FALSE, message=FALSE, error=FALSE--------------------------------------------------------------------------------------------------
tidy_talks %>%
  ___(speaker %in% c("Ken Robinson", "Hans Rosling")) %>%        # keep only the words spoken by Ken Robinson and Hans Rosling
  ___ %>%                                                        # remove stop words
  ___ %>%                                                        # count with two arguments
  group_by(word) %>%                                             # Group data by word
  ___(sum(n) > 10) %>%                                           # filter by sum of the frequencies within each group (word)
  ungroup() %>%                                                  # Ungroup
  pivot_wider(names_from = "speaker", values_from = "n", values_fill = 0) # convert to wide format: get column names from the speaker variable


## ----ted-final-pivot-solution---------------------------------------------------------------------------------------------------------------------------------------------------
tidy_talks %>%
  filter(speaker %in% c("Ken Robinson", "Hans Rosling")) %>%     # keep only the words spoken by Ken Robinson and Hans Rosling
  anti_join(get_stopwords()) %>%                                 # remove stop words
  count(speaker, word) %>%                                       # count with two arguments
  group_by(word) %>%                                             # Group data by word
  filter(sum(n) > 10) %>%                                        # filter by sum of the frequencies within each group (word)
  ungroup() %>%                                                  # Ungroup
  pivot_wider(names_from = "speaker", values_from = "n", values_fill = 0) # convert to wide format: get column names from the speaker variable


## ----ted-final-pivot-check------------------------------------------------------------------------------------------------------------------------------------------------------
grade_code()


## ----ted-final-viz, fig.width=6, fig.height=6, exercise=TRUE, warning=FALSE, message=FALSE, error=FALSE-------------------------------------------------------------------------
library(___)

tidy_talks %>%
  filter(speaker %in% c("Ken Robinson", "Hans Rosling")) %>%
  anti_join(get_stopwords()) %>%
  count(speaker, word) %>%
  group_by(word) %>%
  filter(sum(n) > 10) %>%
  ungroup() %>%
  pivot_wider(names_from = "speaker", values_from = "n", values_fill = 0) %>%
  ggplot(aes(`Ken Robinson`, `Hans Rosling`)) +
  geom_abline(color = "red", size = 1.2, alpha = 0.8, lty = 2) +
  # use the special ggrepel geom for nicer text plotting
  ___(aes(label = word), max.overlaps = 15)


## ----ted-final-viz-solution-----------------------------------------------------------------------------------------------------------------------------------------------------
library(ggrepel)

tidy_talks %>%
  filter(speaker %in% c("Ken Robinson", "Hans Rosling")) %>%
  anti_join(get_stopwords()) %>%
  count(speaker, word) %>%
  group_by(word) %>%
  filter(sum(n) > 10) %>%
  ungroup() %>%
  pivot_wider(names_from = "speaker", values_from = "n", values_fill = 0) %>%
  ggplot(aes(`Ken Robinson`, `Hans Rosling`)) +
  geom_abline(color = "red", size = 1.2, alpha = 0.8, lty = 2) +
  # use the special ggrepel geom for nicer text plotting
  geom_text_repel(aes(label = word), max.overlaps = 15)


## ----ted-final-viz-check--------------------------------------------------------------------------------------------------------------------------------------------------------
grade_code(correct = "Ken Robinson spoke about education while Hans Rosling spoke about statistics in medical studies, but both people spoke about children and being different.")
