### p4

This container contains all software needed for a full DNA alignment pipeline similar to current best practice at Sanger. [p4](https://github.com/wtsi-npg/p4) is an in-house perl wrapper for sequencing pipelines. Flows can be formulated as directed (sub)graphs, improving intuitive readability and maintainability.

#### Usage
Mount input data and input graphs into container. Then run flow manually. To test the container build image and then run `docker run <image name> /test/test.sh`. This might take a while as the input data will be downloaded from Sanger FTP.
