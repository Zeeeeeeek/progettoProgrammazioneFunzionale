----Collects all objects in the same cell as a senpai and increments the senpai's corresponding stat.
----Returns a new config with the collected objects removed and the senpais' stat incremented.
function collectObjects(config)
    local newConfig = cloneTable(config)
    for i, _ in ipairs(newConfig["S"]) do
        local objects = findObjectsInSameCell(newConfig["S"][i], newConfig)
        for j = 1, #objects do
            k = objects[#objects - j + 1]
            table.remove(newConfig[k[2]], k[1])
            logObjectCollected(newConfig["S"][i], k[2])
            newConfig["S"][i] = incrementSenpaiStat(newConfig["S"][i], k[2])
        end
    end
    return newConfig
end

----Increments the senpai's stat corresponding to the specified object type.
----Returns a new senpai with the stat incremented.
function incrementSenpaiStat(senpai, objectType)
    local newSenpai = cloneTable(senpai)
    local objectTypes = { U = 3, C = 4, G = 5, R = 6 }
    newSenpai[objectTypes[objectType]] = newSenpai[objectTypes[objectType]] + 1
    return newSenpai
end

----Returns a table containing the index and the type of the objects found in the same cell as the senpai.
----Returns an empty table if no object is found.
function findObjectsInSameCell(senpai, config)
    local objectTypes = { "U", "C", "G", "R" }
    local result = {}
    for _, objectType in ipairs(objectTypes) do
        local objects = config[objectType]
        for i, object in ipairs(objects) do
            if sameCell(senpai, object) then
                table.insert(result, { i, objectType })
            end
        end
    end
    return result
end

----Returns true if the senpai and the object are in the same cell.
function sameCell(senpai, object)
    return senpai[1] == object[1] and senpai[2] == object[2]
end

function logObjectCollected(senpai, objectType)
    local t = { U = "pot", C = "sword", G = "tissue", R = "broom" }
    print("Senpai at {" .. senpai[1] .. ", " .. senpai[2] .. "} collected a " .. t[objectType])
end