#!/bin/bash

# Check maven version
mvn -v

# Check java version
java -version

# Check internate
curl baidu.com

export TZ="Asia/Shanghai"
export cur_date="`date  +"%Y%m%d%H%M"`"

#Set project version
if [ $CI_COMMIT_TAG ]; 
    then  export VERSION=$CI_COMMIT_TAG;  
    else export VERSION="${GITLAB_USER_LOGIN}_${cur_date}"; 
fi

# Set docker image tag. IMAGE_GROUP: group of this image
export IMAGE_TAG=$DOCKER_REGISTRY/$IMAGE_GROUP/$APP_NAME

# Set project version
mvn versions:set -DnewVersion=$VERSION

#Build project
mvn package -Pprod,war -DskipTests -Dimage=$IMAGE_TAG  \
    -Djib.to.auth.username=$DOCKER_REGISTRY_USERNAME \
    -Djib.to.auth.password=$DOCKER_REGISTRY_PASSWORD \
    -Djib.useOnlyProjectCache=true jib:build