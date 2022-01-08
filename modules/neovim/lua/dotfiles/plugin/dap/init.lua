local M = {}

local dap = require("dap")
local dap_go = require("dap-go")
local dap_ui = require("dapui")
local dap_vt = require("nvim-dap-virtual-text")

local function set_breakpoint(cmd_args, fn)
	if cmd_args.args and cmd_args ~= "" then
		return fn(cmd_args.args)
	end
	return fn()
end

local function set_logpoint(cmd_args, fn)
	return fn(nil, nil, cmd_args.args)
end

local function set_breakpoint_cmd(cmd_args)
	set_breakpoint(cmd_args, dap.set_breakpoint)
end

local function toggle_breakpoint_cmd(cmd_args)
	set_breakpoint(cmd_args, dap.toggle_breakpoint)
end

local function set_logpoint_cmd(cmd_args)
	set_logpoint(cmd_args, dap.set_breakpoint)
end

local function toggle_logpoint_cmd(cmd_args)
	set_logpoint(cmd_args, dap.toggle_breakpoint)
end

local function debug_test()
	local fns = {
		go = dap_go.debug_test,
	}
	local ft = vim.api.nvim_buf_get_option(0, "filetype")
	local fn = fns[ft]
	if not fn then
		vim.api.nvim_echo("Unsupported file type: " .. ft)
		return
	end
	fn()
end

local function add_commands()
	vim.api.nvim_add_user_command("DapSetBreakpoint", set_breakpoint_cmd, { nargs = "*", force = true })
	vim.api.nvim_add_user_command("DapToggleBreakpoint", toggle_breakpoint_cmd, { nargs = "*", force = true })
	vim.api.nvim_add_user_command("DapSetLogpoint", set_logpoint_cmd, { nargs = 1, force = true })
	vim.api.nvim_add_user_command("DapToggleLogpoint", toggle_logpoint_cmd, { nargs = 1, force = true })

	vim.api.nvim_add_user_command("DapDebugTest", debug_test, { force = true })
	vim.api.nvim_add_user_command("DapRunLast", function()
		dap.run_last()
	end, { force = true })
	vim.api.nvim_add_user_command("DapREPLOpen", function()
		dap.repl.open()
	end, { force = true })

	vim.api.nvim_add_user_command("DapStepInto", function()
        dap.step_into({askForTargets = true})
    end, { force = true })
	vim.api.nvim_add_user_command("DapStepOut", function()
        dap.step_out()
    end, { force = true })
	vim.api.nvim_add_user_command("DapStepOver", function()
        dap.step_over()
    end, { force = true })
end

local function register_ui()
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dap_ui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dap_ui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dap_ui.close()
	end
end

function M.setup()
	dap_go.setup()
	dap_ui.setup({
		sidebar = {
			size = 60,
		},
	})
	dap_vt.setup()

	register_ui()
	add_commands()
end

return M
