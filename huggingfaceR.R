#devtools::install_github("farach/huggingfaceR")
#reticulate::install_miniconda()
#hf_python_depends()

library(huggingfaceR)

distilBERT <- hf_load_pipeline(
  model_id = "distilbert-base-uncased-finetuned-sst-2-english", 
  task = "text-classification"
)

distilBERT("I like you. I love you")

