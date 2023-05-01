# Neovim configuration

## Getting started

### Get latest [neovim](https://github.com/wbthomason/packer.nvim) from:

https://github.com/neovim/neovim/releases/tag/stable

### Prerequisites

- [ripgrep](https://github.com/BurntSushi/ripgrep) (telescope.nvim)
- `sudo apt install python3-venv` (lsp: robotframework_ls)
- `sudo apt install lldb` (dap: cpp/rust)
- [codelldb](https://github.com/vadimcn/codelldb/releases/latest)
(dap: cpp/rust -> copy dir `lldb` to `~/.local/lib/` and `adapter/codelldb + so` to `~/.local/bin/` and dir `formatters` to `~/.local/`)
- `go install github.com/go-delve/delve/cmd/dlv@latest` (dap: go)

### Install [packer.nvim](https://github.com/wbthomason/packer.nvim)

``` bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
 ```

 Sync plugins with `:PackerSync`

### Further todo(s):

- [ ] mfussenegger/nvim-dap
- [ ] theprimeagen/refactoring.nvim
