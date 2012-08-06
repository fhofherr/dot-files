" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Maintainer:   Ferdinand Hofherr
" Last Change:  2012 Aug 02

set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "fhlight"

hi Normal                                                                         guifg=black       guibg=#FFFFF0
hi Comment    term=bold       ctermfg=LightGrey                                   guifg=#74AC9F
hi Constant   term=underline  ctermfg=Blue                                        guifg=Blue
hi Special    term=bold       ctermfg=DarkMagenta                                 guifg=Red
hi Identifier term=underline  cterm=bold          ctermfg=Cyan   gui=bold         guifg=#255723
hi Statement  term=bold       ctermfg=DarkGreen                  gui=bold         guifg=black
hi PreProc    term=underline  ctermfg=LightBlue                                   guifg=#828BC2
hi Type       term=underline  ctermfg=DarkGreen                  gui=bold         guifg=#255723
hi Function   term=bold       ctermfg=Black                                       guifg=#255723
hi Cursor                     ctermfg=black       ctermbg=green                   guifg=black        guibg=#43586A
hi Visual                     ctermfg=lightblue   ctermbg=black                   guifg=black        guibg=lightblue
hi MatchParen term=bold       ctermfg=red                        gui=bold         guifg=red          guibg=#F4F4FF
hi ColorColumn                                                                    guifg=black        guibg=#ACBFAC
hi LineNr     term=bold       ctermfg=DarkYellow                                  guifg=Yellow       guibg=#ACBFAC

"" This influences the color of if, for, while, etc.
hi Repeat     term=underline  ctermfg=DarkGreen                  gui=bold         guifg=Black
hi Operator                   ctermfg=DarkGreen                  gui=bold         guifg=Black
hi Ignore                     ctermfg=black                                       guifg=bg
hi Error      term=reverse    ctermbg=Red         ctermfg=White                   guifg=White        guibg=Red
hi Todo       term=standout   ctermbg=DarkYellow  ctermfg=Black gui=bold          guifg=fg           guibg=NONE

" Common groups that link to default highlighting.
" You can specify other highlighting easily.
hi link String  Constant
hi link Character   Constant
hi link Number  Constant
hi link Boolean Constant
hi link Float       Number
hi link Conditional Repeat
hi link Label       Statement
hi link Keyword Statement
hi link Exception   Statement
hi link Include PreProc
hi link Define  PreProc
hi link Macro       PreProc
hi link PreCondit   PreProc
hi link StorageClass    Type
hi link Structure   Type
hi link Typedef Type
hi link Tag     Special
hi link SpecialChar Special
hi link Delimiter   Special
hi link SpecialComment Special
hi link Debug       Special
