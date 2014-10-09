FROM debian:jessie
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Bioinformatics Tools Versions
# TODO: smalt and samtools still have hard-coded WORKDIR instructions, see below
ENV bambamc_version 0.0.50-release-20140430085950
ENV smalt_version 0.7.6
ENV samtools_version 1.1
ENV libmaus_version libmaus_experimental_0_0_153
ENV biobambam_version biobambam_experimental_0_0_163

# Install dependencies
RUN apt-get update -q &&\
    apt-get install -qy build-essential \
                        autoconf \
                        automake \
                        git \
                        gnuplot \
                        libtool \
                        libncurses5-dev \
                        libncursesw5-dev \
                        pkg-config \
                        wget \
                        zlib1g-dev


# Build bioinformatics tools in /home:
WORKDIR /home

# Build bambamc lib (for smalt bam support)
RUN git clone -b $bambamc_version https://github.com/gt1/bambamc.git bambamc
WORKDIR ./bambamc
RUN autoreconf -i -f &&\
    ./configure &&\
    make && make install
WORKDIR ..

# Build smalt
RUN wget -qO- http://sourceforge.net/projects/smalt/files/smalt-$smalt_version.tar.gz/download \
    | tar -xz
# TODO: Use env variable as soon as docker 1.3 is released
WORKDIR ./smalt-0.7.6
RUN ./configure &&\
    make && make install
WORKDIR ..

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

# Build samtools
RUN wget -qO- http://sourceforge.net/projects/samtools/files/samtools/$samtools_version/samtools-$samtools_version.tar.bz2/download | tar -xj
# TODO: Use env variable as soon as docker 1.3 is released
WORKDIR ./samtools-1.1
RUN make && make install
WORKDIR ..


# Setting up environment for running on BaseSpace
ENV LD_LIBRARY_PATH LD_LIBRARY_PATH:/usr/local/lib
COPY ./references /references
COPY ./smalt_entrypoint.sh /smalt_entrypoint.sh
RUN chmod +x /smalt_entrypoint.sh
WORKDIR ../../
CMD ["/smalt_entrypoint.sh"]
