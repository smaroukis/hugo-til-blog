#!/bin/zsh

if [ "$GITHUB_ACTIONS" ]; then
  echo "Building site for Github Actions..."
else
  echo "Not a Github Action, serving site locally..."
fi
