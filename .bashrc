source $HOME/.config/bash/index.bash

git config --global core.excludesfile $HOME/.gitignore

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
PATH="$HOME/.local/bin:$PATH"

# mac only
if [[ $OSTYPE == 'darwin'* ]]; then

	# 
	export XDG_CONFIG_HOME="$HOME/.config"

	# 
	PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

fi
