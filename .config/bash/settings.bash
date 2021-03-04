export TERM="xterm-256color"
# smart search
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
bind "set completion-ignore-case on"

# git completion
source /usr/share/bash-completion/completions/git
# hostname completion
source /usr/share/bash-completion/completions/hostname

COLUMNS=250
