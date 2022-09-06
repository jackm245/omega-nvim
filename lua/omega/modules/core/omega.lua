local omega = {}

omega.plugins = {
    ["plenary.nvim"] = { "nvim-lua/plenary.nvim", module = "plenary" },
    ["packer.nvim"] = {
        "wbthomason/packer.nvim",
        module = "packer",
        opt = true,
        cmd = {
            "PackerSnapshot",
            "PackerSnapshotRollback",
            "PackerSnapshotDelete",
            "PackerSync",
            "PackerInstall",
            "PackerUpdate",
        },
    },
    ["impatient.nvim"] = { "lewis6991/impatient.nvim" },
}

return omega
