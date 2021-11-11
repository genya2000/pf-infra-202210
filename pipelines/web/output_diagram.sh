#!/bin/bash

mountdir=/var/www/workdir
workingdir=$mountdir/templates
dockerimage=cfn-diagram:latest

docker run \
    -it \
    --rm \
    -v $PWD:$mountdir/ \
    -w $workingdir \
    $dockerimage cfn-dia html -t $workingdir/diagram.yml -o $mountdir/outputs

open $PWD/outputs/index.html
