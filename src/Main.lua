N = 10
D = {
    S = { { 2, 4, 0, 0, 0, 0 }, { 3, 8, 0, 0, 0, 0 }, { 4, 1, 0, 0, 0, 0 }, { 9, 6, 0, 0, 0, 0 } },
    U = { { 2, 4 }, { 1, 1 } },
    C = { { 5, 1 }, { 9, 9 } },
    G = { { 4, 3 } },
    R = { { 8, 7 }, { 6, 1 }, { 4, 5 } }
}
require("Lists")
function gong(config)
    local newConfig = cloneList(config)
    collectObjects(newConfig)
    return newConfig
end

function collectObjects(config)
    for i, senpai in ipairs(config["S"]) do
        local objectIndex, objectType = findObjectInSameCell(senpai, config)
        if objectType ~= "N" then
            table.remove(config[objectType], objectIndex)
            config["S"][i] = incrementSenpaiStat(senpai, objectType)
            print(table.unpack(config["S"][i]))
        end
    end
end

function incrementSenpaiStat(senpai, objectType)
    local newSenpai = cloneList(senpai)
    local objectTypes = { "U", "C", "G", "R" }
    for k, v in pairs(objectTypes) do
        if v == objectType then
            newSenpai[k + 2] = newSenpai[k + 2] + 1
        end
    end
    return newSenpai
end

--Questa funzione assume che ci sia un solo oggetto nella stessa cella
function findObjectInSameCell(senpai, config)
    local objectTypes = { "U", "C", "G", "R" }
    for _, objectType in ipairs(objectTypes) do
        local objects = config[objectType]
        for i, object in ipairs(objects) do
            if sameCell(senpai, object) then
                return i, objectType
            end
        end
    end
    return -1, "N" --N sta per nessuno, non c'è nessun oggetto nella stessa cella del senpai
end

function sameCell(senpai, object)
    return senpai[1] == object[1] and senpai[2] == object[2]
end

gong(D)