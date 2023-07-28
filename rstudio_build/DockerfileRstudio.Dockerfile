FROM rocker/rstudio:latest

RUN apt-get update && apt-get install -y \
    sudo

RUN sudo apt install -y python3-pip 
RUN yes | sudo apt install gfortran 
RUN yes | sudo apt install gcc 
RUN yes | sudo apt install git  

COPY requirements.txt .

RUN pip install -r requirements.txt

RUN mkdir /home/rstudio/llama.cpp_dir
COPY ./llama.cpp_dir/ /home/rstudio/llama.cpp_dir
#WORKDIR /home/rstudio/llama.cpp_dir/
#CMD make 

WORKDIR /
RUN yes | sudo apt-get install build-essential cmake git libjson-c-dev libwebsockets-dev
RUN git clone https://github.com/tsl0922/ttyd.git
RUN cd ttyd && mkdir build && cd build
WORKDIR /ttyd/build
RUN cmake ..
RUN make && make install 


WORKDIR /
RUN Rscript -e "install.packages('fs')"
RUN Rscript -e "install.packages('shiny')"
RUN Rscript -e "install.packages('data.table')"


COPY ./app.R /home/rstudio/llama.cpp_dir
RUN mkdir /home/rstudio/llama.cpp_dir/www
COPY ./www /home/rstudio/llama.cpp_dir/www
COPY ./prompts/ /home/rstudio/llama.cpp_dir/prompts

COPY ./runprogram.sh /home/rstudio/llama.cpp_dir
WORKDIR /home/rstudio/llama.cpp_dir
RUN chmod 555 runprogram.sh 

WORKDIR /home/rstudio/llama.cpp_dir/
CMD ttyd --writable bash -c "./runprogram.sh"
#EXPOSE 3838
#CMD ["R", "-e","shiny::runApp('/home/rstudio/llama.cpp_dir/',host='0.0.0.0',port = 3838)"]

#RUN chmod 777 ./prompts/newText.txt

#EXPOSE 8787
