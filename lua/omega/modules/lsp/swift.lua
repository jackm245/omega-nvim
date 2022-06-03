local swift_mod = {}

swift_mod.plugins = {
    ["xbase"] = {
        "tami5/xbase",
        ft="switft",
        run = "make install",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
    },
}

return swift_mod
