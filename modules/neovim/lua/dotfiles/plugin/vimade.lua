local M = {}

local vimcompat = require("dotfiles.vimcompat")

function M.config()
    vim.g.vimade_running = 0
    vim.g.vimade = {
        fadelevel = 0.6,
        enablefocusfading = 1,
        enabletreesitter = 1,
    }

    -- See: https://github.com/TaDaa/vimade/issues/38
    --
    -- We use g:vimade_running instead of relying on vimplug to lazy load the
    -- plugin.
    vimcompat.augroup("dotfiles_vimade", {
        [[
            WinNew,BufNew * ++once if g:vimade_running != 1 |
                execute 'VimadeEnable' |
            endif
        ]],
        [[
            FocusLost * ++once if g:vimade_running != 1 |
                 execute 'VimadeEnable' |
                 call vimade#FocusLost() |
            endif
        ]]
    })
end

return M
