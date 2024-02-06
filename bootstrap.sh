#!/usr/bin/env bash

# Install Brew
if ! command -v brew &> /dev/null; then
    echo "[INFO] The 'brew' command was not found."
    echo "[INFO] Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Add brew to current sessions
  echo "[INFO] Adding brew to the current shell session"
  if [[ $(uname) == "Darwin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ $(uname) == "Linux" ]]; then 
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  else
    echo "[ERROR] Unable to properly install Homebrew."
    exit 1
  fi

  # Opt out of brew analytics
  echo "[INFO] Opting out of Homebrew Analytics"
  brew analytics off
fi


# Install Neccesary linuxbrew pkgs
if [[ $(uname) == "Linux" ]]; then 
  echo "[INFO] Installing recommended and neccesary brew packages for linux brew..."
  if command -v apt-get &> /dev/null; then 
    sudo apt-get install build-essential
  fi
  brew install gcc
  if [[ ! $(ps -p $$) = *zsh* ]]; then
    echo "[INFO] Installing zsh and changing login shell..."
    brew install zsh
    chsh -s "/home/linuxbrew/.linuxbrew/bin/zsh"
    sudo chsh -s "/home/linuxbrew/.linuxbrew/bin/zsh"
  fi
fi

# Setup Bitwarden
read -p "Would you like to setup Bitwarden? [y,N] " bw_setup
case $bw_setup in 
  y|Y) 
    echo "[INFO] Installing Bitwarden CLI"
    brew install bitwarden-cli jq
    read -p "What is the URL of the Bitwarden Server? " bw_server
    read -p "What is the Bitwarden Client ID? " bw_client_id
    read -p "What is the Bitwarden Secret Key? " bw_secret_key
    bw config server "$bw_server"
    BW_CLIENTID="$bw_client_id" BW_CLIENTSECRET="$bw_secret_key" bw login --apikey
    export BW_SESSION=$(bw unlock --raw)
    bw sync
    ;;
  n|N|*) :;;
esac

# Setup Vault
read -p "Would you like to setup vault? [y,N] " vault_setup
case $vault_setup in 
  y|Y) 
    brew tap hashicorp/tap
    brew install hashicorp/tap/vault
    read -p "What is the URL of the Vault Server? " vault_server
    export VAULT_ADDR="$vault_server"
    if [[ "${BW_SESSION}" && $(bw status --pretty | jq .status) == \"unlocked\" ]]; then
      read -p "What is the Vault entry name in Bitwarden? " vault_entry_name
      read -p "What is the Vault Token field name in Bitwarden? " vault_token_name
      vault_token=$(bw get item "$vault_entry_name" | jq -r --arg vault_token_name "$vault_token_name" '.fields[] | select(.name==$vault_token_name) | .value')
    else
      read -p "What is the Vault token? " vault_token
    fi
    export VAULT_TOKEN="$vault_token"
    ;;
  n|N|*) :;;
esac

# Install Chezmoi
brew install chezmoi

# Setup
read -p "Chezmoi --apply argument? " chezmoi_apply_arg
chezmoi init --apply "$chezmoi_apply_arg"