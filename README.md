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
※aws-cliのインストールを事前に行なってください。

1. AWSコンソール上で `ACCESS_KEY`,`SECRET_ACCESS_KEY` を発行する
2. リポジトリのルートディレクトリで下記コマンド

    ```shell
    $ make init
    $ aws configure
    ```

    aws configuration実行時の入力は下記を参考

    ```
    AWS_ACCESS_KEY_ID: コンソール上から作成し発行された値
    AWS_SECRET_ACCESS_KEY: コンソール上から作成し発行された値
    REGION: ap-northeast-1
    ```

<br>
<br>

## 使用CLIツール

### [aws-cli](https://github.com/aws/aws-cli)
各種リソースの操作のために使用  

<br>

### [rain](https://github.com/aws-cloudformation/rain)
aws-cliの cloudformationコマンドと異なり  

- スタック作成・更新の進捗率を表示可能
- 更新の場合、新旧の差分を出力可能
- 空のテンプレートをリソースタイプごとに生成可能

<br>

### [cfn-lint](https://github.com/aws-cloudformation/cfn-lint)
`cfn-lint validate` でテンプレートの構文チェックが可能  

<br>


### [cfn-diagram](https://github.com/mhlabs/cfn-diagram)
ネストスタックも含めて、使用サービスの依存関係をHTML, drawioに出力して可視化可能

<br>


## AWSリソース全体図
### システム全体 (resources)

### パイプライン
#### フロントエンド (front)

#### バックエンド (back)

