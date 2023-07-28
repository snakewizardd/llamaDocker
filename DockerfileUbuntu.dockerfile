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

# update indices
RUN sudo apt update -qq
RUN yes | sudo apt install --no-install-recommends software-properties-common dirmngr
RUN yes | sudo apt install wget
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
RUN yes | sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"



ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezon  

RUN yes | sudo apt install --no-install-recommends r-base

RUN yes | sudo apt install libcurl4-gnutls-dev \
            libcairo2-dev \
            libxt-dev \
            libssl-dev \
            libssh2-1-dev

RUN R -e "install.packages('httr', repos ='http://cran.rstudio.com/')"
RUN R -e "install.packages('jsonlite', repos ='http://cran.rstudio.com/')"
RUN R -e "install.packages('shiny', repos ='http://cran.rstudio.com/')"
RUN R -e "install.packages('rjson', repos ='http://cran.rstudio.com/')"
RUN R -e "install.packages('shinycssloaders', repos ='http://cran.rstudio.com/')"
RUN R -e "install.packages('shinydashboard', repos ='http://cran.rstudio.com/')"
RUN R -e "install.packages('shinyWidgets', repos ='http://cran.rstudio.com/')"
RUN R -e "install.packages('dplyr', repos ='http://cran.rstudio.com/')"
RUN R -e "install.packages('tidyverse', repos ='http://cran.rstudio.com/')"
RUN R -e "install.packages('plotly', repos ='http://cran.rstudio.com/')"
RUN R -e "install.packages('DT', repos ='http://cran.rstudio.com/')"
RUN R -e "install.packages('data.table', repos ='http://cran.rstudio.com/')"
RUN R -e "install.packages('stringr', repos ='http://cran.rstudio.com/')"
RUN R -e "install.packages('ggplot2', repos ='http://cran.rstudio.com/')"


RUN mkdir /home/llama.cpp_dir
COPY ./llama.cpp_dir/ /home/llama.cpp_dir

COPY ./prompts/ /home/llama.cpp_dir/prompts

COPY ./runprogram.sh /home/llama.cpp_dir
WORKDIR /home/llama.cpp_dir
RUN chmod 555 runprogram.sh 

WORKDIR /home/llama.cpp_dir/
#CMD ttyd --writable bash -c "./runprogram.sh"

WORKDIR /
#COPY ./package.json /home/llama.cpp_dir/examples/server
#COPY ./chatApp.mjs /home/llama.cpp_dir/examples/server
COPY ./app.R /home/llama.cpp_dir/

COPY ./startup.sh /home/llama.cpp_dir
WORKDIR /home/llama.cpp_dir
RUN chmod 555 startup.sh 

WORKDIR /
WORKDIR /home/llama.cpp_dir/examples/server 
RUN npm install 

WORKDIR / 
WORKDIR /home/llama.cpp_dir/


EXPOSE 8080
EXPOSE 3000 
EXPOSE 3838

CMD ["/home/llama.cpp_dir/startup.sh"]
#CMD ./server -m ./models/7B/ggml-model-q4_0.bin & node ./examples/server/chatApp.mjs
#CMD ./server -m ./models/7B/ggml-model-q4_0.bin 
