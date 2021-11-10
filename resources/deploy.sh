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

# declare -a templates=(
#   $PWD/templates/main.yml
#   $PWD/templates/network.yml
#   $PWD/templates/securities/security_group.yml
#   $PWD/templates/applications/cloudfront.yml
#   $PWD/templates/applications/db.yml
#   $PWD/templates/applications/ecs.yml
# )
# 
# 
# i=0
# result=0
# 
# for i in ${array[@]}; do
#   if [$(cfn-lint validate ${array[@]}) != 0]; then
#     result=1
#   fi
# done
# 
# echo $result
# 
# if [ $result -eq 1 ]; then
#   exit 1
# fi



