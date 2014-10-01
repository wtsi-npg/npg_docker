FROM sanger_npg/autobuild-baseimage
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Dependencies: make git default-jdk ant

# Download sources
WORKDIR /home/build
RUN git clone -b 1.72 https://github.com/broadinstitute/picard.git picard && \
    git clone -b 1.120 https://github.com/samtools/htsjdk.git picard/htsjdk

# Build picard
WORKDIR ./picard/
RUN ant -lib lib/ant package-commands

# Copy
RUN echo "#!/bin/bash\nmkdir /shared/picard && cp -r ../picard/dist/* /shared/picard" >> copy.sh && chmod +x copy.sh
CMD ["./copy.sh"]


