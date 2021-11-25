#!/bin/bash

docker build $PWD/dockerfiles/cfn-lint -f $PWD/dockerfiles/cfn-lint -t cfn-lint
docker build $PWD/dockerfiles/cfn-diagram -f $PWD/dockerfiles/cfn-diagram -t cfn-diagram
docker build $PWD/dockerfiles/rain -f $PWD/dockerfiles/rain -t rain
