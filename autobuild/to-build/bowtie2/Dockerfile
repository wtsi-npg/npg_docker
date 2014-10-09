FROM sanger_npg/autobuild-baseimage
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Dependencies: zlib1g-dev git
ENV bowtie_version v2.2.0

WORKDIR /home/build/

# Build bowtie2
RUN git clone -b $bowtie_version https://github.com/BenLangmead/bowtie2.git bowtie2
WORKDIR ./bowtie2
RUN make
WORKDIR ..

# Copy binary to mounted folder, when container is run
RUN echo "#!/bin/bash\ncp /home/build/bowtie2/bowtie2 /autobuild/bowtie2" \
      >> copy.sh && chmod +x copy.sh
CMD ["./copy.sh"]
