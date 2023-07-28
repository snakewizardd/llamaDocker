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

The Docker compose build also starts up the rshiny application found in this repo

The shinyapp contains controls for all of the API inputs allowed

![image](https://github.com/snakewizardd/llamaDocker/assets/83378208/2177901a-443f-475f-aa3c-b2176645f04e)
![image](https://github.com/snakewizardd/llamaDocker/assets/83378208/6e3bef8f-fc36-4fe3-8546-f731ac329bac)
