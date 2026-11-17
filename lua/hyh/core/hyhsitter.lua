-- ==============================================================================
-- Treesitter 自定义扩展: 大小写指令 + 函数选择器
-- ==============================================================================

-- 构造一个查询指令函数, 用于对匹配到的文本做大小写转换
-- transform: string.lower 或 string.upper
-- 返回的 directive 函数签名符合 vim.treesitter.query.add_directive 的要求
local function case_directive(transform)
	return function(match, _, bufnr, pred, metadata)
		local id = pred[2] -- 指令参数: 要处理的捕获组 ID
		if type(id) ~= "number" then return end
		local nodes = match[id]
		if not nodes or #nodes == 0 then return end
		local node = nodes[1]
		-- 取节点原文; metadata[id] 可能携带上层指令的文本变换信息
		local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
		if not metadata[id] then metadata[id] = {} end
		-- 将转换后的文本写回 metadata, 供后续捕获使用
		metadata[id].text = transform(text)
	end
end

-- 注册自定义查询指令: @downcase! / @upcase!
-- force = true 表示覆盖同名指令(避免重复注册报错)
vim.treesitter.query.add_directive("downcase!", case_directive(string.lower), { force = true })
vim.treesitter.query.add_directive("upcase!", case_directive(string.upper), { force = true })

-- 对每个文件类型尝试启动 Treesitter (pcall 防止无解析器时报错)
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

-- ------------------------------------------------------------------------------
-- 选择包含光标的最小 @function.outer / @function.inner 范围
-- capture: "function.outer" 或 "function.inner"
-- ------------------------------------------------------------------------------
local function select_function(capture)
	local bufnr = vim.api.nvim_get_current_buf()
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
	if not ok or not parser then return end

	local lang = parser:lang()
	-- 获取该语言的 textobjects 查询(需 nvim-treesitter 提供对应 queries)
	local query = vim.treesitter.query.get(lang, "textobjects")
	if not query then return end

	local tree = parser:parse()[1]
	if not tree then return end
	local root = tree:root()

	-- 光标位置(0-based 行列)
	local cur = vim.api.nvim_win_get_cursor(0)
	local crow, ccol = cur[1] - 1, cur[2]

	local best, best_size
	-- 遍历所有匹配, 计算每个匹配中目标捕获的包围盒
	for _, match in query:iter_matches(root, bufnr, 0, -1, { all = true }) do
		local min_sr, min_sc, max_er, max_ec
		for id, nodes in pairs(match) do
			if query.captures[id] == capture then
				if type(nodes) ~= "table" then nodes = { nodes } end
				for _, node in ipairs(nodes) do
					local sr, sc, er, ec = node:range()
					-- 扩展包围盒的左上角
					if not min_sr or sr < min_sr or (sr == min_sr and sc < min_sc) then
						min_sr, min_sc = sr, sc
					end
					-- 扩展包围盒的右下角
					if not max_er or er > max_er or (er == max_er and ec > max_ec) then
						max_er, max_ec = er, ec
					end
				end
			end
		end
		if min_sr then
			-- 判断光标是否落在该包围盒内
			local contains = (min_sr < crow or (min_sr == crow and min_sc <= ccol))
				and (max_er > crow or (max_er == crow and max_ec >= ccol))
			if contains then
				-- 用行列组合估算范围大小, 选最小者(嵌套时取最内层)
				local size = (max_er - min_sr) * 1e6 + (max_ec - min_sc)
				if not best_size or size < best_size then
					best_size = size
					best = { min_sr, min_sc, max_er, max_ec }
				end
			end
		end
	end

	if not best then return end
	local sr, sc, er, ec = best[1], best[2], best[3], best[4]

	-- 若当前处于可视模式, 先退出, 避免后续 normal! v 叠加选择
	local mode = vim.fn.mode()
	if mode == "v" or mode == "V" or mode == "\22" then
		vim.api.nvim_feedkeys(
			vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
	end

	-- 将光标移到范围起点, 进入可视模式, 再移到范围终点(ec 为开区间, 减 1)
	vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
	vim.cmd("normal! v")
	vim.api.nvim_win_set_cursor(0, { er + 1, math.max(0, ec - 1) })
end

-- 键位: af / if 在可视模式和操作符待决模式下选择函数范围
vim.keymap.set({ "x", "o" }, "af", function() select_function("function.outer") end,
	{ desc = "around function" })
vim.keymap.set({ "x", "o" }, "if", function() select_function("function.inner") end,
	{ desc = "inside function" })
