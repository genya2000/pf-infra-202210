#!/bin/bash

workingdir=/var/www/cw-imedia-infra
dockerimage=node:latest

docker run \
    -it \
    --rm \
    -v $PWD:$workingdir/ \
    -w $workingdir/$1 \
    node_test:latest cfn-dia html -t $2 -o $workingdir/diagrams/outputs

open diagrams/outputs/index.html
