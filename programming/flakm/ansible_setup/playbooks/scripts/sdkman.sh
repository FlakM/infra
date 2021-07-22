#!/usr/bin/env bash

if ! sdkman -v java &> /dev/null
then    
    set -e
    curl -s "https://get.sdkman.io?rcupdate=false" > sdkman.sh
    chmod +x sdkman.sh
    ./sdkman.sh
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk version
fi
