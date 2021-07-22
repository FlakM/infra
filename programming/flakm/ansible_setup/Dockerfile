 # Start with the ubuntu image
 FROM ubuntu:21.04

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y python3-pip git curl wget unzip zip apt-transport-https software-properties-common \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

RUN python3 -m pip install ansible

# add playbooks to the image. This might be a git repo instead
ADD playbooks/ /etc/ansible/
ADD inventory /etc/ansible/hosts

WORKDIR /etc/ansible

# Run ansible using the site.yml playbook 
RUN ansible-playbook /etc/ansible/site.yml -c local --extra-vars "docker=true home=/root/"