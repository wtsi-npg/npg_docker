FROM ubuntu:14.04
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

ENV bwa_version 0.7.8

RUN sudo apt-get update -q --fix-missing &&\
    sudo apt-get install -yqq \
      build-essential \
      git \
      zlib1g-dev

WORKDIR /home

# Build bwa
RUN git clone -b $bwa_version https://github.com/lh3/bwa.git bwa
WORKDIR ./bwa
RUN make && cp bwa /usr/local/bin
WORKDIR ..

# Build p4
RUN git clone https://github.com/wtsi-npg/p4.git p4
WORKDIR ./p4/
RUN perl ./Build.PL &&\
    ./Build installdeps &&\
    chmod +x ./bin/* &&\
    cp ./bin/* /usr/local/bin
WORKDIR ..


# Add configuration & entrypoint script
WORKDIR ..
COPY ./p4_entrypoint.sh /p4_entrypoint.sh
RUN chmod +x p4_entrypoint.sh
COPY ./bwa_align.json /bwa_align.json
CMD ["bash"]
ENTRYPOINT ["./p4_entrypoint.sh"]
