FROM ubuntu:14.04
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Install dependencies
RUN sudo apt-get update &&\
    sudo apt-get install -yqq \
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
ENV libmaus_version 0.0.167-release-20140917101853
ENV biobambam_version 0.0.171-release-20140917102804
# TODO: smalt and samtools use cd instead of WORKDIR to propagate ENV properly
#       Docker 1.3 will have environment variable support for WORKDIR


# Build bambamc lib (for smalt bam support)
RUN git clone -b $bambamc_version https://github.com/gt1/bambamc.git bambamc
WORKDIR ./bambamc
RUN autoreconf -i -f && ./configure && make && make install
WORKDIR ..

# Build smalt
RUN wget -O smalt.tar.gz \
    http://sourceforge.net/projects/smalt/files/smalt-$smalt_version.tar.gz/download &&\
    tar -xf smalt.tar.gz
#WORKDIR ./smalt-$smalt-version
RUN cd smalt-$smalt_version && ./configure && make && make install
#WORKDIR ..

# Build libmaus
RUN git clone -b $libmaus_version https://github.com/gt1/libmaus.git libmaus
WORKDIR ./libmaus
RUN autoreconf -i -f && ./configure && make && make install
WORKDIR ..

# Build biobambam
RUN git clone -b $biobambam_version https://github.com/gt1/biobambam.git biobambam
WORKDIR ./biobambam
RUN autoreconf -i -f && ./configure && make && make install
WORKDIR ..

# Build samtools
RUN wget -O samtools.tar.bz2 \
    http://sourceforge.net/projects/samtools/files/samtools/1.1/samtools-1.1.tar.bz2/download &&\
    tar -xjf samtools.tar.bz2
#WORKDIR ./samtools-$samtools_version
RUN cd samtools-$samtools_version && make && make install
#WORKDIR ..


# Setting up environment for running on BaseSpace
ENV LD_LIBRARY_PATH LD_LIBRARY_PATH:/usr/local/lib
# TODO: Remove in production as iGenomes will become available
ADD ./references /references
ADD ./smalt_entrypoint.sh /smalt_entrypoint.sh
RUN chmod +x /smalt_entrypoint.sh
WORKDIR ../../../
CMD ["/smalt_entrypoint.sh"]
