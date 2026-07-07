#!/bin/bash
# Obsidian Vault → Hugo content/posts 同步脚本
# 用法: ./scripts/sync-from-obsidian.sh

set -euo pipefail

OBSIDIAN_BLOG="/mnt/c/Users/1/Documents/Obsidian Vault/blog"
HUGO_CONTENT="/root/workplace/claude_learn/1012Penn.github.io/content/posts"

if [ ! -d "$OBSIDIAN_BLOG" ]; then
  echo "错误：Obsidian blog 目录不存在: $OBSIDIAN_BLOG"
  exit 1
fi

mkdir -p "$HUGO_CONTENT"

added=0
updated=0
skipped=0

for file in "$OBSIDIAN_BLOG"/*.md; do
  [ -f "$file" ] || continue

  filename=$(basename "$file" .md)
  slug=$(echo "$filename" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')

  target_dir="$HUGO_CONTENT/$slug"
  target_file="$target_dir/index.md"

  if [ -f "$target_file" ]; then
    if [ "$file" -nt "$target_file" ]; then
      cp "$file" "$target_file"
      echo "[已更新] $slug"
      updated=$((updated + 1))
    else
      echo "[跳过] $slug（未变更）"
      skipped=$((skipped + 1))
    fi
  else
    mkdir -p "$target_dir"
    cp "$file" "$target_file"
    echo "[新增] $slug"
    added=$((added + 1))
  fi
done

echo ""
echo "同步完成：新增 $added 篇，更新 $updated 篇，跳过 $skipped 篇"
