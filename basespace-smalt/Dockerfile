FROM debian:jessie
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Install dependencies
RUN apt-get update &&\
    apt-get install -yqq \
      autoconf \
      automake \
      build-essential \
      git \
      gnuplot \
      libtool \
      libncurses5-dev \
      libncursesw5-dev \
      pkg-config \
      wget \
      zlib1g-dev

# Bioinformatics Tools Versions
ENV bambamc_version 0.0.50-release-20140430085950
ENV smalt_version 0.7.6
ENV samtools_version 1.1
ENV libmaus_version 0.0.168-release-20141013091820
ENV biobambam_version 0.0.172-release-20141013093121
# TODO: smalt and samtools still have hard-coded WORKDIR instructions, see below


# Build bambamc lib (for smalt bam support)
RUN git clone -b $bambamc_version https://github.com/gt1/bambamc.git bambamc
WORKDIR ./bambamc
RUN autoreconf -i -f && ./configure && make && make install
WORKDIR ..

# Build smalt
RUN wget -O smalt.tar.gz \
    http://sourceforge.net/projects/smalt/files/smalt-$smalt_version.tar.gz/download &&\
    tar -xf smalt.tar.gz
WORKDIR ./smalt-0.7.6
RUN ./configure && make && make install
WORKDIR ..

# Build libmaus
RUN git clone -b $libmaus_version https://github.com/gt1/libmaus.git libmaus
WORKDIR ./libmaus
RUN autoreconf -i -f && ./configure && make && make install
WORKDIR ..

# Build biobambam
RUN git clone -b $biobambam_version https://github.com/gt1/biobambam.git biobambam
WORKDIR ./biobambam
RUN autoreconf -i -f &&\
    ./configure && make && make install
WORKDIR ..

# Build samtools
RUN wget -O samtools.tar.bz2 \
    http://sourceforge.net/projects/samtools/files/samtools/1.1/samtools-1.1.tar.bz2/download &&\
    tar -xjf samtools.tar.bz2
WORKDIR ./samtools-1.1
RUN make && make install
WORKDIR ..


# Setting up environment for running on BaseSpace
ENV LD_LIBRARY_PATH LD_LIBRARY_PATH:/usr/local/lib
# TODO: Remove in production as iGenomes will become available
ADD ./references /references
ADD ./smalt_entrypoint.sh /smalt_entrypoint.sh
RUN chmod +x /smalt_entrypoint.sh
WORKDIR ../../../
CMD ["/smalt_entrypoint.sh"]
