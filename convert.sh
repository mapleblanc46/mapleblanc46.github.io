#!/bin/bash

# 対象ディレクトリ（必要に応じて変更）
TARGET_DIR="$1"

# JPG/JPEG/PNG を対象に一括処理
for img in "$TARGET_DIR"/*.{jpg,jpeg,png}; do
  [ -e "$img" ] || continue  # ファイルが存在しない場合スキップ
  sudo convert "$img" -auto-orient "$img"
done
