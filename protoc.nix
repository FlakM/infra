{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
  name = "toktme-core";

  targetPkgs = pkgs: [ pkgs.jdk8 pkgs.glibc pkgs.gcc ];

  runScript = "zsh";
}).env

