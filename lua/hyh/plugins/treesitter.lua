return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,                -- Treesitter 不支持懒加载, 必须立即加载
    build = ":TSUpdate",         -- 更新插件时自动同步解析器
    config = function()
      -- 新版 nvim-treesitter 的初始化方式
      require("nvim-treesitter").setup({})

      -- 安装你需要的语言解析器（按需增删）
      local parsers = { "lua", "vim", "vimdoc", "query", "python", "javascript", "typescript" }
      require("nvim-treesitter").install(parsers)

      -- 为已安装解析器的文件类型启用 Treesitter 高亮
      vim.api.nvim_create_autocmd("FileType", {
        pattern = parsers,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
}
