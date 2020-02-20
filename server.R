library(tm)
library(shiny)
library(twitteR)
library(syuzhet)
library(wordcloud)

shinyServer(function(input, output) {
  rawData = reactive({
    tweets = searchTwitter(input$term, n=input$count, lang=input$lang)
    tweets = twListToDF(tweets)
    
    })
  
  #Wordcloud
  output$wordCloud = renderPlot({
    set.seed(1000)
    #Build Corpus
    corpus <- iconv(rawData()$text, to = "utf-8")
    corpus <- Corpus(VectorSource(corpus))
    
    #Data Cleaning
    corpus <- tm_map(corpus, tolower)
    corpus <- tm_map(corpus, removePunctuation)
    corpus <- tm_map(corpus, removeNumbers)
    clean_dmt <- tm_map(corpus, removeWords, stopwords('english'))
    removeURL <- function(x) gsub('http[[:alnum:]]*','',x)
    clean_dmt <- tm_map(clean_dmt, content_transformer(removeURL))
    clean_dmt <- tm_map(clean_dmt, stripWhitespace)
    
    #Term Document Matrix
    tdm_dmt <- TermDocumentMatrix((clean_dmt))
    tdm_dmt <- as.matrix(tdm_dmt)
    w = sort(rowSums(tdm_dmt), decreasing = TRUE)
    wordcloud(words = names(w), freq = w, random.order = FALSE, colors = brewer.pal(8, 'Dark2'))
  })  
  
  #Sentiment Bar Plot
  output$barPlot = renderPlot({
    
    tweets.text <- gsub("[[:punct:]]"," ",rawData()$text)
    tweets.text <- gsub("http\\w+"," ", tweets.text)
    tweets.text <- tolower(tweets.text)
    tweets.text <- gsub("rt"," ",tweets.text)
    tweets.text <- gsub("@\\w+"," ",tweets.text)
    tweets.text <- gsub("[|\t]{2,}"," ",tweets.text)
    tweets.text <- gsub("^ ","",tweets.text)
    tweets.text <-  gsub(" $","",tweets.text)
    tweets.text <- gsub('[[:punct:]]','',tweets.text)
    tweets.text <- gsub('[[:cntrl:]]','',tweets.text)
    tweets.text <- gsub('\\d+','',tweets.text)
    tweets.text <- gsub('\n','',tweets.text)

    #Sentiment Analysis
  dmt_scr <<- get_nrc_sentiment(tweets.text)
  barplot(colSums(dmt_scr), las = 2, col = rainbow(10), ylab = 'Tweet Count', main = 'Sentiment Scores for Tweets')
  })

})