# Overview

I use chezmoi to maintain my dotfiles across machine

https://www.chezmoi.io/quick-start/

# Setting up a new machine 

```bashrc
chezmoi init --apply blueputty01
```
# debian dependencies

## zsh

https://gist.github.com/n1snt/454b879b8f0b7995740ae04c5fb5b7df

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
