
# Check if query update has been set and prompt for updates if so
if [[ $QUERY_UPDATE -eq 1 ]]; then
    ~/.update_dotfiles
    export QUERY_UPDATE=0
fi

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
setopt CORRECT_ALL

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

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1

bindkey '^I^I' autosuggest-accept


# ZSH FSH Configuration
zsh-defer source-compiled ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# FZF Configuration
[ -f ~/.zsh/.fzf.zsh ] && source-compiled ~/.zsh/.fzf.zsh
if (which fd || which fdfind) > /dev/null; then
    export FZF_DEFAULT_COMMAND="fd --type file --color=always --follow --hidden --exclude .git"
    export FZF_CRTL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# Link fzf in vim for fzf.vim to use
if [ ! -L ~/.vim/pack/git-plugins/start/fzf ]; then
    ln -s ~/.zsh/fzf ~/.vim/pack/git-plugins/start/fzf
fi

export FZF_PREVIEW_COMMAND="bat --style=numbers,changes --wrap never --color always {} || cat {} || tree -C {}"

# ZSH-Z
zsh-defer source-compiled ~/.zsh/zsh-z/zsh-z.plugin.zsh
zstyle ':completion:*' menu select

# Add diff-so-fancy to path
export PATH="$PATH:$HOME/.zsh/diff-so-fancy"

# zsh-history-substring-search customization
source-compiled ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=red,bold'

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Aliases
alias fd="fdfind"
alias python="python3"
alias pip="python -m pip"
alias dj-run='dj-activate; python manage.py runserver'
alias dj-migrate='dj-activate; python manage.py migrate'
alias dj-makemigrations='dj-activate; python manage.py makemigrations'
alias dj-shell='dj-activate; python manage.py shell'

# Functions
# Open venv with pipenv if available or with normal virtualenv method otherwise
function dj-activate () {
    if type "pipenv" > /dev/null 2>&1; then
        pipenv shell
    elif [ -z "$VIRTUAL_ENV" ]; then
        source venv/bin/activate
    fi
}

autoload -U compinit && compinit
