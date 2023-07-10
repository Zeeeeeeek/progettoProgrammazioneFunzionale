----Collects all objects in the same cell as a senpai and increments the senpai's corresponding stat.
----This function assumes that there is only one object in the same cell.
----Returns a new config with the collected objects removed and the senpais' stat incremented.
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

----Increments the senpai's stat corresponding to the specified object type.
----Returns a new senpai with the stat incremented, or the same senpai if the object type is not valid.
function incrementSenpaiStat(senpai, objectType)
    local newSenpai = cloneList(senpai)
    local objectTypes = { "U", "C", "G", "R" }
    for k, v in pairs(objectTypes) do
        if v == objectType then
            logObjectCollected(newSenpai, objectType)
            newSenpai[k + 2] = newSenpai[k + 2] + 1
        end
    end
    return newSenpai
end

----Returns the index and the type of the first object found in the same cell as the senpai.
----Returns -1 and "N" if no object is found.
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
    return -1, "N"
end

----Returns true if the senpai and the object are in the same cell.
function sameCell(senpai, object)
    return senpai[1] == object[1] and senpai[2] == object[2]
end

function logObjectCollected(senpai, objectType)
    io.write("Senpai at {" .. senpai[1] .. ", " .. senpai[2] .. "} collected a ")
    local t = { U = "pot", C = "sword", G = "handkerchief", R = "broom" }
    for k, v in pairs(t) do
        if objectType == k then
            io.write(v)
            break
        end
    end
    io.write("\n")
end