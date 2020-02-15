TAG=$(basename $PWD)
docker build --target=development -t docker-weight-loss:${TAG}-dev .
