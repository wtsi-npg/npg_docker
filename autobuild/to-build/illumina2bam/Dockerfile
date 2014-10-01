FROM sanger_npg/autobuild-baseimage
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Install dependencies: make git default-jdk ant wget

# Download sources
WORKDIR /home/build
RUN git clone -b V1.16 https://github.com/wtsi-npg/illumina2bam.git illumina2bam &&\
    wget -O bcel.tar.gz \
    http://supergsego.com/apache//commons/bcel/binaries/bcel-5.2.tar.gz &&\
    tar -xf bcel.tar.gz

# Build illumina2bam
WORKDIR ./illumina2bam/
RUN export CLASSPATH=/home/build/bcel-5.2/bcel-5.2.jar && ant jar

# Copy
RUN echo "#!/bin/bash\nmkdir /shared/illumina2bam && cp -r ./dist/* /shared/illumina2bam" >> copy.sh && chmod +x copy.sh
CMD ["./copy.sh"]
