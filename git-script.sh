#!/bin/bash

# Git cycle script - add, commit, pull, push
# Auto commit with timestamp to origin main

# Check if inside a Git repo
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "ERROR: Not a Git repository. Exiting..."
    exit 1
fi

# Generate timestamp
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# Commit message
msg="last updated on $timestamp"

echo
echo "Running Git Cycle with commit message:"
echo "\"$msg\""
echo "========================"

# Add all changes
echo "Adding all changes..."
if ! git add -A; then
    echo "ERROR: Failed to add files."
    exit 1
fi

# Commit changes
echo "Committing changes..."
if ! git commit -m "$msg"; then
    echo "WARNING: Nothing to commit, working tree clean."
else
    echo "SUCCESS: Changes committed successfully."
fi

# Pull latest from origin main
echo "Pulling latest changes from origin main..."
if ! git pull --rebase origin main; then
    echo "ERROR: Failed to pull changes. Resolve conflicts manually."
    exit 1
fi

# Push to origin main
echo "Pushing to origin main..."
if ! git push origin main; then
    echo "ERROR: Failed to push changes."
    exit 1
fi

echo
echo "SUCCESS: Git cycle completed successfully at $timestamp on origin/main"