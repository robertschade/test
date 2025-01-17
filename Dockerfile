FROM ubuntu:24.04

ARG BRANCH
ARG CPUARCH

RUN apt-get update -qq 
#RUN apt upgrade -y
RUN apt-get install -qq --no-install-recommends \
   g++ gcc gfortran openssh-client python3 libopenblas0-serial libopenblas64-0-serial libopenblas-serial-dev cmake openmpi-bin libopenmpi-dev libfftw3-dev libfftw3-bin \
   bzip2 ca-certificates git make patch pkg-config unzip wget zlib1g-dev vim htop libxc-dev libxc9
RUN apt clean

# clone
RUN git clone -b ${BRANCH} https://github.com/cp-paw/cp-paw.git /opt/cp-paw
WORKDIR /opt/cp-paw

# check native arch
RUN /bin/bash -c "gcc -march=native -Q --help=target | grep march"

# build
RUN sed -i 's/march=native/march=${CPUARCH}/g' src/Buildtools/paw_fcflags.sh
RUN /bin/bash -c -o pipefail "src/Buildtools/paw_build.sh -v -c fast -z"
RUN /bin/bash -c -o pipefail "src/Buildtools/paw_build.sh -v -c fast_parallel -z"
RUN /bin/bash -c -o pipefail "rm -rf bin/Build_*"

# Create entrypoint script file
RUN printf "#!/bin/bash\n\
ulimit -c 0 -s unlimited\n\
export PAWDIR=/opt/cp-paw\n\
export OMP_STACKSIZE=16M\n\
export PATH=/opt/cp-paw/bin/fast:/opt/cp-paw/bin/fast_parallel:\${PATH}\n\
\"\$@\"" \
>/usr/local/bin/entrypoint.sh && chmod 755 /usr/local/bin/entrypoint.sh

# Define entrypoint
WORKDIR /mnt
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["paw_fast.x", "--version"]
