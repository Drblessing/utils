#!/bin/bash
# Plug and play startup script for macOS and Linux systems. Installs what I like.

# 1. Detect shell and operating system
# 2. Install git
# 3. Clone notes repo   
# 4. Install dotfiles


# 1. Detect shell and operating system
# Determine the shell
if [[ "$(basename $SHELL)" == "bash" ]]; then
    SHELL="bash"
    echo "bash detected."
elif [[ "$(basename $SHELL)" == "zsh" ]]; then
    SHELL="zsh"
    echo "zsh detected."
else
    echo "Unsupported shell: $(basename $SHELL)"
    exit 1
fi

# Determine the operating system
if [[ "$(uname)" == "Darwin" ]]; then
    OS="macOS"
    echo "macOS detected."
elif [[ "$(uname)" == "Linux" ]]; then
    OS="Linux"
    echo "Linux detected."
else
    echo "Unsupported operating system: $(uname)"
    exit 1
fi

# For macOS, check if Homebrew is installed. If not, install it.
if [[ "$OS" == "macOS" ]]; then
    if [[ ! -x "$(command -v brew)" ]]; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo "Homebrew installed."
    # Else print homebrew version
    else
        echo "Homebrew found."
        brew --version | head -n 1
    fi
    # Update homebrew
    echo "Updating Homebrew..."
    brew update
fi

# For linux, update apt
if [[ "$OS" == "Linux" ]]; then
    echo "Updating apt..."
    apt install sudo -y
    sudo apt update -y
fi

# 2. Install git
# Check if git is installed. If not, install it.
if [[ ! -x "$(command -v git)" ]]; then
    echo "Git not found. Installing git..."
    if [[ "$OS" == "macOS" ]]; then
        brew install git
    elif [[ "$OS" == "Linux" ]]; then
        sudo apt install git
    fi
    echo "Git installed."
# Else print git version
else
    echo "Git found."
    git --version
fi

# 3. Clone notes repo
# Check if notes repo is cloned. If not, clone it.
if [[ ! -d "$HOME/Github/notes" ]]; then
    echo "Notes repo not found. Cloning notes repo..."
    git clone https://github.com/Drblessing/notes.git "$HOME/Github/notes"
    echo "Notes repo cloned."
# Else pull latest notes repo
else
    echo "Notes repo found. Pulling latest notes repo..."
    cd "$HOME/Github/notes"
    git pull
    echo "Notes repo pulled."
fi

# 4. Install dotfiles
# Dotfiles are in configs/dotfiles/.*
# They are for zsh shells, so will need to be changed for bash shells
# Also, they should only append to existing config files, not overwrite them
echo "Installing dotfiles..."
DOTFILES_DIR="$HOME/Github/notes/configs/dotfiles"

# Debug change home
HOME="/tmp"

if [[ "$SHELL" == "bash" ]]; then
    CONFIG_FILES=(".bashrc" ".bash_profile")
elif [[ "$SHELL" == "zsh" ]]; then
    CONFIG_FILES=(".zshrc" ".zprofile" ".zshenv")
fi
for FILE in "${CONFIG_FILES[@]}"; do
    if [[ -f "$HOME/$FILE" ]]; then
        cat "$DOTFILES_DIR/$FILE" >> "$HOME/$FILE"
        echo "Updated $FILE"
    else 
        # If file doesn't exist in home directory, copy it
        cp -R "$DOTFILES_DIR/$FILE" "$HOME/"
    fi
done

echo "Setup completed."


