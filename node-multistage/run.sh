TAG=$(basename $PWD)
PORT=8383

echo "site listening on http://localhost:$PORT"
docker run --rm -p ${PORT}:80 -it docker-weight-loss:${TAG}
