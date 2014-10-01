FROM ubuntu:14.04
MAINTAINER Stefan Dang <sd15@sanger.ac.uk>

# Install gnuplot
RUN sudo apt-get update && sudo apt-get install -yqq gnuplot

# Add binaries and env variables
ADD ./bin /home/bin

# Add references and entrypoint script
ADD ./references /references
ADD ./smalt_entrypoint.sh /smalt_entrypoint.sh
RUN chmod +x /smalt_entrypoint.sh
WORKDIR ../../../
ENV PATH $PATH:/home/bin
ENV LD_LIBRARY_PATH /home/bin/lib
CMD ["/smalt_entrypoint.sh"]
