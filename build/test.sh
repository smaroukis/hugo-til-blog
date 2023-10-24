#!/bin/zsh

LOCAL_REPO=~/11_code/obsidian-exporter-helper
EXPORT_BINARY="$LOCAL_REPO/mnt/obsidian-export/target/debug/obsidian-export"
VAULT_PATH="$LOCAL_REPO/mnt/blog-source"
HUGO_ROOT="$LOCAL_REPO/hugoroot"


if [ "$GITHUB_ACTIONS" ]; then
  echo "Building site for Github Actions..."
else
  echo "Not a Github Action, serving site locally..."
fi