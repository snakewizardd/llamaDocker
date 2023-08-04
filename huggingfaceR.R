#devtools::install_github("farach/huggingfaceR")
#reticulate::install_miniconda()
#hf_python_depends()

library(huggingfaceR)

distilBERT <- hf_load_pipeline(
  model_id = "distilbert-base-uncased-finetuned-sst-2-english", 
  task = "text-classification"
)

distilBERT("I like you. I love you")

# Load required libraries
library(httr)
library(jsonlite)
library(data.table) 
library(dplyr) 


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


devOpsPrompt <- llamaData(prompt = 'tell me a joke about DevOps')


sentimentPrompt <- distilBERT(devOpsPrompt$content)

sentimentPrompt[[1]]$label 
sentimentPrompt[[1]]$score 

promptCall <- llamaData(prompt='If it was sunny outside but then started to rain')$content
sentimentPromptCall <- distilBERT(promptCall)
sentimentLabel <- sentimentPromptCall[[1]]$label 
sentimentScore <- sentimentPromptCall[[1]]$label 


