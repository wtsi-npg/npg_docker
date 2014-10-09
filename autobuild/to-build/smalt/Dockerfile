FROM sanger_npg/autobuild-baseimage
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Dependencies: git wget build-essential zlib1g-dev autoconf automake libtool
ENV bambamc_version 0.0.50-release-20140430085950
ENV smalt_version 0.7.6

WORKDIR /home/build

# Build dependency library bambamc for SAM support
RUN git clone -b $bambamc_version https://github.com/gt1/bambamc.git bambamc
WORKDIR ./bambamc
RUN autoreconf -i -f &&\
    ./configure &&\
    make &&\
    make install &&\
    export LD_LIBRARY_PATH=/home/bambamc/src/.libs
WORKDIR ..

# Build smalt
RUN wget -qO- smalt.tar.gz http://sourceforge.net/projects/smalt/files/smalt-$smalt_version.tar.gz/download \
    | tar -xz
# TODO: Use env variable as soon as docker 1.3 is released
WORKDIR ./smalt-0.7.6
RUN ./configure &&\
    make && \
    make install
WORKDIR ..

# Copy binary to mounted folder, when container is run
RUN echo "#!/bin/bash\nmkdir -p /autobuild/smalt/\ncp /home/build/smalt-0.7.6/src/smalt \
      /autobuild/smalt/smalt\ncp /home/autobuild/bambamc/src/.libs/libbambamc.so.0 \
      /autobuild/smalt/" >> copy.sh && chmod +x copy.sh
CMD ["./copy.sh"]
