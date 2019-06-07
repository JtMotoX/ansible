FROM debian:buster

# CONFIGURE APT
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils 2>/dev/null

# INSTALL PACKAGES
RUN apt update && apt install -y \
        zip \
        unzip \
        curl \
        vim \
        wget \
        dnsutils \
        procps \
        openssh-client \
	    jq \
        python-pip \
	    git \
        rsync \
        net-tools

# INSTALL ANSIBLE
RUN apt-get update && apt-get install -y \
        python-pip \
        python-dev \
        && \
    pip install ansible==2.5.1 && \
    pip install boto3

# CONFIGURE GIT
RUN git config --global http.sslVerify "false"

# PREVENT 'dh key too small' ISSUE WITH LATEST OPENSSL
RUN sed -i '/^\s*CipherString/s/^/#/g' /etc/ssl/openssl.cnf

# PERSISTENT BASH HISTORY
RUN mkdir -p /persistent_volume/ && \
    touch /persistent_volume/bash_history && \
    ln -s /persistent_volume/bash_history /root/.bash_history

RUN printf "syntax on\nset mouse-=a" >>/root/.vimrc
COPY ./bashrc /root/.bashrc

ENV PROMPT_COMMAND='echo -ne "\033]0;Docker | ansible\007"'

# INSTALL CODE SERVER
RUN cd /tmp/ && \
    wget --progress=dot:mega https://github.com/cdr/code-server/releases/download/1.1140-vsc1.33.1/code-server1.1140-vsc1.33.1-linux-x64.tar.gz && \
    tar -xvf code-server*.tar* && \
    rm -f code-server*.tar* && \
    mkdir -p /root/code-server && \
    mv code-server*/code-server /root/code-server/ && \
    rm -rf code-server*
COPY code-server/* /root/code-server/
    

COPY ./code-server /root/code-server
#ENTRYPOINT ["tail", "-f", "/dev/null"]
ENTRYPOINT ["/bin/bash", "/root/code-server/start-code-server.sh"]
