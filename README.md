# Overview

I use chezmoi to maintain my dotfiles across machine

https://www.chezmoi.io/quick-start/

# Setting up a new machine 

```bashrc
chezmoi init --apply blueputty01
```
# debian deps

## utils

[nvim](https://github.com/neovim/neovim/blob/master/INSTALL.md)

```bash
sudo apt install tmux
```

## zsh

https://gist.github.com/n1snt/454b879b8f0b7995740ae04c5fb5b7df

```bash
sudo apt install zsh-autosuggestions zsh-syntax-highlighting zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
nvim ~/.zshrc
```

Find the line which says plugins=(git).

Replace that line with plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)


## i3 deps

```bash
sudo apt install amixer brightnessctl playerctl
```

## nice to have

font: JetBrainsMonoNL Nerd Font

anki

```bash
sudo apt install libxcb-xinerama0 libxcb-cursor0 libnss3
# after downloading 
tar xaf ~/Downloads/anki-2XXX-linux-qt6.tar.zst
cd anki-2XXX-linux-qt6
sudo ./install.sh
```

asian character support

```bash
sudo apt install fonts-noto
```

## top configuration

from https://www.reddit.com/r/linux/comments/8yx165/htop_vs_top/

I've always favored built in tools that can be found on the most installs possible, but maybe that's because a lot of machines I work with don't have internet connections. If you open top and press zxcVm1t0, it looks cool. If you put it in advanced mode (A) and set up all the fields the same way, it looks amazing. You get a ton of info, and can write your config with W. And that's just the beginning. Z opens a cool customization menu, and there are endless options for data filtering. I'm not trying to be elitist or patronizing or whatever, I legitimately wonder why so many folks use htop instead of top. I don't see any pics of customizations in top when I do google searches, so here's normal mode after I typed in zxcVm1t030 (then enter to select my node option).

