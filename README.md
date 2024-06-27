# Neovim Configuration

## Getting Started

### Prerequisites

- [ripgrep](https://github.com/BurntSushi/ripgrep) (required for `telescope.nvim`)
- Install Python virtual environment:
  
  ```
  sudo apt install python3-venv
  ```
  
  (required for LSP: `robotframework_ls`)

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

