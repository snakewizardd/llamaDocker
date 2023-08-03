#!/bin/bash

ttyd --writable bash -c "./runprogram.sh" &

# Start the server in the background
./server -m ./models/7B/ggml-model-q4_0.bin --ctx-size 2048 -t 6 &

# Start the Shiny app
#R -e 'shiny::runApp("./app.R", port = 3838, host = "0.0.0.0")'
R -e 'shiny::runApp("./wordcloud.R", port = 3838, host = "0.0.0.0")'

