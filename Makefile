MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

help:
	@echo '---------- 環境構築に関するコマンド -----------' @echo 'init           -- プロジェクト初期のセットアップを行います ※基本的にクローンしてきて1回目のみ実行' @echo ''
	@echo '---------- CFnに関するコマンド ----------'
	@echo 'lint           -- 引数に渡したテンプレートファイルの構文チェックを行います 例) make lint TMPL=main.yml'
	@echo 'guard          -- 引数に渡したテンプレートファイルのセキュリティチェック・事前設定したルールに沿っているかチェックを行います 例) make guard TMPL=main.yml'
	@echo 'rain           -- 引数に渡したテンプレートファイルを元にスタックをデプロイする 例) make rain TMPL=main.yml'
	@echo 'rain-rm        -- 引数に渡したスタック名と一致するスタックを削除する 例) make rain-rm TMPL=main.yml '
	@echo ''
	@echo '---------- ECSに関するコマンド ----------'
	@echo 'executable     -- 引数に渡した情報を元にFargateのサービス内のコンテナに exec(コマンド実行)を可能にする'
	@echo 'exec           -- 引数に渡した情報を元にコンテナ内で /bin/sh を実行する'
	@echo 'describe       -- 引数に渡した情報を元にFargateのサービスの情報をJSONで取得する'
	@echo '---------- Gitに関するコマンド ----------'
	@echo ''
	@echo 'git-setup      -- Gitのローカル環境のuser.nameとuser.emailを設定します'
	@echo 'docker-setup   -- 各種CLIコマンド実行用のDockerイメージをビルドします'

init:
	@make git-setup
	@make docker-setup
lint:
	docker run -it --rm -v ${MAKEFILE_DIR}:/var/www/workdir -w /var/www/workdir cfn-lint:latest cfn-lint ${TMPL}
guard:
	docker run -it --rm -v ${MAKEFILE_DIR}:/var/www/workdir -w /var/www/workdir cfn-guard:latest cfn-guard ${TMPL}
rain:
	docker run -it --rm -v ${HOME}/.aws:/root/.aws -v ${MAKEFILE_DIR}:/var/www/workdir -w /var/www/workdir rain:latest deploy ${TMPL} ${STACK}
rain-rm:
	docker run -it --rm -v ${HOME}/.aws:/root/.aws -v ${MAKEFILE_DIR}:/var/www/workdir -w /var/www/workdir rain:latest rm ${STACK}
rain-ls:
	docker run -it --rm -v ${HOME}/.aws:/root/.aws -w /var/www/workdir rain:latest list
executable:
	docker run -it --rm -v ${HOME}/.aws:/root/.aws aws-ecs-exec:latest ecs update-service --cluster ${CLUSTER} --service ${SERVICE} --enable-execute-command
exec:
	docker run -it --rm -v ${HOME}/.aws:/root/.aws aws-ecs-exec:latest ecs execute-command --interactive --cluster ${CLUSTER} --task ${TASK} --container ${CONTAINER}  --command /bin/sh
describe:
	docker run -it --rm -v ${HOME}/.aws:/root/.aws aws-ecs-exec:latest ecs describe-services --cluster ${CLUSTER} --services ${SERVICE} --query services\[0\].enableExecuteCommand
git-setup:
	$(shell ./.make/setup_git.sh)
docker-setup:
	$(shell ./.make/setup_docker.sh)
