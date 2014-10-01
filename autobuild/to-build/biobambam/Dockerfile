FROM sanger_npg/autobuild-baseimage
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Dependencies: git build-essential zlib1g-dev autoconf automake libtool pkg-config

# Download
WORKDIR /home/build/
RUN git clone -b libmaus_experimental_0_0_153 https://github.com/gt1/libmaus.git libmaus &&\
    git clone -b biobambam_experimental_0_0_163 https://github.com/gt1/biobambam.git biobambam

# Build libmaus
WORKDIR ./libmaus
RUN autoreconf -i -f && ./configure &&\
    make && make install

# Build biobambam
WORKDIR ../biobambam
RUN autoreconf -i -f &&\
    ./configure --with-libmaus=${LIBMAUSPREFIX} --prefix=${HOME}/biobambam &&\
    make && make install

# Copy binaries to mounted folder, when container is run
RUN echo "#!/bin/bash\ncp -r /home/build/biobambam/src/ /shared/biobambam" >> copy.sh && chmod +x copy.sh
CMD ["./copy.sh"]
