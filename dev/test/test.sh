#!/bin/zsh

VAULT_PATH=../sample-vault
HUGO_ROOT=~/11_code/37b-til/site

echo "🍿 Preparing hugo root..."
mkdir -p $HUGO_ROOT/layouts/_default/_markup/
cp -R ../../hugofiles/* $HUGO_ROOT/layouts/_default/_markup

# echo "🍿 Preparing hugo content..."
# rm -rf $HUGO_ROOT/content/posts
# mkdir -p $HUGO_ROOT/content/posts

echo "🍿 Exporting obsidian vault..."
# obsidian-export "$VAULT_PATH" --start-at "$VAULT_PATH" --frontmatter=always $HUGO_ROOT/content/posts/
# Using dev version of obsidian-export
../obsidian-export/target/debug/obsidian-export "$VAULT_PATH" --start-at "$VAULT_PATH" --frontmatter=always $HUGO_ROOT/content/posts/


# echo "🍿 Encoding filenames..."
# python encode-filenames-python/encode.py $HUGO_ROOT/content/posts/attachments