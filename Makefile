MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

help:
	@echo '---------- 環境構築に関するコマンド -----------'
	@echo 'init           -- プロジェクト初期のセットアップを行います ※基本的にクローンしてきて1回目のみ実行'
	@echo ''
	@echo '---------- CFnに関するコマンド ----------'
	@echo 'lint           -- 引数に渡したテンプレートファイルの構文チェックを行います 例) make lint TMPL=resources.yml'
	@echo 'rain           -- 引数に渡したテンプレートファイルを元にスタックをデプロイする 例) make rain TMPL=resources.yml STACK=stg-resources'
	@echo 'rain-rm        -- 引数に渡したスタック名と一致するスタックを削除する 例) make rain-rm TMPL=resources.yml '
	@echo 'rain-ls        -- 作成済みスタックを一覧表示する 例) make rain-ls'
	@echo ''
	@echo '---------- ECSに関するコマンド ----------'
	@echo 'executable     -- 引数に渡した情報を元にFargateのサービス内のコンテナに exec(コマンド実行)を可能にする 例) make executable CLUSTER=クラスター名 SERVICE=サービス名'
	@echo 'exec           -- 引数に渡した情報を元にコンテナ内で /bin/sh を実行する 例) make exec CLUSTER=クラスター名 TASK=タスクID CONTAINER=コンテナ名'
	@echo 'exec-migrate   -- 引数に渡した情報を元にコンテナ内で マイグレーション・シード を実行する 例) make exec-migrate CLUSTER=クラスター名 TASK=タスクID CONTAINER=コンテナ名'
	@echo 'get-tasks      -- 引数に渡した情報を元にクラスター内のタスク情報をJSONで取得する 例) make get-tasks CLUSTER=クラスター名'
	@echo 'restart-task   -- 引数に渡した情報を元にタスクを停止する。DisireCountが1になっている場合は、停止後自動でコンテナが一つ立ち上がるので実質タスク再構築 例) make restart-task CLUSTER=クラスター名 TASK=タスクID'
	@echo ''
	@echo '---------- Gitに関するコマンド ----------'
	@echo 'git-setup      -- Gitのローカル環境のuser.nameとuser.emailを設定します'
	@echo ''
	@echo '---------- Dockerに関するコマンド ----------'
	@echo 'docker-setup   -- 各種CLIコマンド実行用のDockerイメージをビルドします'
	@echo ''

init:
	@make git-setup
	@make docker-setup
lint:
	docker run -it --rm -v ${MAKEFILE_DIR}:/var/www/workdir -w /var/www/workdir cfn-lint:latest cfn-lint ${TMPL}
rain:
	docker run -it --rm -v ${HOME}/.aws:/root/.aws -v ${MAKEFILE_DIR}:/var/www/workdir -w /var/www/workdir rain:latest deploy ${TMPL} ${STACK}
rain-rm:
	docker run -it --rm -v ${HOME}/.aws:/root/.aws -v ${MAKEFILE_DIR}:/var/www/workdir -w /var/www/workdir rain:latest rm ${STACK}
rain-ls:
	docker run -it --rm -v ${HOME}/.aws:/root/.aws -w /var/www/workdir rain:latest list
executable:
	docker run -it --rm -v ${HOME}/.aws:/root/.aws aws-cli:latest ecs update-service --cluster ${CLUSTER} --service ${SERVICE} --enable-execute-command
exec:
	docker run -it --rm -v ${HOME}/.aws:/root/.aws aws-cli:latest ecs execute-command --interactive --cluster ${CLUSTER} --task ${TASK} --container ${CONTAINER}  --command /bin/sh
exec-migrate:
	docker run -it --rm -v ${HOME}/.aws:/root/.aws aws-cli:latest ecs execute-command --interactive --cluster ${CLUSTER} --task ${TASK} --container ${CONTAINER}  --command 'php artisan migrate --seed'
describe:
	docker run -it --rm -v ${HOME}/.aws:/root/.aws aws-cli:latest ecs describe-services --cluster ${CLUSTER} --services ${SERVICE} --query services\[0\].enableExecuteCommand
get-tasks:
	docker run -it --rm -v ${HOME}/.aws:/root/.aws aws-cli:latest ecs list-tasks --cluster ${CLUSTER}
restart-task:
	docker run -it --rm -v ${HOME}/.aws:/root/.aws aws-cli:latest ecs stop-task --cluster=${CLUSTER} --task ${TASK}
git-setup:
	$(shell ./.make/setup_git.sh)
docker-setup:
	$(shell ./.make/setup_docker.sh)
