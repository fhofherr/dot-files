" ---------------------------------------------------------------------------
"
" Rainbow Parentheses
"
" ---------------------------------------------------------------------------
if !has_key(g:plugs, 'rainbow_parentheses')
    finish
endif

" Enable rainbow parentheses for Clojure buffers
augroup rainbow_parentheses
  au!
  au BufEnter *.clj,*.cljc,*.cljs RainbowParenthesesActivate
  au BufEnter *.clj,*.cljc,*.cljs RainbowParenthesesLoadRound
  au BufEnter *.clj,*.cljc,*.cljs RainbowParenthesesLoadSquare
  au BufEnter *.clj,*.cljc,*.cljs RainbowParenthesesLoadBraces
augroup END
