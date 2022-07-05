#!/bin/bash

docker build $PWD/dockerfiles/aws-cli -f $PWD/dockerfiles/aws-cli -t aws-cli --build-arg ARCH=$(uname -m)
docker build $PWD/dockerfiles/cfn-lint -f $PWD/dockerfiles/cfn-lint -t cfn-lint
docker build $PWD/dockerfiles/cfn-diagram -f $PWD/dockerfiles/cfn-diagram -t cfn-diagram
docker build $PWD/dockerfiles/rain -f $PWD/dockerfiles/rain -t rain

