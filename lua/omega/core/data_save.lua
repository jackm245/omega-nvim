local data_save = {}

local file_name = vim.fn.stdpath("data") .. "/omega_data"

data_save.data = {}

function data_save.store(key, value)
    data_save.data[key] = value
end

function data_save.get_data()
    local file = io.open(file_name, "r")
    if not file then
        return
    end
    local content = file:read("*a")
    io.close(file)
    data_save.data = vim.mpack.decode(content)
end

function data_save.set_data()
    local file = io.open(file_name, "w")

    if not file then
        return
    end

    file:write(vim.mpack.encode(data_save.data))

    io.close(file)
end

return data_save
