### npg_docker-autobuild

##### USAGE
```
./autobuild.sh <input directory / directories> <output directory>
```

##### Description
`autobuild.sh` automatically compiles the binaries needed for a full p4 alignment pipeline based on single docker containers. The whole compilation process including dependencies is contained inside the single containers whose `Dockerfile` contains the “recipe” for each tool.
