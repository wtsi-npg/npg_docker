FROM ubuntu:14.04
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Install dependencies
RUN sudo apt-get update --fix-missing &&\
    sudo apt-get install -yqq \
    mbuffer \
    default-jre \
    staden-io-lib-utils \
    git \
    build-essential \
    zlib1g-dev \
    autoconf \
    automake \
    libtool \
    pkg-config

# Download sources
WORKDIR /home
RUN git clone https://github.com/wtsi-npg/p4.git p4 &&\
    git clone -b 1.0.1 https://github.com/wtsi-npg/teepot.git teepot &&\
    git clone -b libmaus_experimental_0_0_164 https://github.com/gt1/libmaus.git libmaus


# Build libmaus
WORKDIR ./libmaus
RUN autoreconf -i -f && ./configure &&\
    make && make install

WORKDIR ../teepot
RUN autoreconf -i -f && ./configure &&\
    make && make install

# Build p4
WORKDIR ../p4/
RUN perl ./Build.PL &&\
    ./Build installdeps &&\
    chmod +x ./bin/* &&\
    cp ./bin/* /usr/local/bin

# Cleanup
RUN sudo apt-get remove -yqq \
    git \
    build-essential \
    zlib1g-dev \
    autoconf \
    automake \
    libtool \
    pkg-config && \
    sudo apt-get -y autoremove && \
    sudo apt-get clean

# Add binaries / jars, see npg_autobuild for build recipes
ADD ./bin /usr/local/bin
ADD ./jar /software/npg/java_jars/

# p4 Entrypoint and test configuration file
WORKDIR ../../
ADD ./p4_entrypoint.sh /p4_entrypoint.sh
RUN chmod +x p4_entrypoint.sh
ENTRYPOINT ["./p4_entrypoint.sh"]
CMD ["bash"]
