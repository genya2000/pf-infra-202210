#!/bin/bash

workingdir=/var/www
dockerimage=cfn-diagram:latest

docker run \
    -it \
    --rm \
    -v $PWD:$workingdir \
    -w $workingdir \
    $dockerimage cfn-dia html -t diagram.yml -o outputs

open $PWD/outputs/index.html
