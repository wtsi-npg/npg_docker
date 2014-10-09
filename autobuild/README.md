### npg_docker-autobuild

##### Description
*This application was developed by Stefan Dang while on a summer student placement at the Wellcome Trust Sanger Institute, NPG group in August-October 2014*

##### USAGE
```
./autobuild.sh <input directory / directories> <output directory>
```

##### Description
`autobuild.sh` automatically compiles the binaries needed for a full p4 alignment pipeline based on single docker containers. The whole compilation process including dependencies is contained inside the single containers whose `Dockerfile` contains the “recipe” for each tool.
