#UI FILE

#if(!exists("foo", mode="function")) source("auth.R")
library(twitteR)

api_key = "PU3IyyYDiySO8QueqkVG85c9d"
api_secret = "7UGlu2R2Y0aUNg1ZwsqC5Z6MOdrAVGlp7Z2UypPS37NWvtwR6N"
access_token = "3883898413-qkvuY6Grk2mdHL9gXvCw42bSF3iGlvVAuM4AYdd"
access_token_secret = "GbLCs8dFwkutWUD2yBJspBvxBpOCaQepfykfH9krEEvLE"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

library(shiny)

shinyUI(fluidPage(
  headerPanel("Sentiment Analysis of Tweets"),
  sidebarPanel( textInput("term", "Enter Term", ""),
                sliderInput("count",
                            label = "Tweets to Fetch:",
                            min = 0, max = 800, value = 100),
                selectInput("lang","Select Language",
                            c("English"="en",
                              "Hindi"="hi",
                              "Spanish"="es"), selected = "en"),
                submitButton(text="Run")),
  mainPanel(
    h4("Analysis Results"),
    plotOutput("wordCloud"),
    plotOutput("barPlot"))
))