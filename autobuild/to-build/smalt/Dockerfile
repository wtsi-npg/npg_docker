FROM sanger_npg/autobuild-baseimage
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Dependencies: git wget build-essential zlib1g-dev autoconf automake libtool

# Download sources
WORKDIR /home
RUN git clone -b 0.0.50-release-20140430085950 https://github.com/gt1/bambamc.git bambamc &&\
    wget -O smalt.tar.gz \
    http://sourceforge.net/projects/smalt/files/smalt-0.7.6.tar.gz/download &&\
    tar -xf smalt.tar.gz

# Build dependency for SAM support
WORKDIR ./bambamc
RUN autoreconf -i -f &&\
    ./configure &&\
    make &&\
    make install &&\
    export LD_LIBRARY_PATH=/home/bambamc/src/.libs

# Build smalt
WORKDIR ../smalt-0.7.6
RUN ./configure &&\
    make && \
    make install

# Copy binary to mounted folder, when container is run
RUN echo "#!/bin/bash\nmkdir -p /shared/smalt/\ncp /home/smalt-0.7.6/src/smalt /shared/smalt/smalt\ncp ../bambamc/src/.libs/libbambamc.so.0 /shared/smalt/" >> copy.sh && chmod +x copy.sh
CMD ["./copy.sh"]
