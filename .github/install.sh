#!/usr/bin/env bash

# Based heavily on the script at the end of the fantastic https://www.atlassian.com/git/tutorials/dotfiles

set -e
set -o pipefail

# Change the repo, change the dotfiles
REPO_REMOTE=git@github.com:Tattomoosa/dotfiles.git
REPO_LOCAL=$HOME/.dotfiles

# Clone the repo into ~/.dotfiles
echo "$REPO_REMOTE $REPO_LOCAL"
git clone --bare $REPO_REMOTE $REPO_LOCAL

# Create a dotfiles command to interact with the repo globally
function dotfiles {
	/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

# Checkout
dotfiles checkout
if [ $? = 0 ]; then
	echo "Checked out config.";
else
	# If checkout failed, move any existing files and try again
	echo "Backing up pre-existing dot files.";
	# Create a folder for potential backups
	mkdir -p $HOME/.dotfiles-backup
	dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $HOME/.dotfiles-backup/{}
	dotfiles checkout
fi;

# Do not show untracked files in this repo
dotfiles config status.showUntrackedFiles no
