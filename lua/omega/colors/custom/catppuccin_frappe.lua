local colors = require("omega.colors").get()
return {
    ["Include"] = { fg = colors.purple },
    ["Identifier"] = { fg = colors.teal },
    ["TSFuncBuiltin"] = { fg = colors.orange },
    ["TSVariableBuiltin"] = { fg = colors.red },
    ["TSException"] = { fg = colors.purple },
    ["Repeat"] = { fg = colors.purple },
    ["Type"] = { fg = colors.purple },
    ["TSTypeBuiltin"] = { fg = colors.yellow },
}
