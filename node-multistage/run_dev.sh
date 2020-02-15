TAG=$(basename $PWD)
PORT=3000

echo "site listening on http://localhost:$PORT"
docker run --rm -v ${PWD}/src:/app/src -p ${PORT}:3000 -it docker-weight-loss:${TAG}-dev
