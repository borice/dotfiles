# install with:
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/borice/dotfiles/main/setup.sh)"

# install powerline font for vim
mkdir -p ~/.local/share/fonts/NerdFonts && curl -fLo "$HOME/.local/share/fonts/NerdFonts/JetBrains Mono Regular Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete.ttf

# install coursier
CS_TEMP=$(mktemp)
curl -fL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d >$CS_TEMP
chmod +x $CS_TEMP
$CS_TEMP setup -y
rm -f $CS_TEMP

if [[ "$(uname -s)" == "Linux" ]]; then
  if [ -f "/etc/debian_version" ]; then
    # install required packages
    sudo apt -y install git fzf bat exa fd-find tree vim curl fontconfig

    git clone https://github.com/borice/dotfiles.git ~/.dotfiles

    if type -P fzf >/dev/null; then
      ln -s ~/.dotfiles/fzf.bash ~/.fzf.bash
    fi

    if type -P fc-cache >/dev/null; then
      fc-cache -vf ~/.local/share/fonts/NerdFonts
    fi

  fi
fi

if [ -n "$BASH_VERSION" ]; then
  # download bash-git-prompt
  git clone https://github.com/magicmonty/bash-git-prompt.git ~/.repos/bash-git-prompt --depth=1

  # download z.sh
  git clone https://github.com/rupa/z.git ~/.repos/z --depth=1
fi

cat <<EOF >>~/.bashrc

if [ -f ~/.dotfiles/common_env ]; then
  source ~/.dotfiles/common_env
fi

if [ -f ~/.dotfiles/common_bashrc ]; then
  source ~/.dotfiles/common_bashrc
fi
EOF

cat <<EOF >>~/.bash_aliases

if [ -f ~/.dotfiles/common_aliases ]; then
  source ~/.dotfiles/common_aliases
fi
EOF

echo "All done, log out and log back in to activate changes"
