local M = {}

local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node
local i = ls.insert_node
local t = ls.text_node
local rep = require("luasnip.extras").rep
local l = require("luasnip.extras").lambda
local fmta = require("luasnip.extras.fmt").fmta

-- TODO document and move to utilities package
local function last_word(args)
	local res = vim.split(args[1][1], " ", { plain = true })

	if res then
		return res[#res]
	end
	return args[1][1]
end

local function go_pkg_name()
	local file_name = vim.fn.expand("%:t:r")
	local dir_name = vim.fn.expand("%:p:h:t")

	if vim.endswith(file_name, "_test") and not vim.endswith(file_name, "_internal_test") then
		return dir_name .. "_test"
	end
	return dir_name
end

function M.load()
	-- stylua: ignore start
	ls.add_snippets("go", {
		s({ trig = "pkg", descr = "Golang package definition" }, {
			t("package "), f(go_pkg_name),
		}),
		s({ trig = "*t", descr = "Add *testing.T" }, {
			t("t *testing.T"),
		}),
		s({ trig = "tf", descr = "Test function" }, {
			t("func Test"), i(1, "Name"), t({ "(t *testing.T) {", "\t" }),
			i(0),
			t({ "", "}" }),
		}),
		s({ trig = "tt", descr = "Test table" }, fmta([[
		<tab_name> := []struct{
			<test_name> string
			<>
		}{
			{
				<>
			},
		}

		for _, <> := range <> {
			<> := <>
			t.Run(<>.<>, func(t *testing.T) {
				<>
			}
		}
		]], {
			tab_name=i(1, "tests"),
			test_name=i(2, "name"),
			i(3, "fields"),
			i(4, "values"),
			i(5, "tt"),
			rep(1),
			f(last_word, 5),
			f(last_word, 5),
			f(last_word, 5),
			l(l._1:gsub("\t+", ""), 2),
			i(0, "code"),
		})),
	})
	-- stylua: ignore end
end

return M
