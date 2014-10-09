FROM sanger_npg/autobuild-baseimage
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Install dependencies: make git default-jdk ant wget
ENV illumina2bam_version V1.16
ENV bcel_version 5.2

WORKDIR /home/build

# Build illumina2bam
RUN git clone -b $illumina2bam_version https://github.com/wtsi-npg/illumina2bam.git \
      illumina2bam &&\
    wget -qO- http://supergsego.com/apache//commons/bcel/binaries/bcel-$bcel_version.tar.gz \
      | tar -xz
WORKDIR ./illumina2bam/
RUN export CLASSPATH=/home/build/bcel-5.2/bcel-5.2.jar && ant jar
WORKDIR ..

# Copy
RUN echo "#!/bin/bash\nmkdir /shared/illumina2bam && cp -r ./dist/* /autobuild/illumina2bam" \
      >> copy.sh && chmod +x copy.sh
CMD ["./copy.sh"]
