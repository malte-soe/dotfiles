require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
  },
  refactor = {
    highlight_definitions = { enable = true },
  },
  indent = {
    enable = true
  }
}
