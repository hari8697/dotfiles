# ===========================
# Antidote
# ===========================

source ~/.antidote/antidote.zsh

antidote load ~/.config/zsh/.zsh_plugins.txt

# ===========================
# History
# ===========================

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY

# ===========================
# Better Completion
# ===========================

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# ===========================
# Aliases
# ===========================

alias cls='clear'

# Better ls
alias ls='eza --icons'
alias ll='eza -lah --icons --git'
alias la='eza -a --icons'
alias tree='eza --tree --icons'

# zoxide
eval "$(zoxide init zsh)"

# fzf
source <(fzf --zsh)

# Fastfetch
if [[ -o interactive ]] && command -v fastfetch >/dev/null; then
    fastfetch
fi

export PATH="$HOME/.local/bin:$PATH"

# Starship
eval "$(starship init zsh)"
