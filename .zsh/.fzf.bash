# Setup fzf
# ---------
if [[ ! "$PATH" == */home/ben/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/ben/.zsh/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/ben/.zsh/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/ben/.zsh/fzf/shell/key-bindings.bash"
