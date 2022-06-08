local utils = require("omega.utils")
-- set early so mappings are defined with it
vim.g.mapleader = " "

-- create `omega` gloabel variable
require("omega.core.omega_global")
-- add config to `omega` global
require("omega.core.config").load()

local modules = require("omega.core.modules")

modules.bootstrap_packer()

utils.bootstrap_plugins()

require("omega.core.settings")
require("omega.core.autocommands")
require("omega.core.commands")

require("omega.core.ui")
modules.setup()
modules.load()
require("omega.core.mappings")
require("omega.utils.types")
