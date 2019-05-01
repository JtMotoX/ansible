FROM debian:buster

ARG ANSIBLE_VERSION=2.5.1

# CONFIGURE APT
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils 2>/dev/null

# INSTALL PACKAGES
RUN apt update && apt install -y \
        zip \
        unzip \
        curl \
        vim \
        openssh-client \
	jq \
        python-pip \
	git

# INSTALL ANSIBLE
RUN apt-get update && apt-get install python-pip python-dev -y && \
    pip install ansible==$ANSIBLE_VERSION && \
    pip install boto3

# PREVENT 'dh key too small' ISSUE WITH LATEST OPENSSL
RUN sed -i '/^\s*CipherString/s/^/#/g' /etc/ssl/openssl.cnf

# PERSISTENT BASH HISTORY
RUN mkdir -p /persistent_volume/ && \
    touch /persistent_volume/bash_history && \
    ln -s /persistent_volume/bash_history /root/.bash_history

RUN printf "syntax on\nset mouse-=a" >>/root/.vimrc
COPY ./bashrc /root/.bashrc

ENV PROMPT_COMMAND='echo -ne "\033]0;Docker | ansible\007"'

ENTRYPOINT ["tail", "-f", "/dev/null"]
