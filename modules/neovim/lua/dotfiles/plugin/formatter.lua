local M = {}

local formatter = require("formatter")
local plugin = require("dotfiles.plugin")

local function config_clang()
    return {
        -- clang-format
        function()
            return {
                exe = "clang-format",
                args = {"--assume-filename", vim.api.nvim_buf_get_name(0)},
                stdin = true,
                cwd = vim.fn.expand('%:p:h') -- Run clang-format in cwd of the file.
            }
        end
    }
end

-- lua-fmt https://github.com/Koihik/LuaFormatter
local function lua_format()
    return {exe = plugin.hererocks_bin() .. "/lua-format", stdin = true}
end

local function python_isort()
    return {exe = "isort", args = {"-rc"}, stdin = false}
end

local function python_yapf_or_black()
    if vim.fn.executable("black") == 1 then
        return {exe = "black", args = {"-"}, stdin = true}
    else
        return {exe = "yapf", stdin = true}
    end
end

local function config_python()
    local cfg = {}

    if vim.fn.executable("isort") == 1 then
        cfg[#cfg + 1] = python_isort
    end
    if vim.fn.executable("black") == 1 or vim.fn.executable("yapf") == 1 then
        cfg[#cfg + 1] = python_yapf_or_black
    end

    if #cfg == 0 then
        return nil
    end
    return cfg
end

function M.config()
    formatter.setup({
        logging = false,
        filetype = {
            c = config_clang(),
            cpp = config_clang(),
            lua = {lua_format},
            python = config_python(),
        },
    })
end

return M
