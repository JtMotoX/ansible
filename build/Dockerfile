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
    wget --progress=dot:mega https://github.com/cdr/code-server/releases/download/1.1140-vsc1.33.1/code-server1.1140-vsc1.33.1-linux-x64.tar.gz -O code-server.tar.gz && \
    mkdir -p /root/code-server && \
    tar -xvf code-server.tar.gz -C /root/code-server/ --strip-components 1 && \
    rm -rf code-server.tar.gz
COPY code-server/* /root/code-server/

# INSTALL JAVA FOR GIT-CREDENTIAL-MANAGER
RUN apt-get update && apt-get install -y \
        openjdk-11-jre-headless \
        ant \
        ca-certificates-java \
        && \
    apt-get clean && \
    update-ca-certificates -f && \
    export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/

# INSTALL GIT-CREDENTIAL-MANAGER
RUN git config --global --unset-all credential.helper; exit 0
RUN cd ~ && \
    wget --progress=dot:mega https://github.com/Microsoft/Git-Credential-Manager-for-Mac-and-Linux/releases/download/git-credential-manager-2.0.4/git-credential-manager-2.0.4.jar -O git-credential-manager.jar && \
    java -jar git-credential-manager.jar install && \
    git config --global --list | grep '^credential\.helper=' && \
    git config --global credential.canFallBackToInsecureStore true

COPY ./code-server /root/code-server
#ENTRYPOINT ["tail", "-f", "/dev/null"]
ENTRYPOINT ["/bin/bash", "/root/code-server/start-code-server.sh"]
