# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="clean"

# Which plugins would you like to load?
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor
export EDITOR='nvim'
export VISUAL='nvim'

# Aliases
alias vim='nvim'
alias v='nvim'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Git aliases (beyond oh-my-zsh git plugin)
alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline -20'

# Custom SSH aliases
# Layout: 1 pane z neovim (lewo) + 2 panes z zsh (prawo, pionowo podzielone)
alias dev-b3='ssh -t root@dev-syneo.b3x.uk '"'"'
if ! tmux has-session -t dev 2>/dev/null; then
  tmux new-session -d -s dev -n main "docker exec -it c820720c4a19 /bin/zsh"
  tmux send-keys -t dev:main.0 "cd /workspace && nvim" C-m
  tmux split-window -h -t dev:main -p 33 "docker exec -it c820720c4a19 /bin/zsh"
  tmux send-keys -t dev:main.1 "cd /workspace" C-m
  tmux split-window -v -t dev:main.1 "docker exec -it c820720c4a19 /bin/zsh"
  tmux send-keys -t dev:main.2 "cd /workspace" C-m
  tmux select-pane -t dev:main.0
fi
tmux attach-session -t dev
'"'"''

# FZF configuration (if installed via git)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Quick dotfiles setup (run on remote server)
dotfiles-install() {
  git clone https://github.com/mrnetforge/dotfiles.git ~/dotfiles 2>/dev/null || (cd ~/dotfiles && git pull)
  cd ~/dotfiles && ./install.sh
}
