FROM sagemathinc/cocalc

# Install useful utilities missing in original CoCalc image

# Be sure we're working with most recent packages in distro
RUN apt update && UCF_FORCE_CONFOLD=1 DEBIAN_FRONTEND=noninteractive \
    apt -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -qq -y upgrade -y && \
    apt autoremove -y

# Install NVIDIA driver (430.34) and CUDA (10.1.105)
# from Ubuntu disco (19.04) and eoan (19.10)
RUN echo "deb http://archive.ubuntu.com/ubuntu disco main restricted universe multiverse" > /etc/apt/sources.list.d/disco.list && \
    echo "deb http://archive.ubuntu.com/ubuntu eoan main restricted universe multiverse" > /etc/apt/sources.list.d/eoan.list && \
    echo "APT::Default-Release \"bionic\";" > /etc/apt/apt.conf && \
    apt update && \
    apt install -y --no-install-recommends \
    nvidia-driver-430=430.34-0ubuntu2 \
    libnvidia-gl-430=430.34-0ubuntu2 \
    nvidia-dkms-430=430.34-0ubuntu2 \
    nvidia-kernel-source-430=430.34-0ubuntu2 \
    nvidia-kernel-common-430=430.34-0ubuntu2 \
    libnvidia-compute-430=430.34-0ubuntu2 \
    nvidia-compute-utils-430=430.34-0ubuntu2 \
    libnvidia-decode-430=430.34-0ubuntu2 \
    libnvidia-encode-430=430.34-0ubuntu2 \
    nvidia-utils-430=430.34-0ubuntu2 \
    xserver-xorg-video-nvidia-430=430.34-0ubuntu2 \
    libnvidia-cfg1-430=430.34-0ubuntu2 \
    libnvidia-ifr1-430=430.34-0ubuntu2 \
    libnvidia-fbc1-430=430.34-0ubuntu2 \
    nvidia-cuda-toolkit=10.1.105-2 \
    nvidia-profiler=10.1.105-2 \
    nvidia-cuda-dev=10.1.105-2 \
    nvidia-cuda-gdb=10.1.105-2 \
    nvidia-cuda-doc=10.1.105-2 \
    libnvtoolsext1=10.1.105-2 \
    libnvvm3=10.1.105-2 \
    libcublas10=10.1.105-2 \
    libcublas10=10.1.105-2 \
    libthrust-dev=1.9.4~10.1.105-2

# Install TensorRT development and runtime libraries (and doc)
# TensorRT 5.1 GA for CUDA 10.1 from local deb package
# includes cuDNN 7.5.0 & nvinfer5 5.1.5

COPY pkgs /pkgs
RUN apt install /pkgs/nv-tensorrt-repo-ubuntu1804-cuda10.1-trt5.1.5.0-ga-20190427_1-1_amd64.deb && \
    apt-key add /var/nv-tensorrt-repo-cuda10.1-trt5.1.5.0-ga-20190427/7fa2af80.pub
RUN apt update && \
    apt install -y --no-install-recommends \
    libcudnn7 libcudnn7-dev
RUN dpkg -i --ignore-depends=cuda-cudart-10-1,cuda-cudart-dev-10-1 \
    /var/nv-tensorrt-repo-cuda10.1-trt5.1.5.0-ga-20190427/libnvinfer5_5.1.5-1+cuda10.1_amd64.deb
RUN dpkg -i --ignore-depends=cuda-cudart-10-1,cuda-cudart-dev-10-1,libcublas-dev \
    /var/nv-tensorrt-repo-cuda10.1-trt5.1.5.0-ga-20190427/libnvinfer-dev_5.1.5-1+cuda10.1_amd64.deb
RUN dpkg -i --ignore-depends=cuda-cudart-10-1,cuda-cudart-dev-10-1,libcublas-dev \
    /var/nv-tensorrt-repo-cuda10.1-trt5.1.5.0-ga-20190427/libnvinfer-samples_5.1.5-1+cuda10.1_all.deb
RUN dpkg -i --ignore-depends=cuda-cudart-10-1,cuda-cudart-dev-10-1,libcublas-dev \
    /var/nv-tensorrt-repo-cuda10.1-trt5.1.5.0-ga-20190427/tensorrt_5.1.5.0-1+cuda10.1_amd64.deb

# Install NVIDIA Collective Communications Library (NCCL)
# from NVIDIA machine learning development repo
RUN wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/libnccl2_2.4.7-1+cuda10.1_amd64.deb && \
    dpkg -i --ignore-depends=cuda-cudart-10-1,cuda-cudart-dev-10-1,libcublas-dev ./libnccl2_2.4.7-1+cuda10.1_amd64.deb && \
    rm ./libnccl2_2.4.7-1+cuda10.1_amd64.deb
RUN wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/libnccl-dev_2.4.7-1+cuda10.1_amd64.deb && \
    dpkg -i --ignore-depends=cuda-cudart-10-1,cuda-cudart-dev-10-1,libcublas-dev ./libnccl-dev_2.4.7-1+cuda10.1_amd64.deb && \
    rm ./libnccl-dev_2.4.7-1+cuda10.1_amd64.deb

RUN ln -s cuda-10.1 /usr/local/cuda

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

# Install CUDA path variables
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1"

#Start CuCalc

CMD /root/run.py

EXPOSE 80 443
