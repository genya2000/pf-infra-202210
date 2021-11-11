#!/bin/bash

docker build $PWD/dockerfiles/cfn-guard -f $PWD/dockerfiles/cfn-guard -t cfn-guard
docker build $PWD/dockerfiles/cfn-lint -f $PWD/dockerfiles/cfn-lint -t cfn-lint
docker build $PWD/dockerfiles/cfn-diagram -f $PWD/dockerfiles/cfn-diagram -t cfn-diagram
