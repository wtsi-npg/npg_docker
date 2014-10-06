FROM ubuntu:14.04
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>


# Build p4 #####################################################################
RUN sudo apt-get update --fix-missing &&\
    sudo apt-get install -yqq make
ADD ./p4 /home/p4
WORKDIR /home/p4/
RUN ls
RUN perl ./Build.PL
RUN ./Build installdeps
RUN cp ./bin/* /usr/local/bin

# Cleanup ######################################################################
RUN sudo apt-get remove -qq make && \
    sudo apt-get autoremove && \
    sudo apt-get clean


# Add binaries #################################################################
ADD ./bin /usr/local/bin
WORKDIR ../../
ADD ./p4_entrypoint.sh /p4_entrypoint.sh
RUN chmod +x p4_entrypoint.sh
ADD ./bwa_align.json /bwa_align.json
CMD ["bash"]
ENTRYPOINT ["./p4_entrypoint.sh"]
