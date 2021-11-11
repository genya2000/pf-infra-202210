MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

help:
	@echo '---------- 環境構築に関するコマンド -----------'
	@echo 'init           -- プロジェクト初期のセットアップを行います※基本的にクローンしてきて1回目のみ実行'
	@echo ''
	@echo '---------- CFnに関するコマンド ----------'
	@echo 'cfn-lint       -- ネットワークを作成します※初回構築時に作成されるのでこのコマンドは基本的に手作業で実行しない'
	@echo 'cfn-guard      -- イメージをビルドします'
	@echo '---------- Gitに関するコマンド ----------'
	@echo 'git-setup      -- Gitのローカル環境のuser.nameとuser.emailを設定します'

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
