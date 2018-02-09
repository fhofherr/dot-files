" ---------------------------------------------------------------------------
"
" Rainbow Parentheses
"
" ---------------------------------------------------------------------------

" Enable rainbow parentheses for Clojure buffers
augroup rainbow_parentheses
  au!
  au BufEnter clojure RainbowParenthesesActivate
  au BufEnter clojure RainbowParenthesesLoadRound
  au BufEnter clojure RainbowParenthesesLoadSquare
  au BufEnter clojure RainbowParenthesesLoadBraces
augroup END
