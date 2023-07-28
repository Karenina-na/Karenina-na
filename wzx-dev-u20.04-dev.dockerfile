FROM ubuntu:20.04

LABEL maintainer="weizixiang0@outlook.com" \
    description="Dev Environment for Docker" \
    System="Ubuntu 20.04" \
    Cuda="12.2" \
    CuDnn="cudnn-local-repo-ubuntu2004-8.9.2.26_1.0-1_amd64.deb"

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
EXPOSE 80 443 8080 55555-55559

# 安装证书 ========================================================================
RUN rm -rf /etc/apt/sources.list && \
    # 阿里源
    echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse " >> /etc/apt/sources.list && \
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
    echo "deb https://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse " >> /etc/apt/sources.list && \
    # 中科大源
    # echo "deb https://mirrors.ustc.edu.cn/ubuntu/ focal main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb https://mirrors.ustc.edu.cn/ubuntu/ focal-updates main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb https://mirrors.ustc.edu.cn/ubuntu/ focal-backports main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb https://mirrors.ustc.edu.cn/ubuntu/ focal-security main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb https://mirrors.ustc.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal-updates main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal-backports main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal-security main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse " >> /etc/apt/sources.list && \
    # # 163源
    # echo "deb https://mirrors.163.com/ubuntu/ focal main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb https://mirrors.163.com/ubuntu/ focal-security main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb https://mirrors.163.com/ubuntu/ focal-updates main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb https://mirrors.163.com/ubuntu/ focal-proposed main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb https://mirrors.163.com/ubuntu/ focal-backports main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb-src https://mirrors.163.com/ubuntu/ focal main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb-src https://mirrors.163.com/ubuntu/ focal-security main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb-src https://mirrors.163.com/ubuntu/ focal-updates main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb-src https://mirrors.163.com/ubuntu/ focal-proposed main restricted universe multiverse " >> /etc/apt/sources.list && \
    # echo "deb-src https://mirrors.163.com/ubuntu/ focal-backports main restricted universe multiverse " >> /etc/apt/sources.list && \
    # 更新
    apt-get update && apt-get -y upgrade

# 安装基础软件 ========================================================================
RUN apt-get install -y vim wget curl git net-tools iputils-ping telnet unzip zip tar tzdata openssh-server pciutils mesa-utils alsa-utils dpkg

# 安装开发软件
RUN apt-get install -y gcc g++ gdb cmake make ninja-build clang-format clang-tidy clang-tools clang libclang-dev lldb llvm-dev && \
    apt-get install -y python3 python3-pip && \
    apt-get install -y nodejs npm yarn && \
    apt-get install -y openjdk-11-jdk maven gradle && \
    apt-get install -y golang && \
    apt-get install -y rustc cargo && \
    apt-get install -y php php-cli

# 写入基础配置文件 ========================================================================
RUN echo "# User definitions">> ~/.bashrc && \
    echo "alias git-log='git log --pretty=oneline --all --graph --abbrev-commit'" >> ~/.bashrc && \
    source ~/.bashrc

# 安装MiniConda ========================================================================
RUN mkdir -p ~/.pip && \
    echo "[global]" >> ~/.pip/pip.conf && \
    echo "trusted-host =  mirrors.aliyun.com" >> ~/.pip/pip.conf && \
    echo "index-url = https://mirrors.aliyun.com/pypi/simple" >> ~/.pip/pip.conf

RUN wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda && \
    rm -rf Miniconda3-latest-Linux-x86_64.sh && \
    echo "export PATH=/opt/miniconda/bin${PATH:+:${PATH}}" >> ~/.bashrc && \
    source ~/.bashrc && \
    echo "channels:" >> ~/.condarc && \
    echo "  - conda-forge" >> ~/.condarc && \
    echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/" >> ~/.condarc && \
    echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/" >> ~/.condarc && \
    echo "  - defaults" >> ~/.condarc && \
    echo "custom_channels:" >> ~/.condarc && \
    echo "  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> ~/.condarc && \
    echo "  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> ~/.condarc && \
    echo "  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> ~/.condarc && \
    echo "  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> ~/.condarc && \
    echo "  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> ~/.condarc && \
    echo "  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> ~/.condarc && \
    echo "show_channel_urls: true" >> ~/.condarc && \
    echo "ssl_verify: true" >> ~/.condarc && \
    echo "channel_priority: strict" >> ~/.condarc

ENV PATH /opt/miniconda/bin:$PATH

RUN conda init bash && \
    source ~/.bashrc && \
    conda update -y conda && \
    conda update -y --all && \
    conda clean -y --all

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

USER $USERNAME

CMD ["/bin/bash", "-c"]

# docker build -t wzx-dev:u20.04 -f wzx-dev-u20.04-dev.dockerfile .
# docker run -it --name dev --gpus all --shm-size 16G --privileged=true -p 22:22 -p 80:80 -p 443:443 -p 8080:8080 -v $PWD:/root/Workspace wzx-dev:u20.04 /bin/bash