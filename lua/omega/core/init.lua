vim.g.mapleader = " "

require("omega.core.omega_global")
require("omega.core.config").load()

local modules = require("omega.core.modules")

modules.bootstrap_packer()

local utils = require("omega.utils")
utils.bootstrap_plugins()

require("omega.core.settings")
require("omega.core.autocommands")
require("omega.core.commands")
require("omega.core.ui")

modules.setup()
modules.load()

require("omega.core.mappings")
