library(shiny)
library(httr)
library(jsonlite)
library(shinycssloaders)
library(shinydashboard)
library(shinyWidgets)

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
  mirostat = "Disabled",
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
    `mirostat` = match.arg(as.character(mirostat), c("Disabled", "Mirostat", "Mirostat 2.0")),
    `mirostat_tau` = as.numeric(mirostat_tau),
    `mirostat_eta` = as.numeric(mirostat_eta),
    `seed` = as.integer(seed),
    `ignore_eos` = as.logical(ignore_eos),
    `logit_bias` = if (length(logit_bias) > 2) jsonlite::fromJSON(logit_bias) else jsonlite::fromJSON(sprintf("[ %s ]", as.character(logit_bias)))
  )
  
  data <- rjson::toJSON(input_values)
  response <- httr::POST(url, httr::add_headers(.headers = headers), httr::content_type("application/json"), body = data)
  return(content(response))  # Return as a character vector
}


ui <- dashboardPage(
  dashboardHeader(title = "Llama2 Generator"),
  dashboardSidebar(
    numericInput("temperature_input", "Temperature", value = 0.8),
    numericInput("top_k_input", "Top K", value = 40),
    numericInput("top_p_input", "Top P", value = 0.9),
    numericInput("n_predict_input", "Number of Tokens to Predict", value = 128),
    numericInput("n_keep_input", "Number of Tokens to Keep", value = 0),
    checkboxInput("stream_input", "Enable Stream", value = FALSE),
    textInput("prompt_input", "Prompt", value = ""),
    textInput("stop_input", "Stop Words (comma-separated)", value = ""),
    numericInput("tfs_z_input", "TFS Z", value = 1.0),
    numericInput("typical_p_input", "Typical P", value = 1.0),
    numericInput("repeat_penalty_input", "Repeat Penalty", value = 1.1),
    numericInput("repeat_last_n_input", "Last N Tokens for Repetition", value = 64),
    checkboxInput("penalize_nl_input", "Penalize Newline Tokens", value = TRUE),
    numericInput("presence_penalty_input", "Presence Penalty", value = 0.0),
    numericInput("frequency_penalty_input", "Frequency Penalty", value = 0.0),
    selectInput("mirostat_input", "Mirostat", choices = c("Disabled", "Mirostat", "Mirostat 2.0"), selected = "Disabled"),
    numericInput("mirostat_tau_input", "Mirostat Tau", value = 5.0),
    numericInput("mirostat_eta_input", "Mirostat Eta", value = 0.1),
    numericInput("seed_input", "Random Seed", value = -1),
    checkboxInput("ignore_eos_input", "Ignore End of Stream Token", value = FALSE),
    textInput("logit_bias_input", "Logit Bias", value = ""),
    actionButton("submit_btn", "Update")
  ),
  dashboardBody(
    withSpinner(verbatimTextOutput("apiOutput"))
  )
)

  server <- function(input, output) {
    gen <- eventReactive(input$submit_btn, {
      apiCall <- llamaData(
        prompt = as.character(input$prompt_input),
        temperature = as.numeric(input$temperature_input),
        top_k = as.integer(input$top_k_input),
        top_p = as.numeric(input$top_p_input),
        n_predict = as.integer(input$n_predict_input),
        n_keep = as.integer(input$n_keep_input),
        stream = as.logical(input$stream_input),
        stop = input$stop_input,
        tfs_z = as.numeric(input$tfs_z_input),
        typical_p = as.numeric(input$typical_p_input),
        repeat_penalty = as.numeric(input$repeat_penalty_input),
        repeat_last_n = as.integer(input$repeat_last_n_input),
        penalize_nl = as.logical(input$penalize_nl_input),
        presence_penalty = as.numeric(input$presence_penalty_input),
        frequency_penalty = as.numeric(input$frequency_penalty_input),
        mirostat = input$mirostat_input,
        mirostat_tau = as.numeric(input$mirostat_tau_input),
        mirostat_eta = as.numeric(input$mirostat_eta_input),
        seed = as.integer(input$seed_input),
        ignore_eos = as.logical(input$ignore_eos_input),
        logit_bias = input$logit_bias_input
      )
      
      return(apiCall$content)
    })
    
    output$apiOutput <- renderPrint({
      gen()
    })
  }
  
  

shinyApp(ui, server)
