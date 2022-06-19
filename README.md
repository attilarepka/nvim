# Neovim config



## Getting started

### Download latest dpkg from Releases:

https://github.com/neovim/neovim

### Install ctags for vim-tagbar:

`sudo apt install exuberant-ctags`

### Config file located here:

https://github.com/attilarepka/neovim-config

### Install plugins

`:PlugInstall`

### Install vim-coc relevant files:

``` bash
cd .local/share/nvim/plugged/
sudo npm install -g yarn
yarn install && yarn build
```

### FZF Installation

``` bash
sudo apt install silversearcher-ag
sudo apt install ripgrep
```

### Clangd custom format properties

Create a file under `~/.clang-format`:

``` bash
IndentWidth: 4
```
