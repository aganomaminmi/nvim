return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      default_file_explorer = true,
      -- oil の遅延クリーンアップ (既定2秒) は、oil を閉じた直後の再オープンと
      -- レースして "Invalid buffer id" で oil が死ぬ (upstream バグ)。無効化で回避。
      cleanup_delay_ms = false,
      view_options = {
        show_hidden = true,
      },
      win_options = {
        -- oil-git-status が2列分の signcolumn を使う
        signcolumn = "yes:2",
      },
      keymaps = {
        -- preview は P (fern 時代の p の指に近い)。C-p はタブ移動 (gT) を通すため oil の割当を無効化
        ["P"] = "actions.preview",
        ["<C-p>"] = false,
        -- カーソル下エントリの絶対パスをヤンク (clipboard=unnamed なのでシステムクリップボードにも入る)
        ["gy"] = "actions.copy_entry_path",
        -- fern と同じ ? でヘルプ (oil 内の後方検索は潰れるが実用上使わない)
        ["?"] = { "actions.show_help", mode = "n" },
        -- タブで開く前に元タブの oil を明示クローズ (close=true は新タブ側で動くため効かない)
        ["<C-t>"] = {
          callback = function()
            local oil = require("oil")
            local entry = oil.get_cursor_entry()
            if not entry then return end
            local dir = oil.get_current_dir()
            if not dir then return end
            local path = dir .. entry.name
            oil.close()
            if entry.type == "directory" then
              vim.cmd("tabnew")
              oil.open(path)
            else
              vim.cmd("tabedit " .. vim.fn.fnameescape(path))
            end
          end,
          desc = "タブで開いて oil を閉じる",
        },
      },
    },
    config = function(_, opts)
      local oil = require("oil")
      oil.setup(opts)

      -- upstream バグ回避: oil.util.rename_buffer の vim.schedule 内にバッファ有効性
      -- ガードがなく、遅延中に対象バッファが消える (cleanup タイマー / oil.close の
      -- fallback 削除 / 他プラグインの wipe) と "Invalid buffer id" で oil ごと死ぬ。
      -- 本家 util.lua の同関数のコピーに is_valid ガードを足したもの。oil 更新で
      -- 本体側が修正されたらこのブロックごと削除する。
      local util = require("oil.util")
      util.rename_buffer = function(src_bufnr, dest_buf_name)
        if type(src_bufnr) == "string" then
          src_bufnr = vim.fn.bufadd(src_bufnr)
          if not vim.api.nvim_buf_is_loaded(src_bufnr) then
            vim.api.nvim_buf_delete(src_bufnr, {})
            return false
          end
        end

        local bufname = vim.api.nvim_buf_get_name(src_bufnr)
        if not vim.uv.fs_stat(dest_buf_name) then
          local altbuf = vim.fn.bufnr("#")
          local ok = pcall(vim.api.nvim_buf_set_name, src_bufnr, dest_buf_name)
          if ok then
            pcall(vim.api.nvim_buf_delete, vim.fn.bufadd(bufname), {})
            if altbuf and vim.api.nvim_buf_is_valid(altbuf) then
              vim.fn.setreg("#", altbuf)
            end
            return false
          end
        end

        local is_modified = vim.bo[src_bufnr].modified
        local dest_bufnr = vim.fn.bufadd(dest_buf_name)
        pcall(vim.fn.bufload, dest_bufnr)
        if vim.bo[src_bufnr].buflisted then
          vim.bo[dest_bufnr].buflisted = true
        end
        vim.bo[src_bufnr].modified = is_modified

        vim.schedule(function()
          -- ガード (本家は dest_bufnr の有効性を確認せず触って落ちる)。
          -- 注意: win_set_buf / buf_delete は autocmd を連鎖発火させ、その中で
          -- dest が消されうる (mtw の BufWipeout cleanup 等)。有効性はキャッシュ
          -- せず毎アクセス直前に確認し、全体も pcall で包む。
          local valid = vim.api.nvim_buf_is_valid
          pcall(function()
            for _, winid in ipairs(vim.api.nvim_list_wins()) do
              if
                valid(dest_bufnr)
                and vim.api.nvim_win_is_valid(winid)
                and vim.api.nvim_win_get_buf(winid) == src_bufnr
              then
                vim.api.nvim_win_set_buf(winid, dest_bufnr)
              end
            end
            if valid(src_bufnr) then
              if valid(dest_bufnr) and vim.bo[src_bufnr].modified then
                local src_lines = vim.api.nvim_buf_get_lines(src_bufnr, 0, -1, true)
                vim.api.nvim_buf_set_lines(dest_bufnr, 0, -1, true, src_lines)
              end
              pcall(vim.api.nvim_buf_delete, src_bufnr, {})
            end
            if valid(dest_bufnr) and vim.bo[dest_bufnr].undofile then
              vim.api.nvim_buf_call(dest_bufnr, function()
                vim.cmd.rundo({
                  args = { vim.fn.undofile(dest_buf_name) },
                  magic = { file = false, bar = false },
                  mods = { emsg_silent = true },
                })
              end)
            end
          end)
        end)
        return true
      end
      vim.keymap.set("n", "<C-e>", function()
        if vim.bo.filetype == "oil" then
          -- 復元先バッファが既に wipe されている (markdown-table-wrap の reader 等) と
          -- oil.close は fallback でバッファ削除しタブごと潰れるため、記録した実ファイルへ戻る
          local ok, orig = pcall(vim.api.nvim_win_get_var, 0, "oil_original_buffer")
          local fb = vim.w.oil_fallback_file
          if ok and not vim.api.nvim_buf_is_valid(orig) and fb and fb ~= "" then
            vim.cmd("edit " .. vim.fn.fnameescape(fb))
          else
            oil.close()
          end
          return
        end
        -- markdown-table-wrap の reader バッファは外来スキームのため、oil が生パス
        -- :edit の hijack 経路に迷い込み不安定。元ファイルの実パス基準で開く
        local file
        local src = vim.b.markdown_table_wrap_source
        if src and vim.api.nvim_buf_is_valid(src) then
          file = vim.api.nvim_buf_get_name(src)
        elseif vim.bo.buftype == "" then
          local name = vim.api.nvim_buf_get_name(0)
          if name ~= "" and not name:match("://") then
            file = name
          end
        end
        if file and file ~= "" then
          oil.open(vim.fn.fnamemodify(file, ":h"))
        else
          oil.open()
        end
        vim.w.oil_fallback_file = file
      end, { noremap = true, silent = true, desc = "oil をトグル" })
    end,
  },
  {
    "refractalize/oil-git-status.nvim",
    dependencies = { "stevearc/oil.nvim" },
    config = true,
  },
}
