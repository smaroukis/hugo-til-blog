#!/bin/zsh

# running from "(proj root)/build" dir 
EXPORT_BINARY="../mnt/obsidian-export/target/debug/obsidian-export"
VAULT_PATH="../mnt/blog-source"
HUGO_ROOT="../hugoroot"

function copy_vault {
    rm -rf $VAULT_PATH    
    git clone https://github.com/smaroukis/til $VAULT_PATH
    # remove README.md from source repo
    rm $VAULT_PATH/README.md
}

echo "🍿 Preparing blog source / vault..."
copy_vault

echo "🍿 Preparing hugo content..."
# save _index.md's
mkdir -p $HUGO_ROOT/content/tmp
cp -R $HUGO_ROOT/content/posts/_index.md $HUGO_ROOT/content/tmp
# clear content
rm -rf $HUGO_ROOT/content/posts
mkdir -p $HUGO_ROOT/content/posts
# add back in _index.md's
mv $HUGO_ROOT/content/tmp/* $HUGO_ROOT/content/posts/
rm -rf $HUGO_ROOT/content/tmp

echo "🍿 Exporting obsidian vault..."
# Using dev version of obsidian-export
$EXPORT_BINARY "$VAULT_PATH" --start-at "$VAULT_PATH" --frontmatter=always --link=none $HUGO_ROOT/content/posts/
# added:   --link LINK-STRATEGY       Link strategy (one of: encoded, none) (default: encoded)

# TODO refactor to seperate script for locally servinf
# have switch statement for local or githuhbactions
if [ "$GITHUB_ACTIONS" = "true" ]; then
  # This is a GitHub Actions workflow
  echo "🏗 Serving blog locally..."
  pushd $HUGO_ROOT > /dev/null
  hugo server -D
  popd > /dev/null
else
  # This is not a GitHub Actions workflow, so build the site
  echo "Building the blog..."
  pushd $HUGO_ROOT > /dev/null
  hugo -D
  popd > /dev/null
fi


# TODO - move $HUGO_ROOT/content/posts/attachments to $HUGO_ROOT/assets/images
# TODO - add in script for responsive images