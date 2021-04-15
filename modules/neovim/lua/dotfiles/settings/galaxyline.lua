local M = {}

-- Based on https://github.com/glepnir/galaxyline.nvim/blob/main/example/eviline.lua

local plugin = require("dotfiles.plugin")
local galaxyline = plugin.safe_require("galaxyline")
local fileinfo = plugin.safe_require("galaxyline.provider_fileinfo")
local cond = plugin.safe_require("galaxyline.condition")

-- Colors are based on base16
-- See: https://github.com/chriskempson/base16
local color_schemes = {
    dracula = {
        -- Obtained form: https://github.com/dracula/base16-dracula-scheme/blob/master/dracula.yaml
        base00 = "#282936", -- background
        base01 = "#3a3c4e",
        base02 = "#4d4f68",
        base03 = "#626483",
        base04 = "#62d6e8",
        base05 = "#e9e9f4", -- foreground
        base06 = "#f1f2f8",
        base07 = "#f7f7fb",
        base08 = "#ea51b2",
        base09 = "#b45bcf",
        base0A = "#00f769",
        base0B = "#ebff87",
        base0C = "#a1efe4",
        base0D = "#62d6e8",
        base0E = "#b45bcf",
        base0F = "#00f769",
    },
    ["gruvbox-dark"] = {
        -- Obtained from: https://github.com/dawikur/base16-gruvbox-scheme/blob/master/gruvbox-dark-medium.yaml
        base00 = "#282828",  -- ----
        base01 = "#3c3836",  -- ---
        base02 = "#504945",  -- --
        base03 = "#665c54",  -- -
        base04 = "#bdae93",  -- +
        base05 = "#d5c4a1",  -- ++
        base06 = "#ebdbb2",  -- +++
        base07 = "#fbf1c7",  -- ++++
        base08 = "#fb4934",  -- red
        base09 = "#fe8019",  -- orange
        base0A = "#fabd2f",  -- yellow
        base0B = "#b8bb26",  -- green
        base0C = "#8ec07c",  -- aqua/cyan
        base0D = "#83a598",  -- blue
        base0E = "#d3869b",  -- purple
        base0F = "#d65d0e",  -- brown
    },
    ["gruvbox-light"] = {
        -- Obtained from: https://github.com/dawikur/base16-gruvbox-scheme/blob/master/gruvbox-light-medium.yaml
        base00 = "#fbf1c7", -- ----
        base01 = "#ebdbb2", -- ---
        base02 = "#d5c4a1", -- --
        base03 = "#bdae93", -- -
        base04 = "#665c54", -- +
        base05 = "#504945", -- ++
        base06 = "#3c3836", -- +++
        base07 = "#282828", -- ++++
        base08 = "#9d0006", -- red
        base09 = "#af3a03", -- orange
        base0A = "#b57614", -- yellow
        base0B = "#79740e", -- green
        base0C = "#427b58", -- aqua/cyan
        base0D = "#076678", -- blue
        base0E = "#8f3f71", -- purple
        base0F = "#d65d0e", -- brown
    },
    ["onehalf-dark"] = {
        -- Obtained from: https://github.com/LalitMaganti/base16-onedark-scheme/blob/master/onedark.yaml
        base00 = "#282c34",
        base01 = "#353b45",
        base02 = "#3e4451",
        base03 = "#545862",
        base04 = "#565c64",
        base05 = "#abb2bf",
        base06 = "#b6bdca",
        base07 = "#c8ccd4",
        base08 = "#e06c75",
        base09 = "#d19a66",
        base0A = "#e5c07b",
        base0B = "#98c379",
        base0C = "#56b6c2",
        base0D = "#61afef",
        base0E = "#c678dd",
        base0F = "#be5046",
    },
    ["onehalf-light"] = {
        -- Obtained from: https://github.com/purpleKarrot/base16-one-light-scheme/blob/master/one-light.yaml
       base00 = "#fafafa",
       base01 = "#f0f0f1",
       base02 = "#e5e5e6",
       base03 = "#a0a1a7",
       base04 = "#696c77",
       base05 = "#383a42",
       base06 = "#202227",
       base07 = "#090a0b",
       base08 = "#ca1243",
       base09 = "#d75f00",
       base0A = "#c18401",
       base0B = "#50a14f",
       base0C = "#0184bc",
       base0D = "#4078f2",
       base0E = "#a626a4",
       base0F = "#986801",
    },
}

local colors = color_schemes[vim.env.DOTFILES_COLOR_SCHEME]
if colors == nil then
    colors = color_schemes["gruvbox-dark"]
