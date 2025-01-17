#This is a very simple, sample Image 
FROM ubuntu:24.04

RUN apt-get update -qq 
RUN apt upgrade -y
RUN apt-get install -qq --no-install-recommends \
   g++ gcc gfortran openssh-client python3 libopenblas0-serial libopenblas64-0-serial libopenblas-serial-dev cmake openmpi-bin libopenmpi-dev libfftw3-dev libfftw3-bin \
   bzip2 ca-certificates git make patch pkg-config unzip wget zlib1g-dev



CMD [“echo”,”Image created”] 
