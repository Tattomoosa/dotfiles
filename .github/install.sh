#!/usr/bin/env bash

# Based heavily on the script at the end of the fantastic https://www.atlassian.com/git/tutorials/dotfiles

REPO=git@github.com:Tattomoosa/dotfiles.git

git clone --bare $REPO $HOME/.dotfiles
function dotfiles {
	   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
   }
mkdir -p .dotfiles-backup
dotfiles checkout
if [ $? = 0 ]; then
	echo "Checked out config.";
else
	echo "Backing up pre-existing dot files.";
	dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi;
dotfiles checkout
dotfiles config status.showUntrackedFiles no
