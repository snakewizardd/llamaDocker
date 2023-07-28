FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    sudo

RUN sudo apt install -y python3-pip 
RUN yes | sudo apt install gfortran 
RUN yes | sudo apt install gcc 
RUN yes | sudo apt install git  

COPY requirements.txt .

RUN pip install -r requirements.txt

WORKDIR /
RUN yes | sudo apt-get install build-essential cmake git libjson-c-dev libwebsockets-dev
RUN git clone https://github.com/tsl0922/ttyd.git
RUN cd ttyd && mkdir build && cd build
WORKDIR /ttyd/build
RUN cmake ..
RUN make && make install 

RUN yes | sudo apt install curl

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN sudo apt-get install -y nodejs

RUN npm install -g pm2
RUN npm install -g node-fetch


RUN mkdir /home/llama.cpp_dir
COPY ./llama.cpp_dir/ /home/llama.cpp_dir

COPY ./prompts/ /home/llama.cpp_dir/prompts

COPY ./runprogram.sh /home/llama.cpp_dir
WORKDIR /home/llama.cpp_dir
RUN chmod 555 runprogram.sh 

WORKDIR /home/llama.cpp_dir/
#CMD ttyd --writable bash -c "./runprogram.sh"

WORKDIR /
COPY ./package.json /home/llama.cpp_dir/examples/server
COPY ./chatApp.mjs /home/llama.cpp_dir/examples/server

WORKDIR /home/llama.cpp_dir/examples/server 
RUN npm install 

WORKDIR / 
WORKDIR /home/llama.cpp_dir/


EXPOSE 8080
EXPOSE 3000 
#CMD ./server -m ./models/7B/ggml-model-q4_0.bin & node ./examples/server/chatApp.mjs
#CMD ./server -m ./models/7B/ggml-model-q4_0.bin 
