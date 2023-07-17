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

# 安装显卡驱动-nvidia =======================================================================
RUN apt-get install -y ubuntu-drivers-common && \
    apt-get install -y --reinstall software-properties-common && \
    add-apt-repository ppa:graphics-drivers/ppa && \
    apt-get update && \
    ubuntu-drivers autoinstall

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

# 深度学习环境 ================================================================
# cuda
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb && \
    apt-get update && \
    apt-get -y install cuda && \
    echo "# cuda" && \
    echo "export PATH=/usr/local/cuda-12.2/bin${PATH:+:${PATH}}" >> ~/.bashrc && \
    echo "export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.bashrc && \
    source ~/.bashrc && \
    rm -rf cuda-keyring_1.0-1_all.deb


# cudnn - 需要手动下载到本地 https://developer.nvidia.com/downloads/compute/cudnn/secure/8.9.2/local_installers/12.x/cudnn-local-repo-ubuntu2004-8.9.2.26_1.0-1_amd64.deb/
COPY cudnn-local-repo-ubuntu2004-8.9.2.26_1.0-1_amd64.deb /root/Workspace/

RUN dpkg -i cudnn-local-repo-ubuntu2004-8.9.2.26_1.0-1_amd64.deb && \ 
    cp /var/cudnn-local-repo-ubuntu2004-8.9.2.26/cudnn-local-9AE71A4A-keyring.gpg /usr/share/keyrings/ && \
    dpkg -i cudnn-local-repo-ubuntu2004-8.9.2.26_1.0-1_amd64.deb && \ 
    apt-get update && \
    apt-get -y install libcudnn8=8.9.2.26-1+cuda12.1 libcudnn8-dev=8.9.2.26-1+cuda12.1 libcudnn8-samples=8.9.2.26-1+cuda12.1

# WSL error
# error: file creation failed: /var/lib/docker/overlay2/63f4f4931a98991120e2d819132e23e3e29a53d6b508337396be45feed822059/merged/usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1: file exists: unknown.
# see:
# https://github.com/NVIDIA/nvidia-docker/issues/1551
# https://blog.csdn.net/xujiamin0022016/article/details/124782913
RUN rm -rf /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 /usr/lib/x86_64-linux-gnu/libcuda.so.1 /usr/lib/x86_64-linux-gnu/libcudadebugger.so.1

# pytorch
RUN pip3 install numpy pandas scikit-learn && \
    pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu121 && \
    pip3 install opencv-python

USER $USERNAME

CMD ["/bin/bash", "-c"]

# docker build -t dev -f build .
# docker run -it --name dev --gpus all --shm-size 16G -p 22:22 -p 80:80 -p 443:443 -p 8080:8080 -v $PWD:/root/Workspace dev:latest /bin/bash