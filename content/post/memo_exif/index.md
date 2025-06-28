---
title: 画像が横向きになるのはEXIFのせい
description: カメラ画像が横向きになる原因を追いかけた
slug: memo_exif
date: 2025-06-28T18:08:26+09:00
categories:
    - 備忘録
    - 技術
tags:
    - Exif
    - Hugo
    - Markdown
draft: false
---

[旅行の記事]({{% relref "post/ryokou202506/index.md" %}})を書いてるときに、画像を添付すると横転してしまった。

```
![飛翔跡地](hishou_exif.jpg)
```

![飛翔跡地](hishou_exif.jpg)



どうやらExifという形式のメタデータを画像に埋め込んでるらしい。
[Exchangeable image file format（Exif） - Wikipedia](https://ja.wikipedia.org/wiki/Exchangeable_image_file_format)

[exiftool](https://exiftool.org/)というツールに画像をぶち込むと以下のような情報が見られる。
画像としては横転してる状態が正なのを、スマホ上のビューワーなどではExifの `Orientation` というタグを読み込んでよしなに表示してくれている。
`Orientation                     : Rotate 90 CW` が時計回りに90°回転するってことらしい。(ClockWise？)

{{< figure
    src="exif_cli.jpg"
    width="90%" 
>}}

Stackの `![Image 1](1.jpg)` っていうGallery Syntaxはこの `Orientation` を無視するのかしらね。  
というわけで、この情報を書き換える方法を探すとチャッピーがImageMagickというパッケージを教えてくれた。

```bash
convert <対象ファイル名> -auto-orient <操作後のファイル名>
```

この `-auto-orient` というオプションが、 `Orientation` タグの向きに画像を回転させつつ、`Orientation` タグの情報を `Horizontal (normal)` にしてくれる。

先の記事ではスマホで撮った画像を大量に使用しているので、一つ一つ画像に `convert` を適応していくのはちと面倒じゃ。というわけでディレクトリ内の画像を一括処理できるスクリプトを用意する。

```bash
#!/bin/bash

# 対象ディレクトリ（必要に応じて変更）
TARGET_DIR="$1"

# JPG/JPEG/PNG を対象に一括処理
for img in "$TARGET_DIR"/*.{jpg,jpeg,png}; do
  [ -e "$img" ] || continue  # ファイルが存在しない場合スキップ
  sudo convert "$img" -auto-orient "$img"
done
```

ちゃっぴーくんは便利だなぁ。ローカルのHugo用ディレクトリに上記のスクリプトを配置してコマンドを実行すれば一括で処理してくれる。
これで、

1. 記事を書く(画像を入れる部分はプレースホルダにしておく)
2. 使いたい画像を記事ディレクトリにぶちこむ
3. `./convert.sh ./content/post/<対象ディレクトリ>` を実行
4. 画像の表示サイズやキャプションを調整する

という流れを作れた。こういうのは習慣化するのが大事なんだよね。そのためには極力抵抗となる部分を減らして、取り組むための活性化エネルギーを小さくするの。アウトプットは気軽にサクッと、インプットするたびにやっていきたいね。

---

今記事書いてて気づいたけど、この記法だとExifをいじらなくても横転しない。

```text
{{</* figure
    src="hishou_exif.jpg"
    caption="飛翔跡地"
    width="50%" 
*/>}}
```

{{< figure
    src="hishou_exif.jpg"
    caption="飛翔跡地"
    width="50%" 
>}}

StackのGallery表示で複数画像を横に並べる機能が使いたくてこんなことやってるけど、figureのshortcodeでも指定の仕方によっては実現できるのかな。気が向いたら今度調べてみるか。

あと関連するコンテンツにGitHub_memoが表示されてるのもなんでだ？備忘録カテゴリーつけてるからかな？