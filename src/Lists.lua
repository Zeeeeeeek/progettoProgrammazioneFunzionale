function filter (tbl, func)
    local r = {}
    for i, v in ipairs(tbl) do
        if func(tbl[v]) then
            table.insert(r, v)
        end
    end
    return r
end

function map (func, tbl)
    local newtbl = {}
    for i, v in pairs(tbl) do
        newtbl[i] = func(v)
    end
    return newtbl
end

-- func è una funzione binaria
function reduce (func, c, tbl)
    if #tbl == 0 then
        return c
    else
        return reduce(func, func(table.remove(tbl, 1), c), tbl)
    end
end

function cloneList(list)
    local clonedList = {}
    for k, item in pairs(list) do
        if type(item) == "table" then
            -- Clonare la lista ricorsivamente se l'elemento è una tabella
            clonedList[k] = cloneList(item)
        else
            -- Copiare direttamente l'elemento se non è una tabella
            clonedList[k] = item
        end
    end
    return clonedList
end