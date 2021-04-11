#!/usr/bin/env bash

# Based heavily on the script at the end of the fantastic https://www.atlassian.com/git/tutorials/dotfiles

# Change the repo, change the dotfiles
REPO=Tattomoosa/dotfiles.git
REPO_LOCAL=$HOME/.dotfiles

GITHUB_SSH="git@github.com:"
GITHUB_HTTPS="https://github.com/"

REPO_REMOTE="$GITHUB_SSH$REPO"

if [[ $1 == "https" ]]; then
	REPO_REMOTE="$GITHUB_HTTPS$REPO"
fi

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
