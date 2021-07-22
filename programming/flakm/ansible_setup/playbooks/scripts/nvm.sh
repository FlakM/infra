#!/usr/bin/env bash
set -e
if [[ ! -d ~/.nvm ]]; then
	git clone https://github.com/nvm-sh/nvm.git ~/.nvm
else
	echo "nvm already present"
fi
