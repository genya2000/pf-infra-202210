#!/bin/sh

read -p "Gitのローカル設定を行います。名字と名前をアンダースコア区切りで入力して下さい(ex. Gizumo_Taro): " name
git config user.name $name

read -p "gizumo-inc.jpまたはgiztech-pro.comのemailアドレスを入力して下さい: " email
git config user.email $email

