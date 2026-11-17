return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async", -- ufo 依赖的异步库
  },
  config = function()
    local ok, ufo = pcall(require, "ufo")
    if not ok then
      return
    end

    ufo.setup({
      -- 折叠数据源选择器, 优先 treesitter, 失败回退 indent
      provider_selector = function(_, _, _)
        return { "treesitter", "indent" }
      end,

      -- 自定义折叠行虚拟文本渲染, 控制折叠行展示样式
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        -- local suffix = ("  …  %d "):format(endLnum - lnum) -- 后缀: 显示折叠包含行数
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0

        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if curWidth + chunkWidth < targetWidth then
            table.insert(newVirtText, chunk)
            curWidth = curWidth + chunkWidth
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            table.insert(newVirtText, { chunkText, chunk[2] })
            curWidth = targetWidth
            break
          end
        end

        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,

      open_fold_hl_timeout = 0,                  -- 关闭折叠高亮延迟
      close_fold_kinds_for_ft = {
        default = { "imports", "comment" },       -- 默认自动折叠 import, 注释块
      },
      preview = {
        win_config = {
          border = "rounded",                 -- 预览窗口圆角边框
          winblend = 0,                       -- 预览窗口透明度
        },
      },
    })

    -- 全局折叠选项
    vim.o.foldenable = true                -- 开启折叠功能
    vim.o.foldcolumn = '0'                 -- 不显示左侧折叠标记列
    vim.o.foldlevel = 99                   -- 当前缓冲区折叠层级, 99=全部展开
    vim.o.foldlevelstart = 99              -- 打开新文件默认全部展开
    vim.o.foldnestmax = 4                  -- 最大嵌套折叠深度

    -- 快捷键映射
    vim.keymap.set("n", "zR", ufo.openAllFolds,  { desc = "Ufo: Open all folds" })
    vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Ufo: Close all folds" })
  end,
}

