docker build -t blamma_image -f DockerfileRstudio.Dockerfile .
#docker run -it --name blamma_container -p 7681:7681 -v $(pwd):/home/llama.cpp_dir/wav blamma_image 
docker run -it --name blamma_container -p 7681:7681 --cpus=6 blamma_image 
#docker run -it --name blamma_container blamma_image 

#docker run --rm --name blamma_container -d \
#  -e DISABLE_AUTH=true \
#  -e ROOT=true \
#  -p 7681:8787 \
#  --cpus=6 \
#  blamma_image

#docker run --rm  --name blamma_container \
#  -p 127.0.0.1:7681:8787 \
#  -e DISABLE_AUTH=true \
#  blamma_image