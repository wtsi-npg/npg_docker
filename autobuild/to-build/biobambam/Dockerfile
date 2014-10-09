FROM sanger_npg/autobuild-baseimage
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Dependencies: git build-essential zlib1g-dev autoconf automake libtool pkg-config
ENV libmaus_version libmaus_experimental_0_0_153
ENV biobambam_version biobambam_experimental_0_0_163

WORKDIR /home/build/

# Build libmaus
RUN git clone -b $libmaus_version https://github.com/gt1/libmaus.git libmaus
WORKDIR ./libmaus
RUN autoreconf -i -f && ./configure &&\
    make && make install
WORKDIR ..

# Build biobambam
RUN git clone -b $biobambam_version https://github.com/gt1/biobambam.git biobambam
WORKDIR ./biobambam
RUN autoreconf -i -f &&\
    ./configure --with-libmaus=${LIBMAUSPREFIX} --prefix=${HOME}/biobambam &&\
    make && make install
WORKDIR ..

# Copy binaries to mounted folder, when container is run
RUN echo "#!/bin/bash\ncp -r /home/build/biobambam/src/ /autobuild/biobambam" \
      >> copy.sh && chmod +x copy.sh
CMD ["./copy.sh"]
