local M = {}

local snippy = require("snippy")

function M.expand_or_jump_fwd()
	if snippy.can_expand_or_advance() then
		snippy.expand_or_advance()
	end
end

function M.jump_back()
	if snippy.can_jump(-1) then
		snippy.previous()
	end
end

function M.config()
	snippy.setup({})
end

return M
