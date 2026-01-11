# Dotfiles

Personal dotfiles for remote Linux servers with zsh + oh-my-zsh and Neovim (LazyVim).

## Quick Install

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## What's Included

### Zsh
- **oh-my-zsh** with clean theme
- **Plugins**: git, zsh-autosuggestions, zsh-syntax-highlighting
- Custom aliases and tmux integration

### Neovim
Lightweight LazyVim-based configuration with:
- **Colorscheme**: Cyberdream
- **File navigation**: Telescope, Oil.nvim
- **LSP**: lua, python, typescript, go, c/c++, rust, bash
- **UI**: Bufferline, Lualine, Noice, Snacks.nvim
- **Editor**: Treesitter, Gitsigns, which-key

## Structure

```
~/dotfiles/
├── install.sh          # Installation script
├── zsh/
│   └── .zshrc          # Zsh configuration
├── nvim/
│   ├── init.lua        # Neovim entry point
│   └── lua/
│       ├── config/     # Core configuration
│       └── plugins/    # Plugin specs
└── README.md
```

## Requirements

The install script will automatically install:
- zsh, neovim, git, curl, unzip
- ripgrep (rg), fd, fzf

## Supported Distributions

- Debian/Ubuntu (apt)
- Fedora/RHEL (dnf/yum)
- Arch Linux (pacman)
- Alpine Linux (apk)

## Key Bindings

### Zsh
| Alias | Command |
|-------|---------|
| `v` | nvim |
| `ll` | ls -lah |
| `gs` | git status |

### Neovim
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>/` | Live grep |
| `<leader>O` | Toggle Oil |
| `<C-h/j/k/l>` | Navigate splits (tmux aware) |
| `<S-h/l>` | Previous/Next buffer |

## Manual Installation

If you prefer manual setup:

1. Install dependencies
2. Clone oh-my-zsh: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
3. Clone zsh-autosuggestions to `~/.oh-my-zsh/custom/plugins/`
4. Symlink configs:
   ```bash
   ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
   ln -sf ~/dotfiles/nvim ~/.config/nvim
   ```
5. Change shell: `chsh -s $(which zsh)`

## License

MIT
