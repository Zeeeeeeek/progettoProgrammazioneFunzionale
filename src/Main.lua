N = 10
D = {
    S = { { 2, 4, 0, 0, 0, 0 }, { 3, 8, 0, 0, 0, 0 }, { 4, 1, 0, 0, 0, 0 }, { 9, 6, 0, 0, 0, 0 } },
    U = { { 2, 4 }, { 1, 1 } },
    C = { { 3, 8 } },
    G = { { 4, 3 } },
    R = { { 8, 7 }, { 6, 1 }, { 4, 5 } }
}
require("Lists")
function gong(config)
    return collectObjects(config)
end

function collectObjects(config)
    local newConfig = cloneList(config)
    for i, senpai in ipairs(newConfig["S"]) do
        local objectIndex, objectType = findObjectInSameCell(senpai, newConfig)
        if objectType ~= "N" then
            table.remove(newConfig[objectType], objectIndex)
            newConfig["S"][i] = incrementSenpaiStat(senpai, objectType)
        end
    end
    return newConfig
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

function printConfig(config)
    local keys = {"S", "U", "C", "G", "R"}

    for _, key in ipairs(keys) do
        io.write(key .. " = { ")
        for _, value in ipairs(config[key]) do
            io.write("{ ")
            for i, v in ipairs(value) do
                io.write(v .. (i < #value and ", " or ""))
            end
            io.write(" }")
        end
        io.write(" }\n")
    end
end
printConfig(D)
print("-----")
printConfig(gong(D))