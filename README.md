# Purpose

This repo is a working repository for developing and building on llama.cpp in Docker

The image is a ubuntu image that contains 
- python 
- ttyd 
- node 
- R 
- llama.cpp repo (no model binaries included)
- misc bash scripts

If you create a models folder in llama.cpp and start up the Docker service, it will start an API server for you to talk to Llama2 via llama.cpp/examples/server 

The Docker compose build starts up a ttyd service, llama.cpp API, and an rshiny app

app.R
![image](https://github.com/snakewizardd/llamaDocker/assets/83378208/e58ae0d9-9152-4380-bd3c-3b75138e56d5)
![image](https://github.com/snakewizardd/llamaDocker/assets/83378208/9cd53c18-aede-48c2-af5a-9e5d351a9245)

wordcloud.R
![image](https://github.com/snakewizardd/llamaDocker/assets/83378208/1af72655-067c-4982-b44f-ec5c255afc52)

