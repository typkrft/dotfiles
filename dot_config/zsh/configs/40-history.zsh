#!/usr/bin/env zsh

HISTFILE="$HOME/.zsh_history"
if [[ ! -f "$HISTFILE" ]]; then
    touch "$HISTFILE"
fi
HISTSIZE="100000"
SAVEHIST="100000"
HISTORY_IGNORE="(cd|ls|vault|bw|export VAULT)*"
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
unsetopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
unsetopt INC_APPEND_HISTORY
