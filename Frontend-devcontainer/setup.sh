#!/bin/bash

# Function to print messages
print_message() {
  echo "--------------------------------------"
  echo "$1"
  echo "--------------------------------------"
}

# Copy .gitconfig from Windows to WSL home directory
sudo cp /mnt/c/Users/Pavankumar/.gitconfig ~/


# handling permissions
WORKSPACE_DIR="/workspace"

# Get the owner and group of the directory
OWNER_GROUP=$(stat -c "%U:%G" "$WORKSPACE_DIR")

# Get the permissions of the directory
PERMISSIONS=$(stat -c "%a" "$WORKSPACE_DIR")

# Check if the owner is 'node' and the group is 'node'
if [ "$OWNER_GROUP" != "node:node" ]; then
  print_message "Changing ownership of $WORKSPACE_DIR to node:node"
  # sudo chown -R node:node "$WORKSPACE_DIR"
  sudo find /workspace -path /workspace/node_modules -prune -o -exec chown -R node:node {} +
else
  print_message "Ownership is already set to node:node"
fi

# Check if the permissions are 755
if [ "$PERMISSIONS" != "755" ]; then
  print_message "Changing permissions of $WORKSPACE_DIR"
  # sudo chmod -R 755 "$WORKSPACE_DIR"
  # sudo find /workspace -path /workspace/node_modules -prune -o -exec chmod -R 755 {} \\;
  sudo find "$WORKSPACE_DIR" -path "$WORKSPACE_DIR/node_modules" -prune -o -exec chmod -R 755 {} +

else
  print_message "Permissions are already set."
fi


# Handle node_modules and package-lock.json hash
LOCKFILE="package-lock.json"
HASHFILE=".package-lock.hash"
NODE_MODULES_DIR="node_modules"

print_message "Checking if node_modules directory exists"
if [ ! -d "$NODE_MODULES_DIR" ]; then
  print_message "node_modules directory does not exist. Running npm install..."
  npm install --legacy-peer-deps
  sha256sum "$LOCKFILE" > "$HASHFILE"
else
  CURRENT_HASH=$(sha256sum "$LOCKFILE")
  if [ -f "$HASHFILE" ]; then
    PREVIOUS_HASH=$(cat "$HASHFILE")
  else
    PREVIOUS_HASH=""
  fi

  print_message "Comparing package-lock.json hashes"
  if [ "$CURRENT_HASH" != "$PREVIOUS_HASH" ]; then
    print_message "package-lock.json has changed. Running npm install..."
    npm install --legacy-peer-deps
    sha256sum "$LOCKFILE" > "$HASHFILE"
  else
    print_message "node_modules is up-to-date."
  fi
fi
