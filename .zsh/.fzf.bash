# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$HOME/.zsh/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.zsh/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.zsh/fzf/shell/key-bindings.bash"
