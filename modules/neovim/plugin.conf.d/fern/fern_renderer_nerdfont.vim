if !dotfiles#plugin#selected('fern-renderer-nerdfont.vim') || exists('g:did_cfg_fern_renderer_nerdfont_vim')
    finish
endif
let g:did_cfg_fern_renderer_nerdfont_vim = 1

if !dotfiles#plugin#selected('fern.vim')
    finish
endif

let g:fern#renderer = "nerdfont"
