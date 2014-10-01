### boot2docker-fileIO-wrapper

#### The problem: Mounting folders from local machine instead of boot2docker VM
As you probably know Docker is a client-server application. [Due to the very nature](https://docs.docker.com/introduction/understanding-docker/#what-is-dockers-architecture) of docker containers client and daemon don't run on the same host on OS X and Windows. Rather, the Docker server runs inside a small virtual machine providing a compatible kernel instead: boot2docker.

For unexperienced users this can lead to unexpected behavior with mounted folders. Docker mounts from the server host, namely the boot2docker VM, while the user would expect that to happen on the client host, namely the local machine.

#### A (very hacky) solution: `b2d-wrapper.sh`
I created a wrapper script to run docker containers and orchestrate all the needed file IO. It does the following:
- Copy input folder from local machine into b2d VM
- Run container, mounting input / output folders on VM
- Copy results to output folder to local machine
- Tidy up inside VM

While this strategy is not recommended for larger files and development in general (see below), it can be incorporated to maximize portability of any wrapper script when dealing with small-sized mountpoints.

##### Installation & Usage
Modify the wrapper script to your needs. Then run as follows:
```
b2d-wrapper.sh <input> <output> <docker image> <optional: args for ENTRYPOINT / CMD>
```
This was tested with Docker 1.2 and boot2docker 1.2 on a machine running OS X 10.9.4.

#### Two better solutions to consider before using this script
To my knowledge there are two better ways to solve this problem. Both solutions mount a folder from the local machine, which can again be mounted by any docker containers. #inception
- [Modifiy the boot2docker VM](https://medium.com/boot2docker-lightweight-linux-for-docker/boot2docker-together-with-virtualbox-guest-additions-da1e3ab2465c) to contain guest additions from local host.
- Skip b2d, run Docker [inside Linux VM instead](http://cjlarose.com/2014/03/08/run-docker-with-vagrant.html).
