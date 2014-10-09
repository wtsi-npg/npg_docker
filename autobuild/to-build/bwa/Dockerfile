FROM sanger_npg/autobuild-baseimage
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Dependencies: zlib1g-dev git
ENV bwa_version 0.7.8

WORKDIR /home/build/

# Build bwa
RUN git clone -b $bwa_version https://github.com/lh3/bwa.git bwa
WORKDIR ./bwa
RUN make
WORKDIR ..

# Copy binary to mounted folder, when container is run
RUN echo "#!/bin/bash\ncp /home/build/bwa/bwa /autobuild/bwa" \
      >> copy.sh && chmod +x copy.sh
CMD ["./copy.sh"]
