function dmove(config)
    local currentObjectsPositions = listOfAllObjectsPositions(config)
    for _, senpai in pairs(config["S"]) do
        local t = map(function(object)
            return { object, distanceFrom(senpai, object) }
        end, currentObjectsPositions)
        local a = extractMin(t)[1]
        io.write("{ " .. a[1] .. " " .. a[2] .. " } ")
        --io.write(a[2] .. " ")
    end
end

function move(config, N, senpaiIndex)
    local newConfig = cloneList(config)
    if (#config["S"] < senpaiIndex) then
        return newConfig
    end
    if objectsArePresents(newConfig) then
        --We try to move Senpais to their closest object
        local objectAndDistances = map(function(object)
            return { object, distanceFrom(newConfig["S"][senpaiIndex], object) }
        end, listOfAllObjectsPositions(newConfig))
        local destination = extractMin(objectAndDistances)[1]
        --io.write("{ " .. destination[1] .. " " .. destination[2] .. " } ")
        newConfig["S"] = moveSenpaiTo(newConfig["S"], destination, senpaiIndex)
        return move(newConfig, N, senpaiIndex + 1)
    else
        --We try to move Senpais to their closest Senpai
        --Temporarily we return the same config
        if #newConfig["S"] == 1 then
            return newConfig
        end
        print("Move Senpai to Senpai")
        local senpaisAndDistances = map(
                function(senpai)
                        return { senpai, distanceFrom(newConfig["S"][senpaiIndex], senpai) }
        end, senpaisListWithoutSenpai(newConfig["S"], senpaiIndex))
        local destination = extractMin(senpaisAndDistances)[1]
        newConfig["S"] = moveSenpaiTo(newConfig["S"], destination, senpaiIndex)
        return move(newConfig, N, senpaiIndex + 1)
    end
    return newConfig
end

function senpaisListWithoutSenpai(senpais, senpaiIndex)
    local newSenpais = cloneList(senpais)
    table.remove(newSenpais, senpaiIndex)
    return newSenpais
end

function objectsArePresents(config)
    local objectTypes = { "U", "C", "G", "R" }
    for _, objectType in ipairs(objectTypes) do
        if #config[objectType] > 0 then
            return true
        end
    end
    return false
end

--Returns new Senpais
function moveSenpaiTo(senpais, destination, senpaiIndex)
    local newSenpais = cloneList(senpais)
    local senpaiToMove = newSenpais[senpaiIndex]
    local newX, newY
    if destination[1] ~= senpaiToMove[1] then
        newX = destination[1] > senpaiToMove[1] and senpaiToMove[1] + 1 or senpaiToMove[1] - 1
        newY = senpaiToMove[2]
    else
        if destination[2] ~= senpaiToMove[2] then
            newX = senpaiToMove[1]
            newY = destination[2] > senpaiToMove[2] and senpaiToMove[2] + 1 or senpaiToMove[2] - 1
        else --The senpai is already in the same cell of the object
            return newSenpais
        end
    end
    newSenpais[senpaiIndex] = { newX, newY, senpaiToMove[3], senpaiToMove[4], senpaiToMove[5], senpaiToMove[6] }
    return newSenpais
end

function distanceFrom(from, to)
    return math.abs(from[1] - to[1]) + math.abs(from[2] - to[2])
end

function printObjectAndDistance(t)
    for _, v in ipairs(t) do
        --print v type
        io.write("{ " .. v[1][1] .. " " .. v[1][2] .. " } ")
        io.write(v[2] .. " ")
    end
    io.write("\n")
end

function extractMin(t)
    return reduce(function(x, y)
        return x[2] < y[2] and x or y
    end, t[1], t)
end