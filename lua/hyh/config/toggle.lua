local M = {}

-- 在指定循环中查找当前单词并切换
local function cycle_in_group(word, group)
	for i, value in ipairs(group) do
		if value == word then
			local next_val = group[i % #group + 1]
			vim.cmd("normal! ciw" .. next_val)
			return true
		end
	end
	return false
end

-- 获取光标下的单词
local function cword()
	return vim.fn.expand("<cword>")
end

-- 切换布尔值: 如果当前是 true/True/TRUE 之一, 切到对应 false 变体
function M.toggle_boolean()
	local word = cword()
	local groups = {
		{ "true", "false" },
		{ "True", "False" },
		{ "TRUE", "FALSE" },
	}
	for _, g in ipairs(groups) do
		if cycle_in_group(word, g) then return end
	end
	-- 如果当前不是布尔值, 不操作(或可回退到默认 ToggleAlternate)
end

-- 切换比较运算符: == ⇄ !=, === ⇄ !==
function M.toggle_compare()
	local word = cword()
	local groups = {
		{ "===", "!==" },
		{ "==", "!=" },
	}
	for _, g in ipairs(groups) do
		if cycle_in_group(word, g) then return end
	end
end

-- 循环日志级别: info → warn → error → debug → info
function M.cycle_log_level()
	local word = cword()
	cycle_in_group(word, { "info", "warn", "error", "debug" })
end

-- 循环访问修饰符: public → private → protected → public
function M.toggle_public_private()
	local word = cword()
	cycle_in_group(word, { "public", "private", "protected" })
end

return M
