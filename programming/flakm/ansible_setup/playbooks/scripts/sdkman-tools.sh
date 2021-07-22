#!/usr/bin/env bash
set -e
source ~/.sdkman/bin/sdkman-init.sh

if ! command -v java &> /dev/null
then    
    sdk i java 8.0.292.hs-adpt
    sdk i gradle
    sdk i maven
    sdk i sbt
    sdk i scala
fi


