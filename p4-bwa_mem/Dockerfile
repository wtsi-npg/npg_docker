FROM debian:jessie
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>


ENV teepot_version 1.0.1
ENV libmaus_version libmaus_experimental_0_0_153
ENV biobambam_version biobambam_experimental_0_0_163
ENV bwa_version 0.7.8
ENV illumina2bam_version V1.16
ENV bcel_version 5.2
ENV picard_version 1.72
ENV htsjdk_version 1.120
ENV samtools_version 1.1
# TODO: Add p4 version, staying on most recent version for development for now


# Install dependencies
RUN apt-get update -q &&\
    apt-get install -qy build-essential \
                        ant \
                        autoconf \
                        automake \
                        git \
                        gnuplot \
                        libtool \
                        libncurses5-dev \
                        libncursesw5-dev \
                        openjdk-7-jdk \
                        pkg-config \
                        staden-io-lib-utils \
                        wget \
                        zlib1g-dev


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

# Build teepot
RUN git clone -b $teepot_version https://github.com/wtsi-npg/teepot.git teepot
WORKDIR ./teepot
RUN autoreconf -i -f && ./configure &&\
    make && make install
WORKDIR ..

# Build bwa
RUN git clone -b $bwa_version https://github.com/lh3/bwa.git bwa
WORKDIR ./bwa
RUN make
WORKDIR ..

# Build illumina2bam
RUN git clone -b $illumina2bam_version https://github.com/wtsi-npg/illumina2bam.git \
      illumina2bam &&\
    wget -qO- http://supergsego.com/apache//commons/bcel/binaries/bcel-$bcel_version.tar.gz \
      | tar -xz
WORKDIR ./illumina2bam/
RUN export CLASSPATH=/home/build/bcel-5.2/bcel-5.2.jar && ant jar
WORKDIR ..

# Build picard with htsjdk
RUN git clone -b $picard_version https://github.com/broadinstitute/picard.git picard && \
    git clone -b $htsjdk_version https://github.com/samtools/htsjdk.git picard/htsjdk
WORKDIR ./picard/
RUN ant -lib lib/ant package-commands
WORKDIR ..

# Build samtools
RUN wget -qO- \
    http://sourceforge.net/projects/samtools/files/samtools/$samtools_version/samtools-$samtools_version.tar.bz2/download \
    | tar -xjz
# TODO: Use env variable as soon as docker 1.3 is released
WORKDIR ./samtools-1.1
RUN make
WORKDIR ..

# Build p4
RUN git clone https://github.com/wtsi-npg/p4.git p4
WORKDIR ./p4/
RUN perl ./Build.PL &&\
    ./Build installdeps &&\
    chmod +x ./bin/* &&\
    cp ./bin/* /usr/local/bin
WORKDIR ..

