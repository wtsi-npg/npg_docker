function launchSpec(dataProvider){
    var projectId = dataProvider.GetProperty("Input.project-id").Id;
    var ref = dataProvider.GetProperty("Input.select-ref");
    var wordlen = dataProvider.GetProperty("Input.index-wordlen");
    var stepsize = dataProvider.GetProperty("Input.index-skipstep");
    var insertmax = dataProvider.GetProperty("Input.map-max");
    var insertmin = dataProvider.GetProperty("Input.map-min");
    var retval = {
        commandLine: ["/smalt_entrypoint.sh", ref, projectId, wordlen, stepsize, insertmax, insertmin],
        containerImageId: "docker.illumina.com/sd15_npg/smalt"
    };
    return retval;
}
