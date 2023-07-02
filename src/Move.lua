function dmove(config)
    local currentObjectsPositions = listOfAllObjectsPositions(config)
    for _, senpai in pairs(config["S"]) do
        local t = map(function(object)
            return { object, distanceFromObject(senpai, object) }
        end, currentObjectsPositions)
        local a = extractClosestObject(t)[1]
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
            return { object, distanceFromObject(newConfig["S"][senpaiIndex], object) }
        end, listOfAllObjectsPositions(newConfig))
        local destination = extractClosestObject(objectAndDistances)[1]
        --io.write("{ " .. destination[1] .. " " .. destination[2] .. " } ")
        newConfig["S"] = moveSenpaiTo(newConfig["S"], destination, senpaiIndex)
        io.write("New config:\n")
        printConfig(newConfig)
    else
        --We try to move Senpais to their closest Senpai
        --Temporarily we return the same config
        print("Same config")
        return newConfig
    end

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
    --We now check if the new position is occupied by another senpai
    io.write("New position: " .. newX .. " " .. newY .. "\n")
    newSenpais[senpaiIndex] = { newX, newY, senpaiToMove[3], senpaiToMove[4], senpaiToMove[5], senpaiToMove[6] }
    return newSenpais
end

function distanceFromObject(senpai, object)
    return math.abs(senpai[1] - object[1]) + math.abs(senpai[2] - object[2])
end

function printObjectAndDistance(t)
    for _, v in ipairs(t) do
        --print v type
        io.write("{ " .. v[1][1] .. " " .. v[1][2] .. " } ")
        io.write(v[2] .. " ")
    end
    io.write("\n")
end

function extractClosestObject(t)
    return reduce(function(x, y)
        return x[2] < y[2] and x or y
    end, t[1], t)
end