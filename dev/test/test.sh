#!/bin/zsh

HELPER_ROOT=~/11_code/obsidian-exporter-helper
EXPORT_BINARY="$HELPER_ROOT/dev/obsidian-export/target/debug/obsidian-export"
VAULT_PATH="$HELPER_ROOT/dev/sample-vault"
HUGO_ROOT=~/11_code/37b-til/site

echo "🍿 Preparing hugo root..."
mkdir -p $HUGO_ROOT/layouts/_default/_markup/
cp -R $HELPER_ROOT/hugofiles/* $HUGO_ROOT/layouts/_default/_markup

# echo "🍿 Preparing hugo content..."
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