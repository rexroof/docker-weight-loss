TAG=$(basename $PWD)
DOCKER_USERNAME=${DOCKER_USERNAME:-rexroof}
docker tag docker-weight-loss:${TAG} ${DOCKER_USERNAME}/docker-weight-loss:${TAG}
docker push ${DOCKER_USERNAME}/docker-weight-loss:${TAG}
