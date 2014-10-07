FROM ubuntu:14.04
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>


# Install dependencies
RUN sudo apt-get update &&\
    sudo apt-get install -yqq build-essential \
                              zlib1g-dev \
                              autoconf \
                              automake \
                              libtool \
                              pkg-config \
                              wget \
                              git \
                              libncurses5-dev \
                              libncursesw5-dev \
                              gnuplot


# Download bioinformatics tools; stick on top of Dockerfile for easier version changes
WORKDIR /home
RUN git clone -b 0.0.50-release-20140430085950 https://github.com/gt1/bambamc.git bambamc &&\
    wget -O smalt.tar.gz \
    http://sourceforge.net/projects/smalt/files/smalt-0.7.6.tar.gz/download &&\
    tar -xf smalt.tar.gz
RUN wget -O samtools.tar.bz2 \
    http://sourceforge.net/projects/samtools/files/samtools/1.1/samtools-1.1.tar.bz2/download &&\
    tar -xjf samtools.tar.bz2
RUN git clone -b libmaus_experimental_0_0_153 https://github.com/gt1/libmaus.git libmaus &&\
    git clone -b biobambam_experimental_0_0_163 https://github.com/gt1/biobambam.git biobambam


# Build bambamc lib (for smalt bam support)
WORKDIR ./bambamc
RUN autoreconf -i -f &&\
    ./configure &&\
    make && make install

# Build smalt
WORKDIR ../smalt-0.7.6
RUN ./configure &&\
    make && make install

# Build libmaus
WORKDIR ../libmaus
RUN autoreconf -i -f && ./configure &&\
    make && make install

# Build biobambam
WORKDIR ../biobambam
RUN autoreconf -i -f &&\
    ./configure --with-libmaus=${LIBMAUSPREFIX} --prefix=${HOME}/biobambam &&\
    make && make install

# Build samtools
WORKDIR ../samtools-1.1
RUN make && make install

# Add references and entrypoint script
ADD ./references /references
ADD ./smalt_entrypoint.sh /smalt_entrypoint.sh
RUN chmod +x /smalt_entrypoint.sh
WORKDIR ../../../
CMD ["/smalt_entrypoint.sh"]
