-- lua/browse/init.lua
local M = {}
--[[ local function extractLink(query)
	local link = query
	if string.find(link, "//") then
		link = link:match("//(.+)") -- Extract part after '//' using pattern matching
		if string.find(link, "/") then
			link = link:match("([^/]+)") -- Extract part before the first '/'
		end
	else
		if string.find(link, "/") then
			link = link:match("([^/]+)") -- Extract part before the first '/'
		end
	end
	return link
end ]]
--[[ local function ping(url)
	local cmd = string.format("ping -c 1 %s > /dev/null 2>&1", extractLink(url))
	local result = os.execute(cmd)
	return result == 0 -- returns true if the ping is successful
end ]]
--[[ local function get_current_mode()
	-- Switch to normal mode and get the current mode
	vim.cmd("normal! gv") -- Reselect the visual selection
	local mode = vim.api.nvim_get_mode().mode -- Get current mode
	-- print("mode " .. mode)
	return mode
end ]]
local function vExtractSelectedText()
	-- Get the start and end positions of the visual selection
	local vstart = vim.fn.getpos("'<")
	local vend = vim.fn.getpos("'>")
	local rowStart = vstart[2]
	local rowEnd = vend[2]
	local colStart = vstart[3]
	local colEnd = vend[3]
	-- Get the selected lines
	local lines = vim.fn.getline(rowStart, rowEnd)
	-- print("lines" .. vim.inspect(lines))
	local selected_text = ""
	if rowStart == rowEnd then
		selected_text = lines[1]:sub(colStart, colEnd)
	else
		selected_text = lines[1]:sub(colStart)
		for i = 2, #lines - 1 do
			selected_text = selected_text .. "\n" .. lines[i]
		end
		selected_text = selected_text .. "\n" .. lines[#lines]:sub(1, colEnd)
	end
	return selected_text
end
-- local function getSelectedText()
-- local current_mode = get_current_mode()
-- if current_mode == "v" then
-- local selected_text = vExtractSelectedText()
-- return selected_text
-- else
-- local line = vim.api.nvim_get_current_line()
-- local current_word = vim.fn.expand("<c-word>")
-- print("current_word" .. current_word)
-- return current_word
-- end
-- end
function M.googleQuery()
	local query = vExtractSelectedText()
	if query == "" then
		print("unable to getSelectedText")
		return
	end
	-- print("query " .. query)
	-- local isValidLink = ping(query)
	-- if isValidLink == false then
	query = "https://google.com/search?q=" .. query
	-- end
	vim.fn.jobstart({ "google-chrome-stable", query })
end

local function getLink()
	-- Get the current line under the cursor
	local line = vim.api.nvim_get_current_line()

	-- Get the cursor position
	local cursor_col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- 1-based indexing

	-- Find the start position (the space before the cursor)
	local start_pos = cursor_col
	while start_pos > 1 and line:sub(start_pos - 1, start_pos - 1) ~= " " do
		start_pos = start_pos - 1
	end

	-- Find the end position (the space after the cursor)
	local end_pos = cursor_col
	while end_pos <= #line and line:sub(end_pos, end_pos) ~= " " do
		end_pos = end_pos + 1
	end

	-- Extract the URL or text between the spaces
	local link = line:sub(start_pos, end_pos - 1)

	-- Print or return the link
	return link
end

function M.gotoLink()
  local url = getLink()
	vim.fn.jobstart({ "google-chrome-stable", url })
end

-- testurl: https://github.com/thekbbohara

function M.setup()
	vim.api.nvim_create_user_command("QueryGoogle", M.googleQuery, { range = true })
	vim.api.nvim_create_user_command("GoToLink", M.gotoLink, { range = true })
end

return M
