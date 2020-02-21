
# Docker Weight Loss Tips

This repo is meant to accompany a 5 minute talk about keeping docker image sizes down.   It contains a list of the topics covered in that talk and a brief example for each. 

<!--ts-->
   * [Docker Weight Loss Tips](#docker-weight-loss-tips)
      * [How to use this repo](#how-to-use-this-repo)
      * [Docker layers and caching](#docker-layers-and-caching)
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

<!-- Added by: rexroof, at: Sat Feb 15 15:50:07 EST 2020 -->

<!--te-->

## How to use this repo
The working examples in this repo all require docker.  They have been tested on MacOS but should work as written in Linux and Windows.  Each folder contains a dockerfile and a build.sh and run.sh script. Run the build.sh script to build the container and then the run.sh script to start the container.  In all cases run.sh can be exited with Control-C. Feel free to reach out if you have any questions.  I'm available on [twitter](https://twitter.com/rexroof) or by emailing [dockerweightloss@rexroof.com](mailto:dockerweightloss@rexroof.com)

## Docker layers and caching
The `docker build` command reads a Dockerfile, executing each step in order.  After every step it will create a filesystem layer that it can cache.  A later build of this image will check to see if there is a local cache of this layer available.  Instead of rebuilding the layer, it will just reference the cache.  Cached layers will also affect what layers get pushed up to a registry, and also which layers need to be downloaded from that registry when deploying.  This is why it is always good to minimize the number of layers you need to create.  Or, alternatively, optimize steps in your dockerfile to better use the layer caching to your benefit.  

Most often this means you copy in your package dependencies early in your dockerfile (aka requirements.txt or package.json), then do your installs, and only after install, copy in the rest of your source code.   This will mean you only need to rebuild your packages when your requirements have changed.  Otherwise docker will reference it's prebuilt cache. 


## Group together instructions
One way to minimize the layers in your dockerfile is to group together instructions.  The best place to do this is any time you are creating files in your container that you will later be deleting.  If you create files in a layer and remove them later in the dockerfile, you're storing files in your image that you'll never use.  One obvious example of this is installing a compiler to build software.  The compiler is only needed to build the software, not to run it. 

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
Docker allows you to define multiple docker containers in a single Dockerfile.   Docker will build each of the containers in the file, in order.   By default docker will build up to the last container in the file.  Providing the --target option to docker will make it stop building at an earlier container in the file.  Only the target container's filesystem layers will end up in the resulting docker image.  This allows you to create a development container for use while developing software, and then a later container in the file can copy out the files needed for production, which will result in a much smaller container.

### golang multistage example
In the **go-multistage/** folder is a common golang example using multistage builds.  This Dockerfile contains three stages:  first a build stage that compiles the go binary.  Second is an alpine container that takes a copy of the compiled binary with nothing else.  and last is a scratch container with just the compiled binary.   There is a `build_all.sh` script that will build each of these stages into their own tagged image, after running that script you can see the sizes of each of these different containers using `docker image list`.

While building these containers your local docker will cache each of the layers like normal, but when tagging the resulting image it only uses the layers from the final container.  This makes for potentially very small images, though you may lose some of the benefits of those cached layers.  

### nodejs multistage example
The **node-multistage** folder contains an example nodejs-react project with a Dockerfile setup that I've used often.   It has a three-stage dockerfile.  The first stage is a development container.  If you target and run it alone, it will run your nodejs project in development mode.   The second container starts with the development container as it's base, and then runs your node build to produce an artifact.   The last container defined is an nginx web server container that only copies your build artifact.   This makes for a very small deployed container.  

This folder contains a `build_dev.sh` and `run_dev.sh` script that will build and run the docker container in development mode.   If you run build_dev and run_dev, it will start the project.  With the project running any edits in the source directory will be hot-loaded on the site.  I suggest you open <http://localhost:3000> in your browser and try editing the html in `src/App.js` on lines 11-13. 

It might also be useful to compare the image sizes between the node-multistage and node-multistage-dev container. 

## dive image analysis tool
One useful tool for analyzing wasted space in your docker containers is [dive](https://github.com/wagoodman/dive).  I've included a `dive.sh` script in the top level of this repo.  It will rebuild a docker image and open the dive analysis tool on the newly built image.    You can run it by going into any of the example folders and running `../dive.sh`.  Compare the dive analysis of the cmatrix and cmatrix-compact examples.   Take note of the Image efficiency score and potentially wasted space in each container.   You can also use this tool to browse changes in the filesystem for each layer of your image. 


## final notes and links

I'm Rex Roof.   I live in Ann Arbor,  Michigan, USA and work on infrastructure at Blue Newt Software. You can find me at most internet places with the name `rexroof`.

Links to slides for when I gave this talk at Devops Days Guadalajara
<https://docs.google.com/presentation/d/1rHhL_tT7umwVMQTod9FOJZWJaIZZn0JUz7w2GD0wn-4/edit?usp=sharing>

A version of the slides in spanish:
<https://docs.google.com/presentation/d/1XViz5u4i404vLVJ7CE0TVKPq_WP8MaQqVmCtBBftpkM/edit?usp=sharing>


link to dive tool: <https://github.com/wagoodman/dive>\
be sure to read docker best practices: <https://docs.docker.com/develop/develop-images/dockerfile_best-practices/>\
useful article: <https://medium.com/@gdiener/how-to-build-a-smaller-docker-image-76779e18d48a>\
docker articles (python focused, but not all python specific): <https://pythonspeed.com/docker/>\
docker docs on multistage builds: <https://docs.docker.com/develop/develop-images/multistage-build/>\
docker layer analyzer: <https://github.com/orisano/dlayer>

