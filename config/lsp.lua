vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
)

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local opts = { noremap = true, silent = true }
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  -- buf_set_keymap("n", "ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "ca", "<cmd>CodeActionMenu<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

  -- autocmd BufWritePre * :!{bash -c "while ![ -e $1 ]; do echo $1; sleep 0.1s; done"} %:p
  -- if client.resolved_capabilities.document_formatting then
  --   vim.cmd([[
  --   augroup LspFormatting
  --       autocmd! * <buffer>
  --       autocmd BufWritePre * sleep 100m
  --       autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
  --   augroup END
  --   ]])
  -- end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local disable_formatting = function(client, bufnr)
  client.resolved_capabilities.document_formatting = false
  client.resolved_capabilities.document_range_formatting = false
  on_attach(client, bufnr)
end

local enable_formatting = function(client, bufnr)
  client.resolved_capabilities.document_formatting = true
  client.resolved_capabilities.document_range_formatting = true
  on_attach(client, bufnr)
end

local server_settings = {
  tsserver = {
    format = { enable = false },
    codeActionsOnSave = {
      mode = "all",
      source = {
        organizeImports = true,
      }
    },
  },
  eslint = {
    enable = true,
    format = { enable = true }, -- this will enable formatting
    packageManager = "npm",
    autoFixOnSave = true,
    codeActionsOnSave = {
      mode = "all",
      rules = { "!debugger", "!no-only-tests/*" },
    },
    lintTask = {
      enable = true,
    },
  },
  sumneko_lua = {
    Lua = {
      diagnostics = {
        globals = {
          'vim'
        }
      }

    }
  }
}

local lspconfig = require('lspconfig')
local lsp_installer = require('nvim-lsp-installer')
lsp_installer.setup()
for _, server in ipairs(lsp_installer.get_installed_servers()) do
  local opts = { on_attach = on_attach, capabilities = capabilities }
  -- local opts = { on_attach = on_attach }

  if server_settings[server.name] then
    opts.settings = server_settings[server.name]
  end

  if server.name == "eslint" then opts.on_attach = enable_formatting end
  if server.name == 'tsserver' then opts.on_attach = disable_formatting end

  lspconfig[server.name].setup(opts)
end

