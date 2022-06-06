local omega = {}

omega.plugins = {
    ["plenary.nvim"] = { "nvim-lua/plenary.nvim", module = "plenary" },
    ["packer.nvim"] = { "wbthomason/packer.nvim", opt = true, module = "packer" },
    ["impatient.nvim"] = { "lewis6991/impatient.nvim" },
}

return omega
