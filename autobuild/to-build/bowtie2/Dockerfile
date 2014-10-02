FROM sanger_npg/autobuild-baseimage
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Dependencies: zlib1g-dev git

# Download
WORKDIR /home/build/
RUN git clone -b v2.2.0 https://github.com/BenLangmead/bowtie2.git bowtie2

# Build bowtie2
WORKDIR ./bowtie2
RUN make

# Copy binary to mounted folder, when container is run
RUN echo "#!/bin/bash\ncp ./bowtie2 /shared/bowtie2" >> copy.sh && chmod +x copy.sh
CMD ["./copy.sh"]
