# infra

## Setup dotfiles

This part is inspired by: https://www.atlassian.com/git/tutorials/dotfiles

```bash
# to download code and copy instructions

nix-env -iA nixos.git nixos.firefox
mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix_backup


# we need a user created before cloning the repo
# it contains .dotfiles
mkdir /home/flakm
groupadd -g 1000 flakm
useradd -m flakm -g 1000
passwd flakm
su - flakm

echo ".cfg" >> .gitignore
git clone --bare --branch nix_os https://github.com/FlakM/infra.git $HOME/.cfg
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# this will backup old files
function mvParent(){
  d=$(dirname "$1")
  mkdir -p ".config-backup/$1"
  mv "$1" ".config-backup/$1"
}

cd ~
export -f mvParent
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} bash -c 'mvParent "{}"'


config checkout
config config --local status.showUntrackedFiles no

# install 
# needed for home manager import
# https://nix-community.github.io/home-manager/index.html#sec-install-nixos-module
exit
ln -s /home/flakm/.config/nixpkgs/configuration.nix /etc/nixos/configuration.nix
nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz home-manager
nix-channel --update

# Install nix os stuff
nixos-rebuild switch


# For secrets
cd ~/.gnupg
mkdir -p ~/.ssh
wget https://raw.githubusercontent.com/drduh/config/master/gpg-agent.conf
cat > ~/.ssh/id_rsa_yubikey.pub <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDh6bzSNqVZ1Ba0Uyp/EqThvDdbaAjsJ4GvYN40f/p9Wl4LcW/MQP8EYLvBTqTluAwRXqFa6fVpa0Y9Hq4kyNG62HiMoQRjujt6d3b+GU/pq7NN8+Oed9rCF6TxhtLdcvJWHTbcq9qIGs2s3eYDlMy+9koTEJ7Jnux0eGxObUaGteQUS1cOZ5k9PQg+WX5ncWa3QvqJNxx446+OzVoHgzZytvXeJMg91gKN9wAhKgfibJ4SpQYDHYcTrOILm7DLVghrcU2aFqLKVTrHSWSugfLkqeorRadHckRDr2VUzm5eXjcs4ESjrG6viKMKmlF1wxHoBrtfKzJ1nR8TGWWeH9NwXJtQ+qRzAhnQaHZyCZ6q4HvPlxxXOmgE+JuU6BCt6YPXAmNEMdMhkqYis4xSzxwWHvko79NnKY72pOIS2GgS6Xon0OxLOJ0mb66yhhZB4hUBb02CpvCMlKSLtvnS+2IcSGeSQBnwBw/wgp1uhr9ieUO/wY5K78w2kYFhR6Iet55gutbikSqDgxzTmuX3Mkjq0L/MVUIRAdmOysrR2Lxlk692IrNYTtUflQLsSfzrp6VQIKPxjfrdFhHIfbPoUdfMf+H06tfwkGONgcej56/fDjFbaHouZ357wcuwDsuMGNRCdyW7QyBXF/Wi28nPq/KSeOdCy+q9KDuOYsX9n/5Rsw== cardno:000614320136
EOF
chmod 600 ~/.ssh/id_rsa_yubikey.pub

cat << EOF >> ~/.ssh/config
Host github.com
    IdentitiesOnly yes
    IdentityFile ~/.ssh/id_rsa_yubikey.pub
EOF

gpg --card-status


ssh git@github.com -vvv


gpg --recv 0x6B872E24F09A547E
export KEYID=0x6B872E24F09A547E
# trust completly
gpg --edit-key $KEYID


gpg --output public.pgp --armor --export maciej.jan.flak@gmail.com



bash
source .bashrc


# this will unpack secrets stored in encrypted tar.
import_secrets
```

# Manual tasks

Some tasks are very hard to automate so run those by yourself:

```bash
# unpack secrets if you haven't done that already:
import_secrets

# configure dropbox
~/.dropbox-dist/dropboxd
systemctl --user enable dropbox
systemctl --user status dropbox
ls -al ~/Dropbox



# configure onedrive
onedrive --confdir=/$HOME/.config/onedrive-0
systemctl --user enable onedrive@onedrive-0.service
systemctl --user start onedrive@onedrive-0.service
systemctl --user status onedrive@onedrive-0.service


# login to docker accounts
mkdir ~/.docker
mv ~/.secrets/config.json ~/.docker/config.json
```

## Backup of important stuff:


```bash
# backing up thunderbird data:
tar -jcvf thunderbird-email-profile.tar.bz2 .thunderbird

# restoring
rm -rf ~/.thunderbird
tar -xvf thunderbird-email-profile.tar.bz2
```

# Taski:

- [ ] dodać instalację undervoltingu https://github.com/kitsunyan/intel-undervolt
- [ ] przetestować
  - [ ] pobranie kodu z repozytorium przy wykorzystaniu gpg odpowiednio ustawionego do sprawdzenia tutaj o https://stackoverflow.com/a/42942312/5665181
  - [ ] spushowanie kodu do githuba i gitlaba
  - [ ] podłączenie się do vpn i ssh
  - [ ] zbudowanie najważniejszych projektów
  - [ ] czy działa undervolting i czy jest potrzebny?
  - [ ] czy powertop wskazuje spoko zużycie
  - [ ] czy da się dockerem odpalić na nowym FS
  - [ ] czy da się pocztę odebrać/wysłać 
- [ ] dodać instrukcję w tym miejscu jakie miejsca na os należy backupować oprócz wskazanych powyżej
	- [ ] poczta
	- [ ] kody źródłowe
	- [ ] dokumenty/zdjęcia


