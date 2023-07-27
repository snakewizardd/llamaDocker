#!/bin/bash
#./main -m ./models/7B/ggml-model-q4_0.bin -n 1024 --repeat-penalty 1.0 --instruct --color -i -r "User:" -f ./prompts/blank.txt

#./main -m ./models/7B/ggml-model-q4_0.bin --interactive-first --prompt "As a large language model I can offer my services to you as "
./main -m ./models/7B/ggml-model-q4_0.bin \
-n 5000 \
--n-predict 2500 \
-c 2500 \
--ctx-size 2500 \
--keep -1 \
--temp .8 \
--repeat-penalty 1.1 \
--repeat-last-n -1 \
--color -i -r "User:" \
--top-k 40 \
--top-p .9 \
--tfs 1.0 \
--typical 1 \
--mirostat 2 \
--mirostat-lr .85 \
--mirostat-ent 5.0 \
--mlock \
--batch-size 512 \
--interactive-first \
-t 6 \
-f ./prompts/crazy.txt
