#!/bin/bash

git_name="username"
git_email="example@gmail.com"
KEY_FILE="$HOME/.ssh/id_ed25519"

echo "🔧 Setting Git global config..."
git config --global user.name "$git_name"
git config --global user.email "$git_email"
echo "✅ Git config set: $git_name <$git_email>"

if [ -f "$KEY_FILE" ]; then
    echo "🔑 SSH key already exists at $KEY_FILE"
else
    echo "🔨 Generating new SSH key..."
    ssh-keygen -t ed25519 -C "$git_email" -f "$KEY_FILE" -N ""
fi

echo "🚀 Starting ssh-agent..."
eval "$(ssh-agent -s)"

echo "➕ Adding SSH private key to agent..."
ssh-add "$KEY_FILE"

echo "📋 Copying SSH public key to clipboard..."
if command -v xclip &>/dev/null; then
    xclip -sel clip < "${KEY_FILE}.pub"
    echo "✅ Public key copied using xclip."
elif command -v pbcopy &>/dev/null; then
    pbcopy < "${KEY_FILE}.pub"
    echo "✅ Public key copied using pbcopy."
else
    echo "⚠️ Clipboard utility not found. Here's your public key:"
    cat "${KEY_FILE}.pub"
fi

echo ""
echo "🔗 Add this key to GitHub: https://github.com/settings/keys"
read -p "Press Enter to test SSH connection to GitHub..."
ssh -T git@github.com
