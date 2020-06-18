" ---------------------------------------------------------------------------
"
" vimwiki common options
"
" ---------------------------------------------------------------------------
if !dotfiles#plugin#selected('vimwiki') || exists('g:did_cfg_vimwiki')
    finish
endif
let g:did_cfg_vimwiki = 1

let g:vimwiki_global_ext = 0
let g:vimwiki_list = [{
            \    'path': '~/Nextcloud/wiki',
            \    'syntax': 'markdown',
            \    'ext': '.wiki.md'
            \}]
