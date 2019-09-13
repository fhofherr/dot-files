if [ -f "$HOME/.fzf.zsh" ]; then
   source "$HOME/.fzf.zsh"

   # Re-bind the fzf-file-widget from ^T to ^P. This makes it work just like
   # in my vim configuration.
   bindkey '^P' fzf-file-widget

   if command -v bat > /dev/null 2>&1
   then
       export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers,changes  --line-range=:15 --color always {} 2> /dev/null'"
   fi
fi
