---
title: GitHub_memo
description: gitとGitHubの使い方をまとめた備忘録
slug: GitHub_memo
date: 2025-04-16T21:50:18+09:00
categories:
    - Technology
    - 備忘録
tags:
    - GitHub
draft: true
---
## Git/Githubの備忘録

### Local to Remote

```
GitHub上でリポジトリをあらかじめ作成しておくこと

cd <対象ディレクトリ>
git init # ローカルリポジトリの作成
git status # リポジトリの状態を確認
git add -A # ディレクトリ配下全てをステージングエリアに追加(コミットの予約)
git status
git commit -m "コミットの内容を入力"
git status

git branch -m <新しいブランチ名> # ブランチ名を変更する

# リモートブランチとの紐づけ
git remote add <remote_repository_name> <remote_repository_URL>
ex: git remote add origin https://<user_name>:<access_token>@github.com/XX/XX.git

# リモートブランチにアップロード(-u で上流ブランチを設定->以降のpush,pullでブランチ名を指定しなくてよくなる)
git push -u <repository_name> <local_branch_name>:<remote_branch_name>
ex: git push -u origin main
```

### Remote to Local

```
# デフォルトブランチをローカルにクローンする
git clone https://<user_name>:<access_token>@github.com/XX/XX.git
```

### ブランチ運用の流れ

```
# 現在のブランチを確認
git branch -a 

# 現在のブランチがメインでなければ、mainに切り替えておく
git checkout <branch_name> 

# ローカルのブランチを最新にする
# git push で -u を指定していれば　git pull のみで良い
git pull <remote_repository_name> <branch_name>

# 機能変更用のブランチを切る
git checkout -b feature/<変更する内容に応じた命名>

# ローカルブランチでの変更内容をリモートブランチに適用
git add -A
git commit -m "コメント"
git push origin feature/change

# commit はファイルの変更をした時などにこまめにしておく
# push は切りのいいタイミングでする
```

### Mainへのマージ

1. リモートリポジトリの mainブランチから、ローカルリポジトリの mainブランチに `pull`
2. ローカル上でブランチを切ってマージ、コンフリクト解消
3. コンフリクトがない状態のブランチをリモートリポジトリに `push`
4. GitHub上で pull request からマージ

```
git merge <マージしたいブランチ> <マージ先のメインブランチ>
ex: git merge feature/user_login main
	
git log # コミットIDを調べる
git reset --hard <commid ID> # 指定したコミットの状態に戻す リセットした記録は残らない
# デフォルトでは --mixed が選択されてるらしい。要調査

git revert <commit ID> # 特定のコミットを打ち消すコミットを作成する → 打ち消したコミットより後のコミットには影響しない
```

### ブランチの削除

```
git checkout main # マージされたブランチを削除するために、一度別のブランチに切り替える
git branch -d <branch_name>
	git branch -d feature/change
		# ブランチの削除
git fetch -p # リモートリポジトリのブランチの状態を取得
```

```
# git commit の履歴を見る
git log
```

### 空のディレクトリもpushしたい

gitの仕様として、ファイルのみを追跡管理するらしい

ディレクトリ配下に .gitkeep などの名前で空ファイルを作成する

### リモートリポジトリとの接続を切りたい

```
# リモートリポジトリアドレスを表示
git remote -v

# 紐づけを解除
git remote remove [remote_repository_name]
```

やる気が出たらmarkdownの書き方勉強してもっと見やすくする