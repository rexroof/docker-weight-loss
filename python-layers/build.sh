TAG=$(basename $PWD)
docker build -t docker-weight-loss:${TAG} .

echo ""
echo "try running docker history docker-weight-loss:${TAG}"
