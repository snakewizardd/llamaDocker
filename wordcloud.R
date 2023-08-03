# Load required libraries
library(shiny)
library(ggwordcloud)
library(httr)
library(jsonlite)
library(shinycssloaders)
library(shinybusy)
library(shinyWidgets) 
library(data.table) 
library(dplyr) 
library(tm)


# Define the URL, header, and data
url <- "http://localhost:8080/completion"
headers <- c(
  "Content-Type" = "application/json"
)

llamaData <- function(
  prompt,
  temperature = 0.8,
  top_k = 40,
  top_p = 0.9,
  n_predict = 128,
  n_keep = 0,
  stream = FALSE,
  stop = NULL,
  tfs_z = 1.0,
  typical_p = 1.0,
  repeat_penalty = 1.1,
  repeat_last_n = 64,
  penalize_nl = TRUE,
  presence_penalty = 0.0,
  frequency_penalty = 0.0,
  mirostat = 0,
  mirostat_tau = 5.0,
  mirostat_eta = 0.1,
  seed = -1,
  ignore_eos = FALSE,
  logit_bias = "[]"
) {
  input_values <- list(
    `temperature` = as.numeric(temperature),
    `top_k` = as.integer(top_k),
    `top_p` = as.numeric(top_p),
    `n_predict` = as.integer(n_predict),
    `n_keep` = as.integer(n_keep),
    `stream` = as.logical(stream),
    `prompt` = as.character(prompt),
    `stop` = if (!is.null(stop)) strsplit(as.character(stop), ",")[[1]] else NULL,
    `tfs_z` = as.numeric(tfs_z),
    `typical_p` = as.numeric(typical_p),
    `repeat_penalty` = as.numeric(repeat_penalty),
    `repeat_last_n` = as.integer(repeat_last_n),
    `penalize_nl` = as.logical(penalize_nl),
    `presence_penalty` = as.numeric(presence_penalty),
    `frequency_penalty` = as.numeric(frequency_penalty),
    `mirostat` = match.arg(as.character(mirostat), c(0, 1, 2)),
    `mirostat_tau` = as.numeric(mirostat_tau),
    `mirostat_eta` = as.numeric(mirostat_eta),
    `seed` = as.integer(seed),
    `ignore_eos` = as.logical(ignore_eos),
    `logit_bias` = if (length(logit_bias) > 2) jsonlite::fromJSON(logit_bias) else jsonlite::fromJSON(sprintf("[ %s ]", as.character(logit_bias)))
  )
  data <- rjson::toJSON(input_values)
  response <- httr::POST(url, httr::add_headers(.headers = headers), httr::content_type("application/json"), body = data)
  return(httr::content(response))  # Return as a character vector
  
}
# Shiny UI
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
        .prompt-section {
          font-family: Consolas, monospace;
          font-size: 16px;
          background-color: #f1f1f1;
          border: 1px solid #ddd;
          padding: 15px;
          height: 200px;
          overflow-y: auto;
        }
        #submit_btn {
          font-size: 16px;
          background-color: #4CAF50;
          border: none;
          color: white;
          padding: 10px 16px;
          text-align: center;
          text-decoration: none;
          display: inline-block;
          margin: 4px 2px;
          cursor: pointer;
          border-radius: 4px;
        }
        #apiOutput {
          font-family: Consolas, monospace;
          font-size: 16px;
          background-color: #f9f9f9;
          border: 1px solid #ddd;
          padding: 15px;
          height: 300px;
          overflow-y: auto;
          white-space: pre-wrap;
        }
      "))
  ),
  # Add in UI
  add_busy_spinner(spin = "fading-circle"),  
  titlePanel("Word Cloud Generator"),
  sidebarLayout(
    sidebarPanel(
      # Input options for LLaMA API
      textAreaInput("prompt_input", "Prompt", value = "", rows = 10),
      numericInput("temperature_input", "Temperature", value = 0.8),
      numericInput("top_k_input", "Top K", value = 40),
      numericInput("top_p_input", "Top P", value = 0.9),
      numericInput("n_predict_input", "Number of Tokens to Predict", value = 128),
      numericInput("n_keep_input", "Number of Tokens to Keep", value = 0),
      actionButton("generate_wordcloud_btn", "Generate Word Cloud")
    ),
    mainPanel(
      # Output for the word cloud
      verbatimTextOutput("apiOutput"),
      plotOutput("wordcloud_output")
    )
  )
)


stop_words <- stopwords("en")


# Shiny Server
server <- function(input, output,session) {
  
  
  apiData <- eventReactive(input$generate_wordcloud_btn, {
    llamaData(
      prompt = as.character(input$prompt_input),
      temperature = as.numeric(input$temperature_input),
      top_k = as.integer(input$top_k_input),
      top_p = as.numeric(input$top_p_input),
      n_predict = as.integer(input$n_predict_input),
      n_keep = as.integer(input$n_keep_input)
    )
  })
  
  output$apiOutput <- renderPrint({
    apiData()$content
  })
  



  output$wordcloud_output <- renderPlot({
    data <- data.frame(words = strsplit(apiData()$content, " ")) %>% 
      `colnames<-`('word') %>% 
      group_by(word) %>% 
      summarize(frequency = length(word)) %>% 
      arrange(desc(frequency))

  data <- data %>% filter(word %in% stop_words == FALSE)

  if(nrow(data)>100){

    data <- data[1:100,]
  }
    
    plot <- ggplot(
      data,
      aes(
        label = word, size = frequency,
        color = factor(sample.int(10, nrow(data), replace = TRUE))
      )
    ) +
      geom_text_wordcloud_area() +
      scale_size_area(max_size = 24) +
      theme_minimal()
    
    plot
  
  })
  

  
}

# Run the Shiny app
shinyApp(ui, server)