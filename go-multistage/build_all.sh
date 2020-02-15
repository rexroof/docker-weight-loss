TAG=$(basename $PWD)

echo building build ...
docker build --target=build -t docker-weight-loss:${TAG}-build .

echo building alpine ...
docker build --target=alpine-run -t docker-weight-loss:${TAG}-alpine .

echo building scratch ...
docker build --target=scratch-run -t docker-weight-loss:${TAG}-scratch .

echo ""
echo "check the output of 'docker image list | grep go-multistage' "
