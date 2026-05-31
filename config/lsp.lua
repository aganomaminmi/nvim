vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
  }
)

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local opts = { noremap = true, silent = true }
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  -- buf_set_keymap("n", "gd", "<cmd>vs | lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua if vim.api.nvim_win_get_width(0) > 100 then vim.cmd('vs') vim.lsp.buf.definition() else vim.lsp.buf.definition() end<CR>", opts)
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
  buf_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float({ format = function(diagnostic) return string.format('%s (%s: %s)', diagnostic.message, diagnostic.source, diagnostic.code) end })<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)

end

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- local capabilities = require("ddc_source_lsp").make_client_capabilities()
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local disable_formatting = function(client, bufnr)
  client.server_capabilities.document_formatting = false
  client.server_capabilities.document_range_formatting = false
  on_attach(client, bufnr)
end

local enable_formatting = function(client, bufnr)
  client.server_capabilities.document_formatting = true
  client.server_capabilities.document_range_formatting = true
  client.server_capabilities.documentFormattingProvider = true
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
      enable = true,
      mode = "all",
      -- rules = { "!debugger", "!no-only-tests/*" },
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
  },
  volar = {
    autoCompleteRefs = true,
  },
  denols = {
    init_options = {
      enable = true,
      unstable = true,
      config = "./deno.jsonc"
    }
  },
}

local init_options = {
  volar = {
    typescript = {
      tsdk = "/Users/kouha/.nodebrew/current/lib/node_modules/typescript/lib",
    },
  }
}

-- local lsp_installer = require('nvim-lsp-installer')
-- lsp_installer.setup()

local lspconfig = require('lspconfig')
local mason = require('mason')
mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup_handlers({ 
  function(server_name)
    local opts = { on_attach = on_attach, capabilities = capabilities }
    -- local opts = { on_attach = on_attach }

    if server_settings[server_name] then
      opts.settings = server_settings[server_name]
    end

    if init_options[server_name] then
      opts.init_options = init_options[server_name]
    end

    if server_name == "eslint" then 
      vim.cmd('autocmd BufWritePre <buffer> EslintFixAll')
      opts.on_attach = enable_formatting
    end

    local deno_root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
    local buf_name = vim.api.nvim_buf_get_name(0)
    local current_buf = vim.api.nvim_get_current_buf()
    local is_deno_repo = deno_root_dir(buf_name, current_buf) ~= nil

    local node_root_dir = lspconfig.util.root_pattern("package.json")
    local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0)) ~= nil

    -- if server_name == 'tsserver' then opts.on_attach = disable_formatting end

    if server_name == 'denols' then
      opts.root_dir = lspconfig.util.root_pattern('deno.jsonc')
      opts.init_options = {
        enable = true,
        unstable = true,
        config = "./deno.jsonc"
      }

    elseif server_name == 'tsserver' then
      if is_deno_repo then
        return
      end
      opts.root_dir = lspconfig.util.root_pattern('package.json')

    end

    lspconfig[server_name].setup(opts)
    -- end

  end
})

