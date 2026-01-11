#!/bin/bash

set -e

DOTFILES_DIR="$HOME/dotfiles"

# Use sudo only if not root
SUDO=""
if [ "$EUID" -ne 0 ]; then
    SUDO="sudo"
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect package manager
detect_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v yum &> /dev/null; then
        echo "yum"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    elif command -v apk &> /dev/null; then
        echo "apk"
    else
        echo "unknown"
    fi
}

# Install packages based on package manager
install_packages() {
    local pm=$(detect_package_manager)
    print_info "Detected package manager: $pm"

    case $pm in
        apt)
            $SUDO apt update
            $SUDO apt install -y zsh git curl unzip ripgrep fd-find fzf
            # fd is named fd-find on Debian/Ubuntu, create symlink
            if [ ! -f /usr/bin/fd ] && [ -f /usr/bin/fdfind ]; then
                $SUDO ln -sf /usr/bin/fdfind /usr/bin/fd
            fi
            # Install latest Neovim from GitHub (apt version is too old for LazyVim)
            install_neovim_from_github
            ;;
        dnf)
            $SUDO dnf install -y zsh git curl unzip neovim ripgrep fd-find fzf
            ;;
        yum)
            $SUDO yum install -y epel-release
            $SUDO yum install -y zsh git curl unzip
            # neovim, ripgrep, fd, fzf may need manual installation on older RHEL
            if ! command -v nvim &> /dev/null; then
                print_warning "Neovim not available in yum, installing from GitHub releases..."
                install_neovim_from_github
            fi
            if ! command -v rg &> /dev/null; then
                print_warning "ripgrep not available, installing from GitHub releases..."
                install_ripgrep_from_github
            fi
            if ! command -v fd &> /dev/null; then
                print_warning "fd not available, installing from GitHub releases..."
                install_fd_from_github
            fi
            if ! command -v fzf &> /dev/null; then
                print_warning "fzf not available, installing from git..."
                install_fzf_from_git
            fi
            ;;
        pacman)
            $SUDO pacman -Syu --noconfirm zsh git curl unzip neovim ripgrep fd fzf
            ;;
        apk)
            $SUDO apk add zsh git curl unzip neovim ripgrep fd fzf
            ;;
        *)
            print_error "Unknown package manager. Please install manually: zsh git curl unzip neovim ripgrep fd fzf"
            exit 1
            ;;
    esac
}

# Install Neovim from GitHub releases (latest stable)
install_neovim_from_github() {
    local version="v0.11.2"
    local current_version=""

    # Check if nvim exists and get version
    if command -v nvim &> /dev/null; then
        current_version=$(nvim --version | head -1 | grep -oP 'v\d+\.\d+\.\d+' || echo "")
    fi

    # Skip if already at target version
    if [ "$current_version" = "$version" ]; then
        print_warning "Neovim $version already installed, skipping..."
        return
    fi

    print_info "Installing Neovim $version from GitHub..."

    # Remove old apt neovim if exists
    if dpkg -l neovim &> /dev/null 2>&1; then
        $SUDO apt remove -y neovim neovim-runtime 2>/dev/null || true
    fi

    # Remove old installation
    $SUDO rm -rf /usr/local/nvim-linux64
    $SUDO rm -f /usr/local/bin/nvim

    # Download and install
    curl -LO "https://github.com/neovim/neovim/releases/download/${version}/nvim-linux-x86_64.tar.gz"
    $SUDO tar -C /usr/local -xzf nvim-linux-x86_64.tar.gz
    $SUDO ln -sf /usr/local/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
    rm nvim-linux-x86_64.tar.gz

    print_success "Neovim $version installed from GitHub"
}

install_ripgrep_from_github() {
    local version="14.1.0"
    curl -LO "https://github.com/BurntSushi/ripgrep/releases/download/${version}/ripgrep-${version}-x86_64-unknown-linux-musl.tar.gz"
    tar xzf "ripgrep-${version}-x86_64-unknown-linux-musl.tar.gz"
    $SUDO mv "ripgrep-${version}-x86_64-unknown-linux-musl/rg" /usr/local/bin/
    rm -rf "ripgrep-${version}-x86_64-unknown-linux-musl" "ripgrep-${version}-x86_64-unknown-linux-musl.tar.gz"
    print_success "ripgrep installed from GitHub"
}

install_fd_from_github() {
    local version="v10.1.0"
    curl -LO "https://github.com/sharkdp/fd/releases/download/${version}/fd-${version}-x86_64-unknown-linux-musl.tar.gz"
    tar xzf "fd-${version}-x86_64-unknown-linux-musl.tar.gz"
    $SUDO mv "fd-${version}-x86_64-unknown-linux-musl/fd" /usr/local/bin/
    rm -rf "fd-${version}-x86_64-unknown-linux-musl" "fd-${version}-x86_64-unknown-linux-musl.tar.gz"
    print_success "fd installed from GitHub"
}

install_fzf_from_git() {
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-fish
    print_success "fzf installed from git"
}

# Install oh-my-zsh
install_oh_my_zsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        print_warning "oh-my-zsh already installed, skipping..."
    else
        print_info "Installing oh-my-zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "oh-my-zsh installed"
    fi
}

# Install zsh plugins
install_zsh_plugins() {
    local plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

    # zsh-autosuggestions
    if [ -d "$plugins_dir/zsh-autosuggestions" ]; then
        print_warning "zsh-autosuggestions already installed, skipping..."
    else
        print_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$plugins_dir/zsh-autosuggestions"
        print_success "zsh-autosuggestions installed"
    fi

    # zsh-syntax-highlighting (bonus)
    if [ -d "$plugins_dir/zsh-syntax-highlighting" ]; then
        print_warning "zsh-syntax-highlighting already installed, skipping..."
    else
        print_info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$plugins_dir/zsh-syntax-highlighting"
        print_success "zsh-syntax-highlighting installed"
    fi
}

# Create symlinks
create_symlinks() {
    print_info "Creating symlinks..."

    # Backup existing files
    if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
        print_warning "Backing up existing .zshrc to .zshrc.backup"
        mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
    fi

    if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
        print_warning "Backing up existing nvim config to nvim.backup"
        mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup"
    fi

    # Create .config directory if it doesn't exist
    mkdir -p "$HOME/.config"

    # Remove existing symlinks
    rm -f "$HOME/.zshrc"
    rm -rf "$HOME/.config/nvim"

    # Create symlinks
    ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

    print_success "Symlinks created"
}

# Change default shell to zsh
change_shell() {
    if [ "$SHELL" != "$(which zsh)" ]; then
        print_info "Changing default shell to zsh..."
        chsh -s "$(which zsh)"
        print_success "Default shell changed to zsh"
        print_warning "Please log out and log back in for changes to take effect"
    else
        print_success "zsh is already the default shell"
    fi
}

# Main installation
main() {
    echo ""
    echo "========================================"
    echo "       Dotfiles Installation Script     "
    echo "========================================"
    echo ""

    print_info "Starting installation..."

    # Install system packages
    print_info "Installing system packages..."
    install_packages
    print_success "System packages installed"

    # Install oh-my-zsh
    install_oh_my_zsh

    # Install zsh plugins
    install_zsh_plugins

    # Create symlinks
    create_symlinks

    # Change default shell
    change_shell

    echo ""
    echo "========================================"
    echo "       Installation Complete!           "
    echo "========================================"
    echo ""
    print_info "Next steps:"
    echo "  1. Log out and log back in (or run 'zsh')"
    echo "  2. Open nvim - plugins will install automatically"
    echo "  3. Run :checkhealth in nvim to verify setup"
    echo ""
}

main "$@"
