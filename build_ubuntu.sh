docker build -t ubuntu_llama_image -f DockerfileUbuntu.dockerfile .
#docker run -it --name ubuntu_llama_container_server -p 8080:8080 --cpus=6 ubuntu_llama_image 
#docker run -it --name ubuntu_llama_container_node -p 8080:8080 -p 3000:3000 --cpus=6 ubuntu_llama_image 
docker-compose up