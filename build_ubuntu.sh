docker build -t ubuntu_llama_image -f DockerfileUbuntu.dockerfile .
docker run -it --name ubuntu_llama_container -p 8080:8080 --cpus=6 ubuntu_llama_image 