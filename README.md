### npg_docker

*Last update: 28/10/14 (sd15)*

This repository centralizes the various small prototypes of Stefan Dang's Placement Project @ Wellcome Trust Sanger Institute, Hinxton. The purpose of this 3 month project was to explore the possibilities to wrap up different alignment programs / pipelines in [Docker](https://www.docker.com/) containers, either for production in closed environments or as Illumina BaseSpace Native Apps. Please refer to the preliminary [slides](IGM-talk_docker-pipelines.pdf) of the Sanger Informatics Group Meeting talk for more fancy illustrations.

#### Overview

**autobuild:**
Script to manage the automatic build of all the required pipeline binaries inside separate Docker containers on top of an identical base image. This significantly reduces building time and maintainablity compared to building all binaries inside one single containers, while still preserving virtualisation advantages (*e.g. predictable environment, data provenance*).

**basespace-smalt:**
Deployment of a small DNA alignment pipeline inside a single container. This can be pushed as a Native App on the Illumina BaseSpace cloud computing environment. JSON / Fluid markup for the input form and output report is provided. The container entrypoint will handle Illumina-conform input and run the pipeline on it.

**boot2docker-wrapper:**
Wrapper script to handle mounting directories from local host instead of boot2docker virtual machine. Is a proof-of-concept and should not be used for production. Better strategies are provided in the readme.

**orchestrated-containers:**
Prototype for script-managed flow (bash wrapper + p4, see below) using orchestrated containers from a private repository.

**p4:**
This container contains all software needed for a full DNA alignment pipeline similar to current best practice at Sanger. [p4](https://github.com/wtsi-npg/p4) is an in-house perl wrapper for sequencing pipelines. Flows can be formulated as directed (sub)graphs, improving intuitive readability and maintainability.
