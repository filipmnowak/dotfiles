local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- lsp config for elixir-ls support
  use 'neovim/nvim-lspconfig'

  -- cmp framework for auto-completion support
  use 'hrsh7th/nvim-cmp'

  -- install different completion source
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'

  -- you need a snippet engine for snippet support
  -- here I'm using vsnip which can load snippets in vscode format
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/cmp-vsnip'

  -- treesitter for syntax highlighting and more
  use 'nvim-treesitter/nvim-treesitter'

  use 'elixir-editors/vim-elixir'

  use "lukas-reineke/indent-blankline.nvim"

  -- `on_attach` callback will be called after a language server
  -- instance has been attached to an open buffer with matching filetype
  -- here we're setting key mappings for hover documentation, goto definitions, goto references, etc
  -- you may set those key mappings based on your own preference
  local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true }
  
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-f>', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cd', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  end

  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  require('lspconfig').elixirls.setup {
    cmd = { "/opt/elixir-ls-0.12.0/language_server.sh" },
    on_attach = on_attach,
    capabilities = capabilities
  }

  util = require "lspconfig/util"
  require('lspconfig').gopls.setup {
    cmd = {"gopls", "serve"},
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {"go", "gomod"},
    root_dir = util.root_pattern("go.mod", ".git"),
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  }

  require'nvim-treesitter.configs'.setup {
    ensure_installed = {
            "elixir",
            "heex",
            "eex",
            "go",
            "javascript",
            "typescript",
            "rust",
            "ocaml",
            "python",
            "haskell"
    },
    -- ensure_installed = "all", -- install parsers for all supported languages
    sync_install = false,
    ignore_install = { },
    highlight = {
      enable = true,
      disable = { "elixir" },
    },
}

  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        -- setting up snippet engine
        -- this is for vsnip, if you're using other
        -- snippet engine, please refer to the `nvim-cmp` guide
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      { name = 'buffer' }
    })
  })

  require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    enabled = false,
    show_current_context = true,
    show_current_context_start = false,
    show_trailing_blankline_indent = false,
    use_treesitter_scope = true,
    viewport_buffer = 64,
    indent_level = 10,
    show_first_indent_level = true,
    use_treesitter = true
  }

  -- start at last cursor line
  vim.api.nvim_create_autocmd(
    "BufReadPost",
    { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
  )

  vim.cmd "set colorcolumn=128"
  vim.cmd "set ruler"
  vim.cmd "set number"

  vim.cmd "highlight BadWhitespace ctermbg=red guibg=darkred"
  vim.cmd "highlight Visual ctermbg=LightMagenta ctermfg=Yellow"
  vim.cmd "autocmd BufRead,BufNewFile *.sh,*.py,*.pyw,*.ex,*.exs match BadWhitespace /\\s\\+$/"

  vim.cmd "autocmd FileType python setlocal tabstop=2"
  vim.cmd "autocmd FileType python setlocal shiftwidth=2"
  vim.cmd "autocmd FileType python setlocal expandtab"

  vim.cmd "autocmd FileType go setlocal tabstop=4"
  vim.cmd "autocmd FileType go setlocal shiftwidth=4"
  vim.cmd "autocmd FileType go setlocal noexpandtab"

  -- automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
