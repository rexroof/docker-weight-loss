TAG=$(basename $PWD)

if [ ! -f Dockerfile ] ; then
  echo no dockerfile here
  exit 1
fi

docker run --rm -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ${PWD}:/${TAG} \
  -w /${TAG} \
  wagoodman/dive:latest build -t ${TAG} .
