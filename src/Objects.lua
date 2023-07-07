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