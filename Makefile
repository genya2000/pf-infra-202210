MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

help:
	@echo '---------- 環境構築に関するコマンド -----------'
	@echo 'init           -- プロジェクト初期のセットアップを行います ※基本的にクローンしてきて1回目のみ実行'
	@echo ''
	@echo '---------- CFnに関するコマンド ----------'
	@echo 'lint           -- 引数に渡したテンプレートファイルの構文チェックを行います 例) make lint TMPL=main.yml'
	@echo 'guard          -- 引数に渡したテンプレートファイルのセキュリティチェック・事前設定したルールに沿っているかチェックを行います 例) make guard TMPL=main.yml'
	@echo ''
	@echo '---------- Gitに関するコマンド ----------'
	@echo 'git-setup      -- Gitのローカル環境のuser.nameとuser.emailを設定します'
	@echo 'docker-setup   -- 各種CLIコマンド実行用のDockerイメージをビルドします'

init:
	@make git-setup
	@make docker-setup
lint:
	docker run -it --rm -v ${MAKEFILE_DIR}:/var/www/workdir -w /var/www/workdir cfn-lint:latest cfn-lint ${TMPL}
guard:
	docker run -it --rm -v ${MAKEFILE_DIR}:/var/www/workdir -w /var/www/workdir cfn-guard:latest cfn-guard ${TMPL}
git-setup:
	$(shell ./.make/setup_git.sh)
docker-setup:
	$(shell ./.make/setup_docker.sh)
