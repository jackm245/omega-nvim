local utils = require("omega.utils")
local modules = require("omega.core.modules")
-- set early so mappings are defined with it
vim.g.mapleader = " "

-- create `omega` gloabel variable
require("omega.core.omega_global")

modules.bootstrap_packer()

utils.bootstrap_impatient()

require("omega.core.settings")
require("omega.core.autocommands")
require("omega.core.mappings")

require("omega.core.ui")
modules.setup()
modules.load()
