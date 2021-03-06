#!/usr/bin/env bash

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
export VISUAL=vim
export EDITOR="$VISUAL"

source ~/.config/bash/settings.bash
source ~/.config/bash/on_login.bash
source ~/.config/bash/aliases.bash
source ~/.config/bash/prompt.bash
