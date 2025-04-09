local options = {
  ensure_installed = {
    "bash",
    "c",
    "cmake",
    "cpp",
    "dockerfile",
    "fish",
    "go",
    "gomod",
    "gosum",
    "gotmpl",
    "gowork",
    "json",
    "javascript",
    "lua",
    "luadoc",
    "make",
    "markdown",
    "printf",
    "python",
    "toml",
    "typescript",
    "tsx",
    "rust",
    "vim",
    "vimdoc",
    "yaml",
  },

  highlight = {
    enable = true,
  },

  indent = { enable = true },
  sync_install = false,
  auto_install = false,
}

require("nvim-treesitter.configs").setup(options)
