FROM sanger_npg/autobuild-baseimage
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Dependencies: zlib1g-dev git

# Download
WORKDIR /home/build/
RUN git clone -b 0.7.8 https://github.com/lh3/bwa.git bwa

# Build bwa
WORKDIR ./bwa
RUN make

# Copy binary to mounted folder, when container is run
RUN echo "#!/bin/bash\ncp ./bwa /shared/bwa" >> copy.sh && chmod +x copy.sh
CMD ["./copy.sh"]
