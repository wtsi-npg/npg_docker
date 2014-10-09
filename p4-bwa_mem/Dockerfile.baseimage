FROM sanger_npg/autobuild-baseimage
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Install dependencies
RUN sudo apt-get install -yqq \
    staden-io-lib-utils

# Download sources
WORKDIR /home
RUN git clone https://github.com/wtsi-npg/p4.git p4 &&\
    git clone -b 1.0.1 https://github.com/wtsi-npg/teepot.git teepot &&\
    git clone -b libmaus_experimental_0_0_164 https://github.com/gt1/libmaus.git libmaus &&\
    git clone -b biobambam_experimental_0_0_163 https://github.com/gt1/biobambam.git biobambam &&\
    git clone -b 0.7.8 https://github.com/lh3/bwa.git bwa &&\
    git clone -b V1.16 https://github.com/wtsi-npg/illumina2bam.git illumina2bam &&\
    wget -O bcel.tar.gz \
    http://supergsego.com/apache//commons/bcel/binaries/bcel-5.2.tar.gz &&\
    tar -xf bcel.tar.gz &&\
    git clone -b 1.72 https://github.com/broadinstitute/picard.git picard &&\
    git clone -b 1.120 https://github.com/samtools/htsjdk.git picard/htsjdk &&\
    wget -O samtools.tar.bz2 \
    http://sourceforge.net/projects/samtools/files/samtools/1.0/samtools-1.0.tar.bz2/download &&\
    tar xjf samtools.tar.bz2

# Build libmaus
WORKDIR ./libmaus
RUN autoreconf -i -f && ./configure &&\
    make && make install

# Build biobambam
WORKDIR ../biobambam
RUN autoreconf -i -f &&\
    ./configure --with-libmaus=${LIBMAUSPREFIX} --prefix=${HOME}/biobambam &&\
    make && make install

# Build teepot
WORKDIR ../teepot
RUN autoreconf -i -f && ./configure &&\
    make && make install

# Build bwa
WORKDIR ../bwa
RUN make && make install

# Build illumina2bam
WORKDIR ../illumina2bam/
# Install and retain path to java jars in p4 example configs
RUN export CLASSPATH=/home/build/bcel-5.2/bcel-5.2.jar && ant jar &&\
    mkdir -p /software/npg/java_jars/ && cp -r dist/* /software/npg/java_jars/

# Build picard
WORKDIR ../picard/
# Install and retain path to java jars in p4 example configs
RUN ant -lib lib/ant package-commands && cp -r dist/* /software/npg/java_jars/

# Build samtools
WORKDIR ../samtools-1.0
RUN make && make install

# Build p4
WORKDIR ../p4/
RUN perl ./Build.PL &&\
    ./Build installdeps &&\
    chmod +x ./bin/* &&\
    cp ./bin/* /usr/local/bin

# Cleanup
RUN sudo apt-get remove -yqq \
    git \
    build-essential \
    zlib1g-dev \
    autoconf \
    automake \
    libtool \
    pkg-config && \
    sudo apt-get -y autoremove && \
    sudo apt-get clean

# p4 Entrypoint
WORKDIR ../../
ADD ./p4_entrypoint.sh /p4_entrypoint.sh
RUN chmod +x p4_entrypoint.sh
ENTRYPOINT ["./p4_entrypoint.sh"]
CMD ["bash"]
