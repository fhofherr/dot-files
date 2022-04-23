local M = {}

local ls = require("luasnip")

local s = ls.snippet
local f = ls.function_node

function M.load()
	ls.add_snippets("all", {
		s({ trig = "now", descr = "Current time" }, {
			f(function()
				return os.date("%H:%M:%S")
			end),
		}),

		s({ trig = "datetime", descr = "Current date and time" }, {
			f(function()
				return os.date("%Y-%m-%d %H:%M:%S")
			end),
		}),
	})
end

return M
