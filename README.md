# Neovim Configuration

## Getting Started

### Prerequisites

- [ripgrep](https://github.com/BurntSushi/ripgrep) (required for `telescope.nvim`)
- Install LLDB:
  
  ```
  sudo apt install lldb
  ```
  
  (required for DAP: C++/Rust)

- Download and set up [codelldb](https://github.com/vadimcn/codelldb/releases/latest) (required for DAP: C++/Rust):
  
  1. Copy the directory `lldb` to `~/.local/lib/`
  2. Copy `adapter/codelldb` and the `so` file to `~/.local/bin/`
  3. Copy the directory `formatters` to `~/.local/`

- Install Delve for Go:
  
  ```
  go install github.com/go-delve/delve/cmd/dlv@latest
  ```

  (required for DAP: Go)

## Tests

Run the headless configuration tests with `make test`. The tests require
Neovim and Plenary; set `PLENARY_DIR` to the Plenary checkout if it is not
installed at `~/.local/share/nvim/lazy/plenary.nvim`. GitHub Actions runs them
against stable and nightly Neovim.
