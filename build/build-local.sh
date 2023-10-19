#!/bin/zsh

LOCAL_REPO=~/11_code/obsidian-exporter-helper
EXPORT_BINARY="$LOCAL_REPO/mnt/obsidian-export/target/debug/obsidian-export"
VAULT_PATH="$LOCAL_REPO/mnt/blog-source"
HUGO_ROOT="$LOCAL_REPO/hugoroot"

function copy_vault {
    ## Setup Once
    # git submodule add https://git@github.com/smaroukis/til "$VAULT_PATH"
    
    # Dev
    # git submodule deinit -f "$VAULT_PATH"
    # rm -rf "$VAULT_PATH"
    # git submodule add https://git@github.com/smaroukis/til "$VAULT_PATH"

    rm -rf $VAULT_PATH
    git submodule update 
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

echo "🏗 Building blog..."
pushd $HUGO_ROOT > /dev/null
hugo -D > /dev/null
popd > /dev/null
echo "✅ Blog built!!! Have fun!"

# TODO - move $HUGO_ROOT/content/posts/attachments to $HUGO_ROOT/assets/images
# TODO - add in script for responsive images