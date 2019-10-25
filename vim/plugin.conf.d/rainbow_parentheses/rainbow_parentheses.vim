" ---------------------------------------------------------------------------
"
" Rainbow Parentheses
"
" ---------------------------------------------------------------------------
if !dotfiles#plugin#selected('rainbow_parentheses') || exists('g:did_cfg_rainbow_parentheses')
    finish
endif
let g:did_cfg_rainbow_parentheses = 1

" Enable rainbow parentheses for Clojure buffers
augroup rainbow_parentheses
  au!
  au BufEnter *.clj,*.cljc,*.cljs RainbowParenthesesActivate
  au BufEnter *.clj,*.cljc,*.cljs RainbowParenthesesLoadRound
  au BufEnter *.clj,*.cljc,*.cljs RainbowParenthesesLoadSquare
  au BufEnter *.clj,*.cljc,*.cljs RainbowParenthesesLoadBraces
augroup END
