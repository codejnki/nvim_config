local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local b = null_ls.builtins

local opts = {
  sources = {

  -- webdev stuff
  null_ls.builtins.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  null_ls.builtins.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes

  -- Lua
  null_ls.builtins.formatting.stylua,

  -- cpp
  null_ls.builtins.formatting.clang_format,
  
  -- golang
  null_ls.builtins.formatting.gofumpt,
  null_ls.builtins.formatting.goimports_reviser,
  null_ls.builtins.formatting.golines,
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({
        group = augroup,
        buffer = bufnr,
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
}

null_ls.setup {
  debug = true,
  sources = opts.sources,
}
return opts