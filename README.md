# cw-imedia-infra
[iMedia] インフラ周りのコード管理用

## バージョン情報

| docker  | aws-cli | 
|:--------|:--------|
| 20.10.8 | 2.3.4   |

<br>

## ディレクトリ構成

```shell
.
├── Makefile      # makeコマンド定義ファイル
├── dockerfiles   # Dockerfile配置ディレクトリ
├── pipelines     # CI/CDパイプライン用ディレクトリ
│     ├── back   # バックエンド(コンテナ)CI/CDテンプレート配置ディレクトリ
│     ├── front  # フロント(ソースビルド)CI/CDテンプレート配置ディレクトリ
└── resources     # CI/CDを除くシステム全体のテンプレート配置先ディレクトリ
```

<br>


## 環境構築

※aws-cliのインストールは自身で行なってください。

```shell
$ make init
$ aws configure
```

aws configurationについては下記を参考

```
AWS_ACCESS_KEY_ID: コンソール上から作成し発行された値
AWS_SECRET_ACCESS_KEY: コンソール上から作成し発行された値
REGION: ap-northeast-1
```

<br>

## Cfnコマンド

### aws-cli

### rain

### cfn-lint

### cfn-diagram

<br>


## システム全体 (resources)

## パイプライン
### フロントエンド (front)



### バックエンド (back)

