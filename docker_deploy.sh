printError () {
  echo "\x1B[31m*** Error: $1\x1B[0m"
  exit;
}

printUsage () {
  echo "Usage: sh $0 PROJECT_NAME GIT_BRANCH PORT";
  exit;
}

if [ "$#" -ne 3 ]; then
  printUsage;
fi;

GIT_BRANCH=$2;
DOCKER_IMG="$1_img";
DOCKER_CNT="$1_cnt";
DOCKER_PORT=$3;

echo "- Start running $0.";
echo "-- Project: $1";
echo "-- Branch: $2";
echo "-- Port: $3";

echo "- Reset and clean project (git reset --hard && git clean -xdf)";
git reset --hard && git clean -xdf;
if [ $? -ne 0 ]; then
  printError "Can't reset and clean project.'";
fi;

echo "- Checkout project to $2's branch.";
git checkout $2;
if [ $? -ne 0 ]; then
  printError "Can't checkout the branch ($2)'";
fi;

echo "- Refresh and update the scripts";
git pull origin $2;
if [ $? -ne 0 ]; then
  printError "Can't pull script from $2 (git pull origin $2)'";
fi;

echo "- Copying id_rsa";
cp ~/.ssh/id_rsa docker/id_rsa
if [ $? -ne 0 ]; then
  printError "Can't copy id_rsa.";
fi;

echo "- Building a docker image ($DOCKER_IMG)";
docker build -t $DOCKER_IMG:latest .;
if [ $? -ne 0 ]; then
  printError "Can't build a docker image.";
fi;

echo "- Mapping configs from map-config's folder.";
node ../map-config/index.js .env_template  > docker/.env;
if [ $? -ne 0 ]; then
  printError "Can't mapping the configs.";
fi;

echo "- Remove old and run the container ($DOCKER_CNT)";
CMD_DOCKER_REMOVE="docker rm -f $DOCKER_CNT";
CMD_DOCKER_RUN="docker run --restart=always --env-file=docker/.env -p $DOCKER_PORT:$DOCKER_PORT -d --name $DOCKER_CNT $DOCKER_IMG";
$CMD_DOCKER_REMOVE && $CMD_DOCKER_RUN;
if [ $? -ne 0 ]; then
  echo "-- Running a new container";
  $CMD_DOCKER_RUN;
fi;