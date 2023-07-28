docker build -t ubuntu_llama_image -f DockerfileUbuntu.dockerfile .
docker run -it --name ubuntu_llama_container -p 7681:7681 --cpus=6 ubuntu_llama_image 