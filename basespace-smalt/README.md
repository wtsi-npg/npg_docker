### npg_basespace-smalt

##### Description
`npg_basespace-smalt` contains Dockerfiles for setting up smalt alignment pipelines inside a Docker container, that can be uploaded as a Illumina Basespace Native App.

`Dockerfile` uses build-baseimage (see `../autobuild/baseimage`) to avoid redundancy. This image will be uploaded to the Docker repository at one point.
`Dockerfile.scratch` builds everything from scratch.

###### Quick Start: Upload to Basespace
1. Create [Dev Account](https://developer.basespace.illumina.com/)
2. Create [Native App](https://developer.basespace.illumina.com/apps/new)
3. (For testing): Install the [SpaceDock VM](https://developer.basespace.illumina.com/docs/content/documentation/native-apps/setup-dev-environment#Instructions_for_Mac_or_Linux)
4. Build image and push it to Basespace
```
# Use your BaseSpace credentials when prompted for username, password, and email
sudo docker login docker.illumina.com

# Build Image from Dockerfile
sudo docker build -t docker.illumina.com/[yourRepoName]/smaltAligner .

# Push Image to BaseSapce
sudo docker push docker.illumina.com/[yourRepoName]/smaltAligner
```

5. Copy and paste `basespace/Output_Report` to Reports Builder.
6. Copy and paste `basespace/Input_Form.txt` and `basespace/Callback_js.txt` (adjust image name!) to the Form Builder.
7. In the Form Builder Preview find the `sudo spacedock -a …` command on the bottom right. SSH into your SpaceDock VM and run that command.
8. Select desired input, reference and output. Run the alignment with **Send To Local Agent**.
