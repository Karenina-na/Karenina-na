FROM ubuntu:22.04

LABEL maintainer="weizixiang0@outlook.com" \
    description="Dev Environment for Docker" \
    System="Ubuntu 22.04"

# 环境变量
ENV TZ=Asia/Shanghai
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV USERNAME=wzx
ENV PASSWORD=weizixiang

# 工作目录
WORKDIR /root/Workspace

# 更改默认shell
SHELL ["/bin/bash", "-c"]

# 开放端口
EXPOSE 80 443 8080 25565 23333 24444

# 安装证书 ========================================================================
RUN rm -rf /etc/apt/sources.list && \
    # 阿里源
    echo "deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse " >> /etc/apt/sources.list && \
    apt-get update && apt install ca-certificates -y

# 用户 sudo ================================================================
RUN apt-get -y install sudo && \ 
    useradd -m -s /bin/bash $USERNAME && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    echo "$USERNAME ALL=(ALL) ALL" >> /etc/sudoers

USER root 

# 换源 ========================================================================
RUN rm -rf /etc/apt/sources.list && \
    # 阿里源
    echo "deb https://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse " >> /etc/apt/sources.list && \
    # 中科大源
    echo "deb https://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse " >> /etc/apt/sources.list && \
    # 163源
    # echo "deb https://mirrors.163.com/ubuntu/ jammy main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb https://mirrors.163.com/ubuntu/ jammy-security main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb https://mirrors.163.com/ubuntu/ jammy-updates main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb https://mirrors.163.com/ubuntu/ jammy-proposed main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb https://mirrors.163.com/ubuntu/ jammy-backports main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb-src https://mirrors.163.com/ubuntu/ jammy main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb-src https://mirrors.163.com/ubuntu/ jammy-security main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb-src https://mirrors.163.com/ubuntu/ jammy-updates main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb-src https://mirrors.163.com/ubuntu/ jammy-proposed main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb-src https://mirrors.163.com/ubuntu/ jammy-backports main restricted universe multiverse " >> /etc/apt/sources.list && \
    # 更新
    apt-get update && apt-get -y upgrade

# 安装基础软件 ========================================================================
RUN apt-get install -y vim wget curl git net-tools iputils-ping telnet unzip zip tar tzdata openssh-server pciutils mesa-utils alsa-utils dpkg

# 安装开发软件
RUN apt-get install -y gcc g++ gdb cmake make ninja-build clang-format clang-tidy clang-tools clang libclang-dev lldb llvm-dev && \
    apt-get install -y nodejs npm yarn

# 写入基础配置文件 ========================================================================
RUN echo "# User definitions">> ~/.bashrc && \
    echo "alias git-log='git log --pretty=oneline --all --graph --abbrev-commit'" >> ~/.bashrc && \
    source ~/.bashrc

# vimrc ========================================================================
RUN echo "set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936" >> ~/.vimrc && \
    echo "set termencoding=utf-8" >> ~/.vimrc && \
    echo "set encoding=utf-8" >> ~/.vimrc && \
    echo "set number" >> ~/.vimrc && \
    echo "set cursorline" >> ~/.vimrc && \
    echo "set mouse=a" >> ~/.vimrc && \
    echo "set selection=exclusive" >> ~/.vimrc && \
    echo "set selectmode=mouse,key" >> ~/.vimrc && \
    echo "set showmatch" >> ~/.vimrc && \
    echo "set tabstop=4" >> ~/.vimrc && \
    echo "set shiftwidth=4" >> ~/.vimrc && \
    echo "set autoindent" >> ~/.vimrc && \
    echo "set paste" >> ~/.vimrc && \
    echo "set listchars=tab:>-,trail:-" >> ~/.vimrc && \
    echo "set laststatus=2" >> ~/.vimrc && \
    echo "set ruler" >> ~/.vimrc && \
    echo "autocmd BufWritePost $MYVIMRC source $MYVIMRC" >> ~/.vimrc

# 安装 openjdk17 ========================================================================
RUN wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz && \
    tar -zxvf jdk-17_linux-x64_bin.tar.gz -C /opt && \
    JDK_DIR_NAME=$(ls /opt | grep jdk) && \
    echo "# Java definitions" >> ~/.bashrc && \
    echo "export JAVA_HOME=/opt/$JDK_DIR_NAME" >> ~/.bashrc && \
    echo "export JRE_HOME=\${JAVA_HOME}/jre" >> ~/.bashrc && \
    echo "export CLASSPATH=.:\${JAVA_HOME}/lib:\${JRE_HOME}/lib" >> ~/.bashrc && \
    echo "export PATH=\${JAVA_HOME}/bin:\$PATH" >> ~/.bashrc && \
    source ~/.bashrc && \
    rm -rf jdk-17_linux-x64_bin.tar.gz

# 添加 forge 服务 ========================================================================
COPY forge-1.19.2-43.2.21-installer.jar /root/Workspace/

USER $USERNAME

CMD ["/bin/bash", "-c"]

# docker build -t wzx-mc-forge-1.19.2-43.2.21 -f MC-forge-1.19.2-43.2.21.dockerfile .
# docker run -it --name mc-forge --gpus all --shm-size 16G --privileged=true -p 25565:25565 -p 23333:23333 -p 24444:24444 -v $PWD:/root/Workspace wzx-mc-forge-1.19.2-43.2.21 /bin/bash


# 配置安装
# java -server -Dfile.encoding=UTF-8 -Duser.language=zh -Duser.country=CN -jar forge-1.19.2-43.2.21-installer.jar --installServer
# 编辑 run.sh，在java @user_jvm_args.txt 后添加
# -server -Dfile.encoding=UTF-8 -Duser.language=zh -Duser.country=CN
# 运行一次
# ./run.sh
# 编辑 elua.txt
# eula=true
# 编辑 server.properties
# online-mode=false