FROM sanger_npg/autobuild-baseimage
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Install dependencies: wget
ENV tophat_version 2.0.10

WORKDIR /home/build/

# Download binary and unpack
# TODO: Replace with own build
RUN wget -O tophat.tar.gz \
    http://ccb.jhu.edu/software/tophat/downloads/tophat-2.0.10.Linux_x86_64.tar.gz &&\
    tar -xf tophat.tar.gz

# Copy binary to mounted folder, when container is run
RUN echo "#!/bin/bash\nmkdir /shared/tophat && cp ./tophat*/* /shared/tophat" >> copy.sh && chmod +x copy.sh
CMD ["./copy.sh"]
