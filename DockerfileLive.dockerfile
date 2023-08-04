FROM ubuntu_llama_image_core

COPY ./prompts/ /home/llama.cpp_dir/prompts

COPY ./runprogram.sh /home/llama.cpp_dir
WORKDIR /home/llama.cpp_dir
RUN chmod 555 runprogram.sh 

#WORKDIR /home/llama.cpp_dir/
#CMD ttyd --writable bash -c "./runprogram.sh"

WORKDIR /
#COPY ./package.json /home/llama.cpp_dir/examples/server
#COPY ./chatApp.mjs /home/llama.cpp_dir/examples/server
COPY ./app.R /home/llama.cpp_dir/
COPY ./wordcloud.R /home/llama.cpp_dir/
COPY ./hf.R /home/llama.cpp_dir/


COPY ./startup.sh /home/llama.cpp_dir
WORKDIR /home/llama.cpp_dir
RUN chmod 555 startup.sh 

#WORKDIR /
#WORKDIR /home/llama.cpp_dir/examples/server 
#RUN npm install 

WORKDIR / 
#WORKDIR /home/llama.cpp_dir/


EXPOSE 8080
#EXPOSE 3000 
EXPOSE 3838
EXPOSE 7681

CMD ["/home/llama.cpp_dir/startup.sh"]
#CMD ./server -m ./models/7B/ggml-model-q4_0.bin & node ./examples/server/chatApp.mjs
#CMD ./server -m ./models/7B/ggml-model-q4_0.bin 
