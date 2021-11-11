#!/bin/bash

env=$1

if [ $env = '' ]; then
    echo '環境名を引数に指定してください。'
    exit 1
fi

if [ $env != 'stg' ] && [ $env != 'prod' ]; then
    echo '環境名はstg または prodを指定してください。'
    exit 1
fi

envfile=$PWD/env/$env.json
envs=$(jq -r "to_entries|map(\"\(.key)=\(.value|tostring),\")|.[]" $envfile)
params=$(echo $envs | sed 's/ //g')
maintemplate=$PWD/main.yml

rain deploy $maintemplate \
    --params $params
