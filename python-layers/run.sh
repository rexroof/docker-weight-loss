TAG=$(basename $PWD)
PORT=5001

echo "python service listening on http://localhost:$PORT"
docker run --rm -it -p ${PORT}:5000 docker-weight-loss:${TAG}
