
source ~/.zsh/zsh-defer/zsh-defer.plugin.zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export EDITOR="vim"

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY

# If there is no *.zsh.zwc or it's older than *.zsh, compile *.zsh into *.zsh.zwc.
source-compiled() {
  if [[ ! $1.zwc -nt $1 ]]; then
    zcompile $1
  fi
  source $1
}

alias config="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.zsh/.p10k.zsh ]] || source-compiled ~/.zsh/.p10k.zsh

# ZSH-AUTOSUGGEST Configuration
zsh-defer source-compiled ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1

bindkey '^I^I' autosuggest-accept
bindkey '^\r' autosuggest-execute

# ZSH FSH Configuration
zsh-defer source-compiled ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

[ -f ~/.zsh/.fzf.zsh ] && source-compiled ~/.zsh/.fzf.zsh

# History searching with arrow keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward