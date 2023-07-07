function move(config)
    local newConfig = cloneList(config)
    for senpaiIndex, senpai in ipairs(newConfig["S"]) do
        if objectsArePresents(newConfig) then
            --Objects are presents, we try to move Senpais to their closest object
            local objectAndDistances = map(
                    function(object)
                        return { object, distanceFrom(senpai, object) }
                    end, listOfAllObjectsPositions(newConfig)
            )
            local destination = extractMin(objectAndDistances)[1]
            newConfig["S"] = moveSenpaiTo(newConfig["S"], destination, senpaiIndex)
        else
            --There are no objects left, we try to move Senpais to their closest Senpai
            if #newConfig["S"] == 1 then
                return newConfig --There is only one Senpai left, it's the final config
            end
            local senpaisAndDistances = map(
                    function(senpai)
                        return { senpai, distanceFrom(senpai, senpai) }
                    end, senpaisListWithoutSenpai(newConfig["S"], senpaiIndex)
            )
            local destination = extractMin(senpaisAndDistances)[1]
            newConfig["S"] = moveSenpaiTo(newConfig["S"], destination, senpaiIndex)
        end
    end
    return newConfig
end

function senpaisListWithoutSenpai(senpais, senpaiIndex)
    local newSenpais = cloneList(senpais)
    table.remove(newSenpais, senpaiIndex)
    return newSenpais
end

function objectsArePresents(config)
    return #config["U"] + #config["C"] + #config["G"] + #config["R"] > 0
end

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
        else
            --The senpai is already in the same cell of the object
            return newSenpais
        end
    end
    newSenpais[senpaiIndex] = { newX, newY, senpaiToMove[3], senpaiToMove[4], senpaiToMove[5], senpaiToMove[6] }
    return newSenpais
end

function distanceFrom(from, to)
    return math.abs(from[1] - to[1]) + math.abs(from[2] - to[2])
end

function extractMin(t)
    return reduce(function(x, y)
        return x[2] < y[2] and x or y
    end, t[1], t)
end