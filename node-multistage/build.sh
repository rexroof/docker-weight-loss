TAG=$(basename $PWD)
docker build -t docker-weight-loss:${TAG} .
