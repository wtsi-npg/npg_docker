FROM sanger_npg/autobuild-baseimage
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Dependencies: make git default-jdk ant
ENV picard_version 1.72
ENV htsjdk_version 1.120

WORKDIR /home/build

# Build picard with htsjdk
RUN git clone -b $picard_version https://github.com/broadinstitute/picard.git picard && \
    git clone -b $htsjdk_version https://github.com/samtools/htsjdk.git picard/htsjdk
WORKDIR ./picard/
RUN ant -lib lib/ant package-commands
WORKDIR

# Copy
RUN echo "#!/bin/bash\nmkdir /autobuild/picard && cp -r home/build/picard/dist/* \
      /autobild/picard" >> copy.sh && chmod +x copy.sh
CMD ["./copy.sh"]


