
# Docker Weight Loss Tips

This repo is meant to accompany a 5 minute talk about keeping docker image sizes down.   It contains a list of the topics covered in that talk and a brief example for each. 

<!--ts-->
   * [Docker Weight Loss Tips](#docker-weight-loss-tips)
      * [How to use this repo](#how-to-use-this-repo)
      * [Group together instructions](#group-together-instructions)
         * [cmatrix example](#cmatrix-example)
         * [python example](#python-example)
      * [Exclude files with .dockerignore](#exclude-files-with-dockerignore)
      * [choosing a smaller base image](#choosing-a-smaller-base-image)
         * [base image simple example](#base-image-simple-example)
      * [multi-stage builds](#multi-stage-builds)
         * [golang multistage example](#golang-multistage-example)
         * [nodejs multistage example](#nodejs-multistage-example)
      * [dive image analysis tool](#dive-image-analysis-tool)
      * [final notes and links](#final-notes-and-links)

<!-- Added by: rexroof, at: Sat Feb 15 12:29:38 EST 2020 -->

<!--te-->

## How to use this repo
The working examples in this repo all require docker.  They have been tested on macos but should work as written in linux and windows.  Each folder contains a dockerfile and a build.sh and run.sh script. Run the build.sh script to build the container and then the run.sh script to start the container.  In all cases run.sh can be exited with Control-C. Feel free to reach out if you have any questions.  I'm available on [twitter](https://twitter.com/rexroof) or by emailing [dockerweightloss@rexroof.com](mailto:dockerweightloss@rexroof.com)

## Group together instructions
Most of the instructions in a Dockerfile will create a layer in your resulting docker image. If you create files in a layer and remove them later in the dockerfile, you're storing files in your image that you'll never use.  It's wise to group together commands that create and delete files into a single instruction to avoid caching files you'll end up deleting.  One obvious example of this is installing a compiler to build software.  The compiler is only needed to build the software, not to run it. 

### cmatrix example
This example downloads and compiles the `cmatrix` command line novelty.  This is a command that prints a matrix-style screensaver to your terminal.   I have written two examples that have drastically different sizes.   **NOTE:** This command might corrupt your terminal.  Running `reset` after exiting the cmatrix will fix it.

An un-optimized version of the cmatrix demo can be found in the **cmatrix/** folder. The optimized version can be found in **cmatrix-compact/**.  Try running the `./build.sh` script in each and then running `docker history` to compare the layers in each.  The build.sh script outputs the exact history command you can run.    you can also use `docker image list` to see the image sizes. 

### python example
In the **python-layers/** folder you will find an example using python.  This is a
common pattern for python containers.  It copies our requirements.txt into the
container first.  This ensures that we only invalidate the cache here when our
requirements change.  Next we install our build dependencies and run our pip install,then we remove our build dependencies.  This is done in a single step to make sure there aren't any extra files stored in our layers.  

Try editing the dockerfile in this folder, see if you break these commands into
multiple instructions how it changes the size of the container.

When you run this example it will start a flask application.  When the run.sh script is running, you can use a web browser or curl http://localhost:5001/ to see the application response.

## Exclude files with .dockerignore
In the **docker-ignore/** folder there is a simple example using .dockerignore.  An alpine container copies files into a new container, excluding any of the even numbered file names.  When the container is run it lists the files in the container's /app folder.   You can experiment by editing the .dockerignore file and re-building & re-running the container. 

## choosing a smaller base image
Pre-built images on docker hub often come in many different variants. These different tags will differ in the version of software installed or the amount of extra software included.    I always suggest that you use the smallest base image you can and install just what you need.  There are always trade-offs here.  for quick experiments I might choose the full-sized image, but always go back later and refine when a project goes into the next phase. 

### base image simple example
There are two example folders in this repo to demonstrate this:  **base-image-full/** and **base-image-slim/**.  You can use the `build.sh` scripts in each and then compare the resulting sizes with `docker image list`.   Remember that these containers have the same functionality, but with drastically different sizes.   I've also included a kubernetes manifest in each folder that can be used to deploy this container.  In my tests, the reduced image size can make a difference of almost a minute.   And even show speed improvements when the container is already cached locally. 

## multi-stage builds

### golang multistage example
### nodejs multistage example

## dive image analysis tool
One useful tool for analyzing wasted space in your docker containers is [dive](https://github.com/wagoodman/dive).  I've included a `dive.sh` script in the top level of this repo.  It will rebuild a docker image and open the dive analysis tool on the newly built image.    You can run it by going into any of the example folders and running `../dive.sh`.  Comparing the cmatrix and cmatrix-compact examples.   Take note of the Image efficiency score and potentially wasted space in each container.   You can also use this tool to browse changes in the filesystem for each layer of your image. 


## final notes and links

I'm Rex Roof.   I live in Michigan, USA and work on infrastructure at Blue Newt Software. You can find me at most internet places with the name `rexroof`.

Links to slides for when I gave this talk at Devops Days Guadalajara
<>

link to dive tool: <https://github.com/wagoodman/dive>
be sure to read docker best practices: <https://docs.docker.com/develop/develop-images/dockerfile_best-practices/>
useful article: <https://medium.com/@gdiener/how-to-build-a-smaller-docker-image-76779e18d48a>
docker articles (python focused, but not all python specific): <https://pythonspeed.com/docker/>
docker docs on multistage builds: <https://docs.docker.com/develop/develop-images/multistage-build/>
