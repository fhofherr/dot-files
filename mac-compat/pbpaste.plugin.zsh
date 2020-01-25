if command -v xclip > /dev/null 2>&1; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

if command -v xdg-open > /dev/null 2>&1; then
    alias open='xdg-open'
fi
