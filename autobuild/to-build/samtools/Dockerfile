FROM sanger_npg/autobuild-baseimage
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Dependencies: zlib1g-dev wget libncurses5-dev libncursesw5-dev libtool
ENV samtools_version 1.1

WORKDIR /home/build/

# Build samtools
RUN wget -qO- \
    http://sourceforge.net/projects/samtools/files/samtools/$samtools_version/samtools-$samtools_version.tar.bz2/download \
    | tar -xjz
# TODO: Use env variable as soon as docker 1.3 is released
WORKDIR ./samtools-1.1
RUN make
WORKDIR ..

# Copy binary to mounted folder, when container is run
RUN echo "#!/bin/bash\ncp /home/build/samtools /autobuild/samtools" \
      >> copy.sh && chmod +x copy.sh
CMD ["./copy.sh"]
