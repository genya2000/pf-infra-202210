#!/bin/bash

mountdir=/var/www/workdir
workingdir=$mountdir/templates
dockerimage=cfn-diagram:latest
dirname=$(echo $1 | tr -d .yml)

docker run \
    -it \
    --rm \
    -v $PWD:$mountdir/ \
    -w $workingdir \
    $dockerimage cfn-dia html -t $workingdir/$1 -o $mountdir/outputs/$dirname

open $PWD/outputs/index.html
