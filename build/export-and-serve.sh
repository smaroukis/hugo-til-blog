#!/bin/bash

# 1 - Removes and Re-Clones the TIL blog source markdown files to get the newest ones 
# 2 - Clears the old content in the hugo site under "(site root)/content/posts"
# 3 - Uses the obsidian-export rust script to export the markdown files formatted for hugo into /content/posts

# running from "(proj root)/build" dir 
VAULT_PATH="./mnt/blog-source"
HUGO_ROOT="./hugoroot"

# Get the architecture and OS of the host system
HOST_ARCH=$(uname -m) # x86_64 or arm64
HOST_OS=$(uname -s) # Linux or Darwin
 
# Set the variable based on the architecture
if [[ "$HOST_ARCH" == "arm64" ]]; then
    EXPORT_BINARY="./mnt/obsidian-export-binary/obsidian-export-aarch64-apple-darwin"
elif [[ "$HOST_ARCH" == "x86_64" ]]; then
    EXPORT_BINARY="./mnt/obsidian-export-binary/obsidian-export-x86_64-linux"
else
    echo "Unknown architecture and OS: $HOST_ARCH $HOST_OS"
    exit 1
fi

function clone_vault {
    echo "🚀 Cloning TIL blog source markdown files..."
    git clone https://github.com/smaroukis/til "$VAULT_PATH"
}

# here - issue with not updating the submodule, but updating hte parent
function update_vault {
    # Update the submodule recursively
    git submodule update --init --remote mnt/blog-source
    # Pull the latest changes in the Vault repository
    cd "$VAULT_PATH" || exit 1
    # Change directory to the Vault repository
    # Remove README.md from the source repo
    rm README.md
    # Change back to the previous directory
    cd - || exit 1
}

function prepare_hugo {
    # save _index.md's
    mkdir -p "$HUGO_ROOT/content/tmp"
    cp -R "$HUGO_ROOT/content/posts/_index.md" "$HUGO_ROOT/content/tmp"
    # clear content
    rm -rf "$HUGO_ROOT/content/posts"
    mkdir -p "$HUGO_ROOT/content/posts"
    # add back in _index.md's
    mv "$HUGO_ROOT/content/tmp/*" "$HUGO_ROOT/content/posts/"
    rm -rf "$HUGO_ROOT/content/tmp"
}

# Check if VAULT_PATH exists
if [ ! -d "$VAULT_PATH" ]; then
    clone_vault
else
    echo "🌟 Vault already exists at $VAULT_PATH"
fi

echo "🍿 Preparing blog source / vault..."
update_vault

echo "🍿 Preparing hugo content..."
prepare_hugo

echo "🍿 Exporting obsidian vault with obsidian-export..."
# Export obsidian vault to $HUGO_ROOT/content/posts (using version with LINK-STRATEGY)
$EXPORT_BINARY "$VAULT_PATH" --start-at "$VAULT_PATH" --frontmatter=always --link=none $HUGO_ROOT/content/posts/
# added:   --link LINK-STRATEGY       Link strategy (one of: encoded, none) (default: encoded)

if [ "$GITHUB_ACTIONS" ]; then
  # TODO may need to build into different dir, see script/publish setup
  echo "CD'ing to $HUGO_ROOT"
  cd "$HUGO_ROOT"
  echo "Defering to Github Actions for building site within runner..."
else
  echo "🏗 Not a Github Action, Serving blog locally..."
  pushd "$HUGO_ROOT" > /dev/null
  # here currently evaluating built files
  hugo server --disableFastRender --buildDrafts --destination ../docs
#   hugo server -D --destination ../docs # serves locally with drafts 
#    Q: do we need to configure base-url ?
  popd > /dev/null
fi

# TODO - move $HUGO_ROOT/content/posts/attachments to $HUGO_ROOT/assets/images
# TODO - add in script for responsive images