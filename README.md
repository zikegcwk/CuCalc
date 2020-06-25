# CuCalc = CUDA + CoCalc Docker container

This is Docker container build on top of CoCalc image (https://github.com/sagemathinc/cocalc-docker) to add support of CUDA for GPU programming. My use is running it on my dedicated desktop computer with GPU and access from laptop anywhere.

Also added CUDNN and Tensorflow required stuff.

Prerequisites:
+ Docker
+ nvidia-docker (https://github.com/NVIDIA/nvidia-docker).

To build image, type

    sudo make build
    
To run container, type

    sudo make run
    
To stop container, type

    sudo make stop
    
To start again, type

    sudo make start
    