end

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
                    c = colors.base08,
                    ce = colors.base08,
                    [""] = colors.base0D,
                    [""] = colors.base09,
                    ["!"] = colors.base08,
                    cv = colors.base08,
                    ic = colors.base0A,
                    i = colors.base0B,
                    n = colors.base0E,
                    no = colors.base0E,
                    R = colors.base0C,
                    ["r?"] = colors.base0D,
                    r = colors.base0D,
                    rm = colors.base0D,
                    Rv = colors.base0C,
                    s = colors.base09,
                    S = colors.base09,
                    t = colors.base08,
                    v = colors.base0D,
                    V = colors.base0D,
                }
                vim.api.nvim_command("hi GalaxyViMode guifg="..mode_color[vim.fn.mode()])
                return "  "
            end,
            highlight = {colors.base08,colors.base01,"bold"},
        },
    },
    {
        GitIcon = {
            provider = function() return "  " end,
            condition = cond.check_git_workspace,
            separator_highlight = {"NONE",colors.base01},
            highlight = {colors.base0A,colors.base01,"bold"},
        }
    },
    {
        DiffAdd = {
            provider = "DiffAdd",
            condition = cond.check_git_workspace,
            icon = "  ",
            highlight = {colors.base0B,colors.base01},
        }
    },
    {
        DiffModified = {
            provider = "DiffModified",
            condition = cond.check_git_workspace,
            icon = " 柳",
            highlight = {colors.base09,colors.base01},
        }
    },
    {
        DiffRemove = {
            provider = "DiffRemove",
            condition = cond.check_git_workspace,
            icon = "  ",
            highlight = {colors.base08,colors.base01},
        }
    },
    {
        GitBranch = {
            provider = "GitBranch",
            condition = function()
                return cond.check_git_workspace() and checkwidth()
            end,
            highlight = {colors.base0A,colors.base01,"bold"},
        }
    },
}

local short_line_left_components = {
    {
        SGitIcon = {
            provider = function() return "  " end,
            condition = cond.check_git_workspace,
            separator_highlight = {"NONE",colors.base01},
            highlight = {colors.base0A,colors.base01,"bold"},
        }
    },
    {
        SDiffAdd = {
            provider = "DiffAdd",
            icon = "  ",
            condition = cond.check_git_workspace,
            highlight = {colors.base0B,colors.base01},
        }
    },
    {
        SDiffModified = {
            provider = "DiffModified",
            icon = " 柳",
            condition = cond.check_git_workspace,
            highlight = {colors.base09,colors.base01},
        }
    },
    {
        SDiffRemove = {
            provider = "DiffRemove",
            icon = "  ",
            condition = cond.check_git_workspace,
            highlight = {colors.base08,colors.base01},
        }
    },
}

local right_components = {
    {
        DiagnosticError = {
            provider = "DiagnosticError",
            icon = "  ",
            highlight = {colors.base08,colors.base01}
        }
    },
    {
        DiagnosticWarn = {
            provider = "DiagnosticWarn",
            icon = "  ",
            highlight = {colors.base0A,colors.base01},
        }
    },
    {
        DiagnosticHint = {
            provider = "DiagnosticHint",
            icon = "  ",
            highlight = {colors.base0D,colors.base01},
        }
    },
    {
        DiagnosticInfo = {
            provider = "DiagnosticInfo",
            icon = "  ",
            highlight = {colors.base0D,colors.base01},
        }
    },
    {
        FileIcon = {
            provider = "FileIcon",
            condition = buffer_not_empty,
            highlight = {fileinfo.get_file_icon_color,colors.base01},
        },
    },
    {
        FileName = {
            provider = {"FileName"},
            condition = buffer_not_empty,
            highlight = {colors.base0B,colors.base01,"bold"}
        }
    },
    {
        FileEncode = {
            provider = "FileEncode",
            highlight = {colors.base0D,colors.base01,"bold"}
        }
    },
    {
        FileFormat = {
            provider = "FileFormat",
            separator = " ",
            separator_highlight = {"NONE",colors.base01},
            highlight = {colors.base0D,colors.base01,"bold"}
        }
    },
    {
        FileSize = {
            provider = "FileSize",
            separator = " ",
            separator_highlight = {"NONE",colors.base01},
            condition = buffer_not_empty,
            highlight = {colors.base06,colors.base01}
        }
    },
    {
        LineInfo = {
            provider = "LineColumn",
            separator = " ",
            separator_highlight = {"NONE",colors.base01},
            highlight = {colors.base06,colors.base01},
        },
    },
    {
        PerCent = {
            provider = "LinePercent",
            separator = " ",
            separator_highlight = {"NONE",colors.base01},
            highlight = {colors.base06,colors.base01,"bold"},
        }
    },
    {
        GetLspClient = {
            provider = "GetLspClient",
            highlight = {colors.base0D,colors.base01},
        }
    },
}

local short_line_right_components = {
    {
        BufferIcon = {
            provider= "BufferIcon",
            highlight = {colors.base06,colors.base01}
        }
    },
    {
        SFileIcon = {
            provider = "FileIcon",
            condition = buffer_not_empty,
            highlight = {fileinfo.get_file_icon_color,colors.base01},
        },
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
            highlight = {colors.white,colors.base01,"bold"}
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
