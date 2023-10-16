#!/usr/bin/bash

### the script is tested on Oracle Enterprise Linux 8
### rlwrap installation

### prerequisites for git cloning and compilation
#
# sudo dnf -y install readline-devel git 
# sudo dnf -y install autoconf automake
# sudo dnf -y grouplist "Development Tools"

mkdir -p ~/.local ~/work/github ~/.bashrc.d

git clone https://github.com/Maxim4711/sqlplus_fzf.git  ~/work/github/sqlplus_fzf
git clone https://github.com/hanslub42/rlwrap.git       ~/work/github/rlwrap

(cd ~/work/github/rlwrap && autoreconf -i && ./configure --prefix=$HOME/.local && make -j$(nproc) && make install)

### rust toolchain installation (passing -y switch disables confirmatin prompts and makes install script non interactive)
### Alternatively - to not install rust, just download last released binary and put it on the path
# V=$(curl --silent "https://api.github.com/repos/sharkdp/bat/releases/latest" | grep -Eo '"tag_name": "v(.*)"' | sed -E 's/.*"([^"]+)".*/\1/') && curl -sOL "https://github.com/sharkdp/bat/releases/download/$V/bat-$V-x86_64-unknown-linux-musl.tar.gz" && tar xzvf "bat-$V-x86_64-unknown-linux-musl.tar.gz" -C . && sudo sh -c "cp ./bat-$V-x86_64-unknown-linux-musl/bat ~/.local/bin/bat" && rm bat-$V-x86_64-unknown-linux-musl.tar.gz && unset V

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
cargo install bat
echo '--theme="Nord"' >> $(bat --config-file)

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
source ~/.bashrc

cat ~/work/github/sqlplus_fzf/.inputrc >> ~/.inputrc
cat ~/work/github/sqlplus_fzf/sqlplus_hotkeys > ~/.local/share/rlwrap/filters/sqlplus_hotkeys && chmod 755 ~/.local/share/rlwrap/filters/sqlplus_hotkeys
cat ~/work/github/sqlplus_fzf/alias.sh >> ~/.bashrc.d/alias.sh
source ~/.bashrc.d/alias.sh

cat << 'EOF' >> ~/.bashrc
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi

unset rc
EOF

### optionaly clone public sql scripts repositories
# git clone https://github.com/xtender/xt_scripts.git     ~/work/github/xt_scripts
# git clone https://github.com/tanelpoder/tpt-oracle.git  ~/work/github/tpt-oracle
# git clone https://github.com/carlos-sierra/cscripts.git ~/work/github/cscripts
