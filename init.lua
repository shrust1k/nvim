require "paq" {
    "savq/paq-nvim",
    "neovim/nvim-lspconfig",
    "folke/tokyonight.nvim",
}

if vim.lsp.config then
    -- Python
    vim.lsp.config('pyright', { cmd = { "pyright-langserver", "--stdio" } })
    vim.lsp.enable('pyright')

    -- C / C++
    vim.lsp.config('clangd', { cmd = { "clangd" } })
    vim.lsp.enable('clangd')

    -- Rust
    vim.lsp.config('rust_analyzer', { cmd = { "rust-analyzer" } })
    vim.lsp.enable('rust_analyzer')
else
    -- Fallback for lspconfig loading
    local status, lspconfig = pcall(require, "lspconfig")
    if status then
        lspconfig.pyright.setup({})
        lspconfig.clangd.setup({})
        lspconfig.rust_analyzer.setup({})
    end
end

-- 3. Standard 'gd' and 'K' mappings (Global)
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
    end,
})

-- 2. Define a Transparency function
local function transparent_bg()
    local groups = {
        "Normal", "NormalNC", "LineNr", "Folded", 
        "NonText", "SpecialKey", "VertSplit", 
        "SignColumn", "EndOfBuffer", "StatusLine"
    }
    for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
    end
end

-- 3. Apply the theme and the transparency
vim.opt.termguicolors = true
vim.cmd([[colorscheme tokyonight]]) -- Or 'tokyonight-storm', 'tokyonight-day'
transparent_bg() -- Run the transparency after the theme loads

-- 4. Re-apply transparency if you change themes later
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = transparent_bg,
})
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.termguicolors = true
vim.opt.mouse=""
vim.opt.clipboard="unnamedplus"
