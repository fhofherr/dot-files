local M = {}

-- Based on https://github.com/glepnir/galaxyline.nvim/blob/main/example/eviline.lua

local plugin = require("dotfiles.plugin")
local galaxyline = plugin.safe_require("galaxyline")
local fileinfo = plugin.safe_require("galaxyline.provider_fileinfo")
local vcs = plugin.safe_require("galaxyline.provider_vcs")

-- Gruvbox dark colors according to palette at https://github.com/gruvbox-community/gruvbox
local colors = {
    bg = "#282828",
    fg = "#ebdbb2",

    darkred = "#cc241d",
    darkgreen = "#98971a",
    darkyellow = "#d79921",
    darkblue = "#458588",
    darkpurple = "#b16286",
    darkaqua = "#689d6a",
    darkorange = "#d65d0e",
    darkgray = "#a89984",

    gray = "#928374",
    red = "#fb4934",
    green = "#b8bb26",
    yellow = "#fabd2f",
    blue = "#83a598",
    purple = "#d3869b",
    aqua = "#8ec07c",
    orange = "#fe8019",
}

local function buffer_not_empty()
    if vim.fn.empty(vim.fn.expand("%:t")) ~= 1 then
        return true
    end
    return false
end

local function checkwidth()
    local squeeze_width  = vim.fn.winwidth(0) / 2
    if squeeze_width > 40 then
        return true
    end
    return false
end

local left_components = {
    {
        ViMode = {
            provider = function()
                -- auto change color according the vim mode
                local mode_color = {
                    c = colors.red,
                    ce = colors.red,
                    [""] = colors.blue,
                    [""] = colors.orange,
                    ["!"] = colors.red,
                    cv = colors.red,
                    ic = colors.yellow,
                    i = colors.green,
                    n = colors.darkpurple,
                    no = colors.darkpurple,
                    R = colors.aqua,
                    ["r?"] = colors.darkblue,
                    r = colors.darkblue,
                    rm = colors.darkblue,
                    Rv = colors.aqua,
                    s = colors.orange,
                    S = colors.orange,
                    t = colors.red,
                    v = colors.blue,
                    V = colors.blue,
                }
                vim.api.nvim_command("hi GalaxyViMode guifg="..mode_color[vim.fn.mode()])
                return "  "
            end,
            highlight = {colors.red,colors.bg,"bold"},
        },
    },
    {
        GitIcon = {
            provider = function() return "  " end,
            condition = vcs.check_git_workspace,
            separator = " ",
            separator_highlight = {"NONE",colors.bg},
            highlight = {colors.yellow,colors.bg,"bold"},
        }
    },
    {
        GitBranch = {
            provider = "GitBranch",
            condition = vcs.check_git_workspace,
            highlight = {colors.yellow,colors.bg,"bold"},
        }
    },
    {
        DiffAdd = {
            provider = "DiffAdd",
            condition = checkwidth,
            icon = "  ",
            highlight = {colors.green,colors.bg},
        }
    },
    {
        DiffModified = {
            provider = "DiffModified",
            condition = checkwidth,
            icon = " 柳",
            highlight = {colors.orange,colors.bg},
        }
    },
    {
        DiffRemove = {
            provider = "DiffRemove",
            condition = checkwidth,
            icon = "  ",
            highlight = {colors.red,colors.bg},
        }
    },
}

local short_line_left_components = {
    {
        BufferType = {
            provider = "FileTypeName",
            separator = " ",
            separator_highlight = {"NONE",colors.bg},
            highlight = {colors.blue,colors.bg,"bold"}
        }
    },
    {
        SFileName = {
            provider = function()
                local fname = fileinfo.get_current_file_name()
                for _,v in ipairs(galaxyline.short_line_list) do
                    if v == vim.bo.filetype then
                        return ""
                    end
                end
                return fname
            end,
            condition = buffer_not_empty,
            highlight = {colors.white,colors.bg,"bold"}
        }
    },
}

local right_components = {
    {
        DiagnosticError = {
            provider = "DiagnosticError",
            icon = "  ",
            highlight = {colors.red,colors.bg}
        }
    },
    {
        DiagnosticWarn = {
            provider = "DiagnosticWarn",
            icon = "  ",
            highlight = {colors.yellow,colors.bg},
        }
    },
    {
        DiagnosticHint = {
            provider = "DiagnosticHint",
            icon = "  ",
            highlight = {colors.darkblue,colors.bg},
        }
    },
    {
        DiagnosticInfo = {
            provider = "DiagnosticInfo",
            icon = "  ",
            highlight = {colors.blue,colors.bg},
        }
    },
    {
        FileIcon = {
            provider = "FileIcon",
            condition = buffer_not_empty,
            highlight = {fileinfo.get_file_icon_color,colors.bg},
        },
    },
    {
        FileName = {
            provider = {"FileName"},
            condition = buffer_not_empty,
            highlight = {colors.green,colors.bg,"bold"}
        }
    },
    {
        FileEncode = {
            provider = "FileEncode",
            highlight = {colors.darkblue,colors.bg,"bold"}
        }
    },
    {
        FileFormat = {
            provider = "FileFormat",
            separator = " ",
            separator_highlight = {"NONE",colors.bg},
            highlight = {colors.darkblue,colors.bg,"bold"}
        }
    },
    {
        FileSize = {
            provider = "FileSize",
            separator = " ",
            separator_highlight = {"NONE",colors.bg},
            condition = buffer_not_empty,
            highlight = {colors.fg,colors.bg}
        }
    },
    {
        LineInfo = {
            provider = "LineColumn",
            separator = " ",
            separator_highlight = {"NONE",colors.bg},
            highlight = {colors.fg,colors.bg},
        },
    },
    {
        PerCent = {
            provider = "LinePercent",
            separator = " ",
            separator_highlight = {"NONE",colors.bg},
            highlight = {colors.fg,colors.bg,"bold"},
        }
    },
}

local short_line_right_components = {
    {
        BufferIcon = {
            provider= "BufferIcon",
            highlight = {colors.fg,colors.bg}
        }
    },
}

function M.setup()
    if not galaxyline then
        return
    end
    local gls = galaxyline.section
    galaxyline.short_line_list = {}

    gls.left = left_components
    gls.short_line_left = short_line_left_components
    gls.right = right_components
    gls.short_line_right = short_line_right_components
end

return M
