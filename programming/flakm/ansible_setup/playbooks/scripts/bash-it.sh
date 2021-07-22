#!/usr/bin/env bash
set -e
if [[ ! -d ~/.bash_it ]]; then
	git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
	~/.bash_it/install.sh --no-modify-config
else
	echo "bashit already present"
	bash-it update || true
fi

bashit enable plugin man node nvm java gradle history git fzf aws docker docker-compose alias-completion || true

