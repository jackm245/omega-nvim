local utils = require("omega.utils")
local modules = require("omega.core.modules")

-- create `omega` gloabel variable
require("omega.core.omega_global")

modules.bootstrap_packer()

utils.bootstrap_impatient()

require("omega.core.settings")

require("omega.core.ui")
modules.setup()
modules.load()
