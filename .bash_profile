# mac only
if [[ $OSTYPE == 'darwin'* ]]; then
	# git completions
	[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

	# Macs open login shell always, so source profile here which in turn sources bashrc.
	# TODO there is probably a better way to do this
	. ~/.profile
	export LDFLAGS="-L/usr/local/opt/llvm/lib"
        export CPPFLAGS="-I/usr/local/opt/llvm/include"
	export PATH="/usr/local/opt/llvm/bin:$PATH"
fi
