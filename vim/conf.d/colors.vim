" 256 Color setup
if has('nvim') || has("gui_running") || &t_Co == 256
    set background=dark

    if has('termguicolors')
        set termguicolors
    elseif has('nvim')
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif

    let g:airline_powerline_fonts = 1
    let g:tmuxline_powerline_separators = 1

    " Comment/Un-comment those based on your color scheme selection below
    " let g:palenight_terminal_italics=1
    " let g:gruvbox_italic=1
    let g:nord_italic = 1
    let g:nord_italic_comments = 1

    try
        " colorscheme solarized
        " colorscheme vividchalk
        " colorscheme palenight
        " colorscheme gruvbox

        " The nord color scheme requires the respective color scheme for
        " your terminal emulator.
        " See https://github.com/arcticicestudio/nord-vim for a list
        " of supported terminals.
        colorscheme nord
    catch E185
        " Do nothing.
    endtry

    " Highlight the 80th colum
    set colorcolumn=80

    " Width of line number column
    set numberwidth=5
    set number
else
    set background=dark
    colorscheme default
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if has('nvim') || has("gui_running") || &t_Co > 2
  syntax on
  set hlsearch
endif
