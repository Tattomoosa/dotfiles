#!/usr/bin/env bash

PROMPT_COMMAND=""

# source ~/.config/bash/git_status.bash
GIT_PROMPT_PATH="$HOME/.config/bash/dependencies/bash-git-prompt/gitprompt.sh"
# GIT_PROMPT_PATH="$HOME/.config/bash/gitprompt.sh"
# GIT_PROMPT_SETTINGS="$HOME/.config/bash/git_prompt_theme.bgtemplate"
if [ -f "$GIT_PROMPT_PATH" ]; then
    GIT_PROMPT_WITH_VIRTUAL_ENV=0
    GIT_PROMPT_START=" "
    GIT_PROMPT_END=" "
    GIT_PROMPT_ONLY_IN_REPO=1
    GIT_PROMPT_LEADING_SPACE=0
    VIRTUAL_ENV_DISABLE_PROMPT=1
    source "$GIT_PROMPT_PATH"
fi

COLOR_GREY=90
COLOR_GIT_CLEAN=92
COLOR_GIT_DIRTY=91
COLOR_TIME=37
COLOR_HOST=35
COLOR_PYTHON=96
COLOR_PATH=95
COLOR_PROMPT_SYMBOL=94
COLOR_BG=49
PROMPT_SYMBOL=" >"

_get_path_color() {
    local ERR="$?"
    # Default Blue
    local path_color=$COLOR_PATH
    # Command returned error? Red
    [ "$ERR" != "0" ] && path_color=31
    # Is Root? Then White
    [ "$(id -u)" == "0" ] && path_color=35
    echo "$path_color"
}

_path() {
    local path_fg=$(_get_path_color)
    local path_bg=$COLOR_BG
    local path_rep='\w'
    local str=""
    ((COLUMNS < 50)) && path_rep="$(basename "$PWD")"
    str="\[\033[${path_bg};${path_fg}m\]$path_rep"
    ((COLUMNS < 50)) && str="$str"$'\n'
    echo "$str"
}

_reload_history() {
    history -a
    history -n
}

_pre_newline() {
    PS1=$'\n'"$PS1"
}

_zsh_newline() {
    # Detect whether or not the command has a new line ending
    unset PROMPT_SP
    # Credit to Dennis Williamson on serverfault.com
    for ((i = 1; i<= $COLUMNS + 52; i++ )); do
        PROMPT_SP+=" ";
    done
    PS1='\[\e[7m%\e[m\]${PROMPT_SP: -$COLUMNS+1}\015'"$PS1"
}

_python() {
  local env=""
  if [ $VIRTUAL_ENV ]; then
      env="$(basename $VIRTUAL_ENV)"
  fi
  if hash conda 2>/dev/null; then
    if [ "$CONDA_DEFAULT_ENV" ]; then
      env="$CONDA_DEFAULT_ENV"
    elif [ "$VIRTUAL_ENV" ]; then
      env="$(basename $VIRTUAL_ENV)"
    fi
  fi
  if [ "$env" ]; then
    local brace_fg=$COLOR_GREY
    local brace_fg=$COLOR_GREY
    local conda_fg=$COLOR_PYTHON
    local bg=$COLOR_BG
    local conda=""
    str=""
    str="$str\[\033[${bg};${brace_fg}m\]"
    str="$str\[\033[${bg};${conda_fg}m\]"
    str="$str$env"
    str="$str\[\033[${bg};${brace_fg}m\]"
    str="$str:"
    echo "$str"
  fi
}

_color() {
    local bg = $1
    local fg = $2
    echo "\[\033[${bg};${fg}m\]"
}

_git() {
    if git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null; then
        # PS1 is already filled by gitprompt.sh
        local str="$PS1"
        echo "${str:1}"
    fi
}

_last_command() {
  if [[ "${GIT_PROMPT_LAST_COMMAND_STATE:-0}" = 0 ]]; then
    LAST_COMMAND_INDICATOR="";
  else
    LAST_COMMAND_INDICATOR="  ${LAST_COMMAND_INDICATOR}"
  fi
  echo "${LAST_COMMAND_INDICATOR}"
}

_host() {
    if [ -n "$SSH_CONNECTION" ] ||
            # [ -n "$TMUX" ] ||
            [ -n "$SUDO_COMMAND" ]; then
        local fg=$COLOR_HOST
        local brace_fg=$COLOR_GREY
        local bg=$COLOR_BG
        local hostname="$(</etc/hostname)"
        local hostname="${hostname/.*}"
        local str=""
        str="$str\[\033[${bg};${fg}m\]"
        str="$str$hostname"
        str="$str\[\033[${bg};${brace_fg}m\]"
        str="$str:"
        echo "$str"
    fi
}

_time() {
    local time=$(date +"%H:%M")
    local time_fg=$COLOR_TIME
    local brace_fg=$COLOR_GREY
    local bg=$COLOR_BG
    local str="\[\033[${bg};${brace_fg}m\]["
    local str="$str\[\033[${bg};${time_fg}m\]\]${time}"
    local str="$str\[\033[${bg};${brace_fg}m\]]"
    echo "$str"
}

_reset() {
    echo "\[\033[0m\]"
}

_symbol() {
    local fg=$COLOR_PROMPT_SYMBOL
    local bg=$COLOR_BG
    local str="\[\033[${bg};${fg}m\]${PROMPT_SYMBOL}"
    echo "$str "
}

_clear() {
    PS1=""
}

_prompt() {
    local topline="$(_git)"
    if [ -n "$topline" ]; then
        topline="${topline}\n"
    fi
    PS1="$topline"
    PS1="$PS1$(_time)"
    PS1="$PS1\[ \]"
    PS1="$PS1$(_host)"
    PS1="$PS1$(_python)"
    PS1="$PS1$(_path)"
    PS1="$PS1$(_last_command)"
    PS1="$PS1$(_symbol)"
    PS1="$PS1$(_reset)"
    PS1="$PS1$(_zsh_newline)"
    _pre_newline
}

PROMPT_COMMAND="${PROMPT_COMMAND};_prompt"
