stds.nvim = {
  globals = {
    vim = { fields = { "g", "opt" } },
    table = { fields = { "unpack" } },
    package = { fields = { "searchers" } },
    doom = { fields = { "packages", "binds", "autocmds" } },
    _doom = { fields = { "cmp_enable" } }
  },
  read_globals = {
    "vim",
    "jit",
    "packer_plugins",
    "doom",
    "_doom"
  },
}
std = "lua51+nvim"

ignore = {
  "212/_.*",  -- unused argument, for vars with "_" prefix
}
