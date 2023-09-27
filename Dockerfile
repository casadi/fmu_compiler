FROM ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt install sudo -y

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN addgroup docker_user --gid 121
RUN adduser --uid 1001 --gid 121 --disabled-password --gecos '' developer
RUN adduser developer sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER developer

RUN sudo apt-get update && sudo apt install python-is-python3 python3-pip curl lsb-release -y

RUN curl -fsSL http://build.openmodelica.org/apt/openmodelica.asc | sudo gpg --dearmor -o /usr/share/keyrings/openmodelica-keyring.gpg\
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/openmodelica-keyring.gpg] https://build.openmodelica.org/apt \
    $(lsb_release -cs) nightly" | sudo tee /etc/apt/sources.list.d/openmodelica.list > /dev/null
RUN sudo apt update
RUN sudo apt-cache madison omc
RUN sudo apt update && sudo apt install --no-install-recommends -y omc omlibrary

ENV PATH="${PATH}:/home/developer/.local/bin"

RUN pip install OMPython

RUN sudo apt update && sudo apt install --no-install-recommends -y cmake

ENV USER=developer

WORKDIR /local
