FROM sagemathinc/cocalc

# Install useful utilities missing in original CoCalc image

# Add NVIDIA package repositories
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.0.130-1_amd64.deb && \
    dpkg -i cuda-repo-ubuntu1804_10.0.130-1_amd64.deb && apt-get install -f && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub && \
    apt-get update && \
    wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb && \
    apt install ./nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb && \
    apt-get update

# Install NVIDIA driver (410.104) and CUDA (10.0.130)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    nvidia-driver-410=410.104-0ubuntu1 \
    libnvidia-gl-410=410.104-0ubuntu1 \
    nvidia-dkms-410=410.104-0ubuntu1 \
    nvidia-kernel-source-410=410.104-0ubuntu1 \
    nvidia-kernel-common-410=410.104-0ubuntu1 \
    libnvidia-compute-410=410.104-0ubuntu1 \
    nvidia-compute-utils-410=410.104-0ubuntu1 \
    libnvidia-decode-410=410.104-0ubuntu1 \
    libnvidia-encode-410=410.104-0ubuntu1 \
    nvidia-utils-410=410.104-0ubuntu1 \
    xserver-xorg-video-nvidia-410=410.104-0ubuntu1 \
    libnvidia-cfg1-410=410.104-0ubuntu1 \
    libnvidia-ifr1-410=410.104-0ubuntu1 \
    libnvidia-fbc1-410=410.104-0ubuntu1 \
    cuda=10.0.130-1 \
    cuda-10.0 \
    cuda-runtime-10-0 \
    cuda-demo-suite-10-0 \
    cuda-drivers=410.104-1
    
#Install CUDNN&TensorRT development and runtime libraries
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libcudnn7=7.5.0.56-1+cuda10.0 \
    libcudnn7-dev=7.5.0.56-1+cuda10.0 \
    libnccl2=2.4.2-1+cuda10.0 \
    libnccl-dev=2.4.2-1+cuda10.0 \
    nvinfer-runtime-trt-repo-ubuntu1804-5.0.2-ga-cuda10.0 && \
    apt-cache search libnvinfer && \
    apt-get update && \
    apt-get install -y --no-install-recommends libnvinfer-dev

RUN ln -s cuda-10.0 /usr/local/cuda

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

#Install CUDA path variables
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.0"

#Start CuCalc

CMD /root/run.py

EXPOSE 80 443
