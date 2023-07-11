function filter (tbl, func)
    local r = {}
    for _, v in ipairs(tbl) do
        if func(v) then
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

function reduce (func, c, tbl)
    if #tbl == 0 then
        return c
    else
        return reduce(func, func(table.remove(tbl, 1), c), tbl)
    end
end

----Clone the given table and all its subtables
function cloneTable(table)
    local clonedTable = {}
    for k, item in pairs(table) do
        if type(item) == "table" then
            clonedTable[k] = cloneTable(item)
        else
            clonedTable[k] = item
        end
    end
    return clonedTable
end

----Returns the index of the first element of the table that satisfies the predicate, -1 otherwise.
function findIndexThatSatisfies(tbl, predicate)
    for i, v in ipairs(tbl) do
        if predicate(v) then
            return i
        end
    end
    return -1
end

----Returns the index of the first element of the table that is equal to the given element, -1 otherwise.
function findIndex(tbl, elem)
    return findIndexThatSatisfies(tbl, function(x)
        return x == elem
    end)
end

----Returns a table containing all the objects in the given config.
function tableOfAllObjectsPositions(config)
    local tbl = {}
    local objectsKeys = { "U", "C", "G", "R" }
    for _, key in ipairs(objectsKeys) do
        for _, object in ipairs(config[key]) do
            table.insert(tbl, object)
        end
    end
    return tbl
end
