-- ==============================================================================
-- Undotree 可视化撤销历史
-- ==============================================================================
return {
	{
		"mbbill/undotree",
		keys = {
			{ "<leader>u", "<CMD>UndotreeToggle<CR>", desc = "Undotree: 切换撤销树" },
		},
		-- 全局变量需在插件加载前设置, lazy 会先执行这些字段再加载插件
		init = function()
			vim.g.undotree_SetFocusWhenToggle = 1 -- 打开撤销树时自动聚焦到树窗口
			vim.g.undotree_WindowLayout       = 2 -- 窗口布局: 2 = 上下分屏, 树在上
			vim.g.undotree_DiffAutoOpen       = 1 -- 选中节点时自动打开 diff 预览
			vim.g.undotree_ShortIndicators    = 1 -- 使用短指示符(如 + -)代替长文本
		end,
	},
}
