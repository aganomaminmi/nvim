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
  buf_set_keymap("n", "ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

  -- autocmd BufWritePre * :!{bash -c "while ![ -e $1 ]; do echo $1; sleep 0.1s; done"} %:p
  if client.resolved_capabilities.document_formatting then
    vim.cmd([[
    augroup LspFormatting
        autocmd! * <buffer>
        autocmd BufWritePre * sleep 200m
        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
    augroup END
    ]])
  end
end

-- local lsp_installer = require("nvim-lsp-installer")
-- lsp_installer.on_server_ready(function(server)
--   local opts = {}
--   opts.on_attach = on_attach

--   server:setup(opts)
-- end)

local lsp_installer_servers = require('nvim-lsp-installer.servers')

-- local function common_on_attach(client, bufnr)
--   -- Setup lspconfig.
--   local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
--   capabilities.textDocument.completion.completionItem.snippetSupport = true

--   -- autocmd BufWritePre * :!{bash -c "while ![ -e $1 ]; do echo $1; sleep 0.1s; done"} %:p
--   if client.resolved_capabilities.document_formatting then
--     vim.cmd([[
--     augroup LspFormatting
--         autocmd! * <buffer>
--         autocmd BufWritePre * sleep 200m
--         autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
--     augroup END
--     ]])
--   end
-- end

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

local servers = {
  'sumneko_lua', -- (lua)
  'volar', -- (vue)
  'angularls',
  'cssls',
  'eslint', -- (javascript, typescript)
  'graphql',
  'hls', -- (haskell)
  'html',
  'remark_ls', -- (markdown)
  'tsserver', -- (typescript, javascript)
  'vimls',
  'yamlls',
}

local server_settings = {
  tsserver = {
    format = { enable = false },
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

-- Loop through the servers listed above.
for _, name in pairs(servers) do

  local available, server = lsp_installer_servers.get_server(name)

  if available then
    server:on_ready(function()
      local opts = { on_attach = on_attach }

      -- set server-specific settings
      --
      if server_settings[server.name] then
        opts.settings = server_settings[server.name]
      end

      -- neovim's LSP client does not currently support dynamic capabilities registration, so we need to set
      -- the resolved capabilities of the eslint server ourselves!
      --
      if server.name == "eslint" then opts.on_attach = enable_formatting end

      -- Disable formatting for typescript, so that eslint can take over.
      --
      if server.name == 'tsserver' then opts.on_attach = disable_formatting end
      if server.name == 'sumneko_lua' then opts.on_attach = disable_formatting end

      server:setup(opts)
    end)

    -- Queue the server to be installed.
    if not server:is_installed() then server:install() end

  end
end
