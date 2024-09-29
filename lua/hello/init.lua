-- lua/hello/init.lua

local M = {}
local function hello()
	print("Hello from the hello plugin!")
end
function M.setup()
	vim.api.nvim_create_user_command("Hello", hello, { range = true })
end

return M
