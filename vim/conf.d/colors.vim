if has('termguicolors')
    set termguicolors
elseif has('nvim')
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" 256 Color setup
if has('nvim') || has("gui_running") || &t_Co == 256
    " Highlight the 80th and 120th columns
    set colorcolumn=80,120

    " Width of line number column
    set numberwidth=5
    set number

    " Comment/Un-comment those based on your color scheme selection below
    " let g:palenight_terminal_italics=1
    " let g:gruvbox_italic=1
    " let g:nord_italic = 1
    " let g:nord_italic_comments = 1

    " let g:pencil_higher_contrast_ui = 0
    " let g:pencil_neutral_code_bg = 1
    " let g:pencil_terminal_italics = 1
    " let g:airline_theme = 'pencil'

    try
        " colorscheme solarized
        " colorscheme vividchalk

        " The palenight color scheme requires the respective color scheme for
        " your terminal emulator.
        " See https://github.com/JonathanSpeek/palenight-iterm2 for iterm2.
        "colorscheme palenight

        " The gruvbox color scheme requires the respective color scheme for
        " your terminal emulator.
        " See https://github.com/morhetz/gruvbox-contrib for a list
        " of supported terminals.
        " colorscheme gruvbox

        " The nord color scheme requires the respective color scheme for
        " your terminal emulator.
        " See https://github.com/arcticicestudio/nord-vim for a list
        " of supported terminals.
        " colorscheme nord

        " The pencil color scheme requires the respective color scheme for
        " your terminal emulator.
        " See https://github.com/mattly/iterm-colors-pencil for iterm2.
        " colorscheme pencil

        if has_key(g:plugs, 'dracula')
            set background=dark
            colorscheme dracula
        endif
        if has_key(g:plugs, 'vim-colors-solarized')
            set background=light
            colorscheme solarized
        endif
    catch E185
        " Do nothing.
    endtry
else
    colorscheme default
endif
