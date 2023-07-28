#!/bin/bash

# Start the server in the background
./server -m ./models/7B/ggml-model-q4_0.bin -t 6 &

# Start the Shiny app
R -e 'shiny::runApp("./app.R", port = 3838, host = "0.0.0.0")'
