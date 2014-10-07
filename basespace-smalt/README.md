### basespace-smalt

##### Description
`npg_basespace-smalt` contains Dockerfiles for setting up smalt alignment pipelines inside a Docker container, that can be uploaded as a Illumina Basespace Native App.

`Dockerfile` builds everything from scratch.
`Dockerfile.baseimage` uses build-baseimage (see `../autobuild/baseimage`) to avoid redundancy. This image will be uploaded to the Docker repository at one point.

###### Quick Start Instructions: Get it running on BaseSpace
1. Create [Dev Account](https://developer.basespace.illumina.com/)
2. Create [Native App](https://developer.basespace.illumina.com/apps/new)
3. (For local testing): Install the [SpaceDock VM](https://developer.basespace.illumina.com/docs/content/documentation/native-apps/setup-dev-environment#Instructions_for_Mac_or_Linux)
4. Build image and push it to Basespace
```
# Use your BaseSpace credentials when prompted for username, password, and email
sudo docker login docker.illumina.com

# Build Image from Dockerfile
sudo docker build -t docker.illumina.com/[yourRepoName]/smaltAligner .

# Push Image to BaseSapce
sudo docker push docker.illumina.com/[yourRepoName]/smaltAligner
```

5. Copy and paste `basespace/Input_Form.txt` and `basespace/Callback_js.txt` into the Form Builder. Adjust image name in callback.js accordingly.
6. In the Form Builder Preview find the `sudo spacedock -a …` command on the bottom right. SSH into SpaceDock VM and run that command.
7. Select desired input samples, reference and output. Run the alignment with **Send To Local Agent**.
  - Illumina provides a [sample project](https://basespace.illumina.com/s/LbRGgqcP0qTR), if input is needed.
8. Copy and paste `basespace/Output_Report` to Reports Builder.
