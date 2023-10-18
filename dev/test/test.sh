#!/bin/zsh

VAULT_PATH=/Users/s/11_code/obsidian-exporter-helper/dev/sample-vault
HUGO_ROOT=~/11_code/37b-til/site

echo "🍿 Preparing hugo root..."
mkdir -p $HUGO_ROOT/layouts/_default/_markup/
cp -R ../../hugofiles/* $HUGO_ROOT/layouts/_default/_markup

# echo "🍿 Preparing hugo content..."
mkdir -p $HUGO_ROOT/content/tmp
cp -R $HUGO_ROOT/content/posts/_index.md $HUGO_ROOT/content/tmp
rm -rf $HUGO_ROOT/content/posts
mkdir -p $HUGO_ROOT/content/posts
mv $HUGO_ROOT/content/tmp/* $HUGO_ROOT/content/posts/
rm -rf $HUGO_ROOT/content/tmp
# TODO - handle images in assets/images and or static/images

echo "🍿 Exporting obsidian vault..."
# obsidian-export "$VAULT_PATH" --start-at "$VAULT_PATH" --frontmatter=always $HUGO_ROOT/content/posts/
# Using dev version of obsidian-export
../obsidian-export/target/debug/obsidian-export "$VAULT_PATH" --start-at "$VAULT_PATH" --frontmatter=always --link=none $HUGO_ROOT/content/posts/
# added:   --link LINK-STRATEGY       Link strategy (one of: encoded, none) (default: encoded)

# HERE - still encoding

# TODO - move $HUGO_ROOT/content/posts/attachments to $HUGO_ROOT/assets/images