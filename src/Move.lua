----Moves all Senpais to their closest objective. If there are objects left, Senpais will move to the closest object.
----If there are no objects left, Senpais will move to the closest Senpai.
----Returns a new config with the moved Senpais.
function move(config)
    local newConfig = cloneList(config)
    for senpaiIndex, senpai in ipairs(newConfig["S"]) do
        local objectives = {}
        if objectsArePresents(newConfig) then
            --There are objects left, we try to move Senpais to their closest object
            objectives = listOfAllObjectsPositions(newConfig)
        else
            --There are no objects left, we try to move Senpais to their closest Senpai
            if #newConfig["S"] == 1 then
                return newConfig --There is only one Senpai left, no need to move it
            end
            objectives = senpaisListWithoutSenpai(newConfig["S"], senpaiIndex)
        end
        objectivesAndDistances = map(
                function(objective)
                    return { objective, distanceFrom(senpai, objective) }
                end, objectives
        )
        local destination = extractMin(objectivesAndDistances)[1]
        newConfig["S"] = moveSenpaiTo(newConfig["S"], destination, senpaiIndex)
    end
    return newConfig
end

----Returns a list of all senpais without the senpai at the given index.
function senpaisListWithoutSenpai(senpais, senpaiIndex)
    local newSenpais = cloneList(senpais)
    table.remove(newSenpais, senpaiIndex)
    return newSenpais
end

----Returns true if there are objects in the given config, false otherwise.
function objectsArePresents(config)
    return #config["U"] + #config["C"] + #config["G"] + #config["R"] > 0
end

----Moves the Senpai at the given index to the given destination.
function moveSenpaiTo(senpais, destination, senpaiIndex)
    local newSenpais = cloneList(senpais)
    local senpaiToMove = newSenpais[senpaiIndex]
    if senpaiToMove[1] == destination[1] and senpaiToMove[2] == destination[2] then
        return newSenpais
    end
    local newX, newY
    if destination[1] ~= senpaiToMove[1] then
        newX = destination[1] > senpaiToMove[1] and senpaiToMove[1] + 1 or senpaiToMove[1] - 1
        newY = senpaiToMove[2]
    else
        if destination[2] ~= senpaiToMove[2] then
            newX = senpaiToMove[1]
            newY = destination[2] > senpaiToMove[2] and senpaiToMove[2] + 1 or senpaiToMove[2] - 1
        end
    end
    newSenpais[senpaiIndex] = { newX, newY, senpaiToMove[3], senpaiToMove[4], senpaiToMove[5], senpaiToMove[6] }
    return newSenpais
end

----Returns the distance between the two given positions.
function distanceFrom(from, to)
    return math.abs(from[1] - to[1]) + math.abs(from[2] - to[2])
end

----Give a table which elements are of the form {{elementX, elementY}, distance} returns a list containing the object with
----the smallest distance and its distance.
function extractMin(t)
    return reduce(function(x, y)
        return x[2] < y[2] and x or y
    end, t[1], t)
end