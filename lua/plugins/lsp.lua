return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
        severity_sort = true,
      })

      local on_attach = function(_, bufnr)
        local function set(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
        end

        set("n", "gD", vim.lsp.buf.declaration)
        set("n", "gd", function()
          if vim.api.nvim_win_get_width(0) > 100 then
            vim.cmd("vs")
          end
          vim.lsp.buf.definition()
        end)
        set("n", "K", vim.lsp.buf.hover)
        set("n", "gi", vim.lsp.buf.implementation)
        set("n", "<C-k>", vim.lsp.buf.signature_help)
        set("n", "<space>wa", vim.lsp.buf.add_workspace_folder)
        set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder)
        set("n", "<space>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end)
        set("n", "<space>D", vim.lsp.buf.type_definition)
        set("n", "<space>rn", vim.lsp.buf.rename)
        set("n", "ca", vim.lsp.buf.code_action)
        set("n", "gr", vim.lsp.buf.references)
        set("n", "<space>e", function()
          vim.diagnostic.open_float({
            format = function(d)
              return string.format("%s (%s: %s)", d.message, d.source, d.code)
            end,
          })
        end)
        set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end)
        set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end)
        set("n", "<space>q", vim.diagnostic.setloclist)
        set("n", "<space>f", function() vim.lsp.buf.format({ async = true }) end)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end
          on_attach(client, args.buf)

          if client.name == "eslint" then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = args.buf,
              command = "EslintFixAll",
            })
          end
        end,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("ts_ls", {
        root_markers = { "package.json" },
        settings = {
          format = { enable = false },
          codeActionsOnSave = {
            mode = "all",
            source = { organizeImports = true },
          },
        },
      })

      vim.lsp.config("eslint", {
        settings = {
          enable = true,
          format = { enable = true },
          packageManager = "npm",
          autoFixOnSave = true,
          codeActionsOnSave = {
            enable = true,
            mode = "all",
          },
          lintTask = { enable = true },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      vim.lsp.config("denols", {
        root_markers = { "deno.json", "deno.jsonc" },
        init_options = {
          enable = true,
          unstable = true,
          config = "./deno.jsonc",
        },
      })

      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",
          "eslint",
          "denols",
          "lua_ls",
          "gopls",
          "graphql",
        },
        automatic_enable = true,
      })
    end,
  },
}
