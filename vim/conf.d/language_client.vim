" ---------------------------------------------------------------------------
"
" LanguageClient
"
" ---------------------------------------------------------------------------
" See https://github.com/autozimu/LanguageClient-neovim

let g:LanguageClient_autoStart = 1

let g:LanguageClient_serverCommands = {}

if executable('pyls')
    let g:LanguageClient_serverCommands.python3 = ['pyls']
    let g:LanguageClient_serverCommands.python2 = ['pyls']
endif

set completefunc=LanguageClient#complete
set formatexpr=LanguageClient_textDocument_rangeFormatting()
