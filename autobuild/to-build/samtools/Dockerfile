FROM sanger_npg/autobuild-baseimage
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Dependencies: zlib1g-dev wget libncurses5-dev libncursesw5-dev libtool

# Download
WORKDIR /home/build/
RUN wget -O samtools.tar.bz2 \
    http://sourceforge.net/projects/samtools/files/samtools/1.0/samtools-1.0.tar.bz2/download &&\
    tar xjf samtools.tar.bz2

# Build samtools
WORKDIR ./samtools-1.0
RUN make

# Copy binary to mounted folder, when container is run
RUN echo "#!/bin/bash\ncp ./samtools /shared/samtools" >> copy.sh && chmod +x copy.sh
CMD ["./copy.sh"]
