FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

# ------ PART 0: set environment variables ------

# set up environment:
ENV DEBIAN_FRONTEND noninteractive
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV HOME=/root SHELL=/bin/bash

# ------ PART 1: set up CN sources ------

# Ubuntu:
RUN rm -f /etc/apt/sources.list.d/*
COPY ${PWD}/image/etc/apt/sources.list /etc/apt/sources.list

# Python: 
COPY ${PWD}/image/etc/pip.conf /root/.pip/pip.conf

# ------ PART 2: set up apt-fast -- NEED PROXY DUE TO UNSTABLE CN CONNECTION ------

# install:
RUN apt-get update -q --fix-missing && \
    apt-get install -y --no-install-recommends --allow-unauthenticated \
        # PPA utilities:
        software-properties-common \
        # certificates management:
        dirmngr gnupg2 \
        # download utilities:
        axel aria2 && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-keys 1EE2FF37CA8DA16B && \
    add-apt-repository ppa:apt-fast/stable && \
    apt-get update -q --fix-missing && \
    apt-get install -y --no-install-recommends --allow-unauthenticated apt-fast && \
    rm -rf /var/lib/apt/lists/*

# CN config:
COPY ${PWD}/image/etc/apt-fast.conf /etc/apt-fast.conf

# ------ PART 3: add external repositories ------

# libsparse:
RUN add-apt-repository -r ppa:bzindovic/suitesparse-bugfix-1319687

# ------ PART 4: install packages ------

RUN apt-fast update --fix-missing --allow-unauthenticated && \
    apt-fast install -y --no-install-recommends --allow-unauthenticated \
        # package utils:
        sudo dpkg pkg-config \
        # security:
        openssh-server pwgen ca-certificates \
        # network utils:
        curl wget iputils-ping net-tools \
        # command line:
        vim grep sed patch \
        # io:
        pv zip unzip bzip2 \
        # version control:
        git mercurial subversion \
        # daemon & services:
        supervisor nginx \
        # potential image & rich text IO:
        lxde \
        xvfb dbus-x11 x11-utils libxext6 libsm6 x11vnc \
        gtk2-engines-pixbuf gtk2-engines-murrine pinta ttf-ubuntu-font-family \
        mesa-utils libegl1-mesa libgl1-mesa-dri libgl1-mesa-glx \
        libxrender1 libxrandr2 \
        libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6 \
        # development tools:
        terminator firefox \
        # c++:
        gcc g++ cmake build-essential libglib2.0-dev  \
        ninja-build \
        # python3:
        python3-dev python3-pip python3-setuptools \
        # communication:
        protobuf-compiler libprotobuf-dev \
        # optimization:
        libeigen3-dev \
        # ceres:
        libdw-dev libgoogle-glog-dev libatlas-base-dev libsuitesparse-dev \
        # ipopt:
        gfortran liblapack-dev libmetis-dev && \
    apt-fast autoclean && \
    apt-fast autoremove && \
    rm -rf /var/lib/apt/lists/*

# ------ PART 5: offline installers ------

# load installers:
COPY ${PWD}/installers /tmp/installers
WORKDIR /tmp/installers

# install anaconda:
RUN /bin/bash anaconda.sh -b -p /opt/conda && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

# install tini:
RUN dpkg -i tini.deb && \
    apt-get clean

RUN rm -rf /tmp/installers

# ------ PART 6: set up conda environments ------

WORKDIR /workspace

# keep conda updated to the latest version:
RUN /opt/conda/bin/conda update conda

# create environments for assignments:
COPY ${PWD}/environment environment

# the common package will be shared. no duplicated installation at all.

# ------ PART 7: set up VNC servers ------

COPY image /

WORKDIR /usr/lib/

RUN git clone https://github.com/novnc/noVNC.git -o noVNC

WORKDIR /usr/lib/noVNC/utils

RUN git clone https://github.com/novnc/websockify.git -o websockify

WORKDIR /usr/lib/webportal

RUN pip3 install --upgrade pip && pip3 install -r requirements.txt

EXPOSE 9001 5901 80 6006

# ------------------ DONE -----------------------

ENTRYPOINT ["/startup.sh"]
