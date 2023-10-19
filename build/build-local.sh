#!/bin/zsh

LOCAL_REPO=~/11_code/obsidian-exporter-helper
EXPORT_BINARY="$LOCAL_REPO/mnt/obsidian-export/target/debug/obsidian-export"
# TODO change to vault
VAULT_PATH="$LOCAL_REPO/mnt/sample-vault"
HUGO_ROOT="$LOCAL_REPO/hugoroot"

echo "🍿 Preparing hugo content..."
mkdir -p $HUGO_ROOT/content/tmp
cp -R $HUGO_ROOT/content/posts/_index.md $HUGO_ROOT/content/tmp
rm -rf $HUGO_ROOT/content/posts
mkdir -p $HUGO_ROOT/content/posts
mv $HUGO_ROOT/content/tmp/* $HUGO_ROOT/content/posts/
rm -rf $HUGO_ROOT/content/tmp
# TODO - handle images in assets/images and or static/images

echo "🍿 Exporting obsidian vault..."
# Using dev version of obsidian-export
$EXPORT_BINARY "$VAULT_PATH" --start-at "$VAULT_PATH" --frontmatter=always --link=none $HUGO_ROOT/content/posts/
# added:   --link LINK-STRATEGY       Link strategy (one of: encoded, none) (default: encoded)

# TODO - move $HUGO_ROOT/content/posts/attachments to $HUGO_ROOT/assets/images
# TODO - add in script for responsive images