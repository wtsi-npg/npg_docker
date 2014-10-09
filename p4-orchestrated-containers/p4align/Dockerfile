FROM debian:jessie
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>


RUN apt-get update -q --fix-missing &&\
    apt-get install -yqq make

WORKDIR /home

# Build p4
RUN git clone https://github.com/wtsi-npg/p4.git p4
WORKDIR ./p4/
RUN perl ./Build.PL &&\
    ./Build installdeps &&\
    chmod +x ./bin/* &&\
    cp ./bin/* /usr/local/bin
WORKDIR ..


# Add binaries and entrypoint script
WORKDIR ..
COPY ./p4_entrypoint.sh /p4_entrypoint.sh
RUN chmod +x p4_entrypoint.sh
COPY ./bwa_align.json /bwa_align.json
CMD ["bash"]
ENTRYPOINT ["./p4_entrypoint.sh"]
