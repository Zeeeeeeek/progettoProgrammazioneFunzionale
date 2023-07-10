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

----Clone the given list and all its sublists
function cloneList(list)
    local clonedList = {}
    for k, item in pairs(list) do
        if type(item) == "table" then
            clonedList[k] = cloneList(item)
        else
            clonedList[k] = item
        end
    end
    return clonedList
end

----Returns the index of the first element of the list that satisfies the predicate, -1 otherwise.
function findIndexThatSatisfies(tbl, predicate)
    for i, v in ipairs(tbl) do
        if predicate(v) then
            return i
        end
    end
    return -1
end

----Returns the index of the first element of the list that is equal to the given element, -1 otherwise.
function findIndex(tbl, elem)
    return findIndexThatSatisfies(tbl, function (x) return x == elem end)
end

----Returns a list containing all the objects in the given config.
function listOfAllObjectsPositions(config)
    local list = {}
    local objectsKeys = {"U", "C", "G", "R"}
    for _, key in ipairs(objectsKeys) do
        for _, object in ipairs(config[key]) do
            table.insert(list, object)
        end
    end
    return list
end
