FROM ubuntu:14.04
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>


ENV teepot_version 1.0.1
ENV libmaus_version 0.0.168-release-20141013091820
ENV biobambam_version 0.0.172-release-20141013093121
ENV bwa_version 0.7.8
ENV illumina2bam_version V1.16
ENV bcel_version 5.2
ENV picard_version 1.72
ENV htsjdk_version 1.120
ENV samtools_version 1.1
# Staying on most recent p4 version for now
ENV p4_branch devel


# Install dependencies
RUN sudo apt-get update -q &&\
    sudo apt-get install -qy \
      build-essential \
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
RUN autoreconf -i -f && ./configure && make && make install
WORKDIR ..

# Build biobambam
RUN git clone -b $biobambam_version https://github.com/gt1/biobambam.git biobambam
WORKDIR ./biobambam
RUN autoreconf -i -f && ./configure && make && make install
WORKDIR ..

# Build teepot
RUN git clone -b $teepot_version https://github.com/wtsi-npg/teepot.git teepot
WORKDIR ./teepot
RUN autoreconf -i -f && ./configure && make && make install
WORKDIR ..

# Build bwa
RUN git clone -b $bwa_version https://github.com/lh3/bwa.git bwa
WORKDIR ./bwa
RUN make && cp bwa /usr/local/bin/bwa
WORKDIR ..

# Build illumina2bam
RUN git clone -b $illumina2bam_version https://github.com/wtsi-npg/illumina2bam.git \
      illumina2bam &&\
    wget -qO- http://supergsego.com/apache//commons/bcel/binaries/bcel-$bcel_version.tar.gz \
      | tar -xz
WORKDIR ./illumina2bam/
RUN export CLASSPATH=/bcel-5.2/bcel-5.2.jar && ant jar
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
    | tar -xj
WORKDIR ./samtools-$samtools_version
RUN make && make install
WORKDIR ..

# Build p4
RUN git clone -b $p4_branch https://github.com/wtsi-npg/p4.git p4
WORKDIR ./p4/
RUN perl ./Build.PL && ./Build installdeps && ./Build install
WORKDIR ..

# Point to lib for dynamically linked binaries
RUN ldconfig
# Install java jars for p4 flow
RUN mkdir -p /usr/local/jars && mv /illumina2bam/dist/* /usr/local/jars/ &&\
    mv /picard/dist/* /usr/local/jars
# Copy testscript
COPY ./test /test
