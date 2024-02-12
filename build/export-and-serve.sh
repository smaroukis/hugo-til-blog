#!/bin/bash

#This Bash script automates the preparation of content for a blog using Hugo, 
#including cloning a source repository, organizing content, exporting an Obsidian vault, 
#and optionally serving the blog locally or within a GitHub Actions environment.

# 1 - Removes and Re-Clones the TIL blog source markdown files to get the newest ones 
# 2 - Clears the old content in the hugo site under "(site root)/content/posts"
# 3 - Uses the obsidian-export rust script to export the markdown files formatted for hugo into /content/posts

# running from "(proj root)/build" dir 
EXPORT_BINARY="./mnt/obsidian-export-binary/obsidian-export"
VAULT_PATH="./mnt/blog-source"
HUGO_ROOT="./hugoroot"

function copy_vault {
    rm -rf $VAULT_PATH    
    git clone https://github.com/smaroukis/til $VAULT_PATH
    # remove README.md from source repo
    rm $VAULT_PATH/README.md
}

function prepare_hugo {
    # save _index.md's
    mkdir -p $HUGO_ROOT/content/tmp
    cp -R $HUGO_ROOT/content/posts/_index.md $HUGO_ROOT/content/tmp
    # clear content
    rm -rf $HUGO_ROOT/content/posts
    mkdir -p $HUGO_ROOT/content/posts
    # add back in _index.md's
    mv $HUGO_ROOT/content/tmp/* $HUGO_ROOT/content/posts/
    rm -rf $HUGO_ROOT/content/tmp
}

echo "🍿 Preparing blog source / vault..."
copy_vault

echo "🍿 Preparing hugo content..."
prepare_hugo

echo "🍿 Exporting obsidian vault with obsidian-export..."
# Export obsidian vault to $HUGO_ROOT/content/posts (using version with LINK-STRATEGY)
$EXPORT_BINARY "$VAULT_PATH" --start-at "$VAULT_PATH" --frontmatter=always --link=none $HUGO_ROOT/content/posts/
# added:   --link LINK-STRATEGY       Link strategy (one of: encoded, none) (default: encoded)

if [ "$GITHUB_ACTIONS" ]; then
  # TODO may need to build into different dir, see script/publish setup
  echo "CD'ing to $HUGO_ROOT"
  cd $HUGO_ROOT
  echo "Defering to Github Actions for building site within runner..."
else
  echo "🏗 Not a Github Action, Serving blog locally..."
  pushd $HUGO_ROOT > /dev/null
  hugo server -D
  popd > /dev/null
fi

# TODO - move $HUGO_ROOT/content/posts/attachments to $HUGO_ROOT/assets/images
# TODO - add in script for responsive images