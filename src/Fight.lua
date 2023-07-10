---- Resolves the fights between all the close Senpais.
---- Returns a new list of Senpais with the winners of the fights and the Senpais that didn't fight.
function evalFights(senpais)
    local newSenpais = cloneList(senpais)
    for i, senpai in ipairs(newSenpais) do
        local closeSenpai = findFirstCloseSenpai(senpai, newSenpais)
        if #closeSenpai ~= 0 then
            local looser = fight(senpai, closeSenpai)
            local winner = looser == senpai and closeSenpai or senpai
            logFight(winner, looser)
            --Remove both senpais todo: check findIndex, should be handled when returning -1
            table.remove(newSenpais, findIndex(newSenpais, looser))
            table.remove(newSenpais, i)
            --Add only the winner with the incremented stat
            table.insert(newSenpais, incrementHighestStat(winner))
        end
    end
    return newSenpais
end

----Returns a new Senpai with the highest stat incremented by 1.
----If there are more than one stat with the highest value, the first one is incremented.
function incrementHighestStat(senpai)
    local newSenpai = cloneList(senpai)
    local highestStat = newSenpai[3]
    local highestStatIndex = 3
    for i = 4, 6 do
        if newSenpai[i] > highestStat then
            highestStat = newSenpai[i]
            highestStatIndex = i
        end
    end
    newSenpai[highestStatIndex] = newSenpai[highestStatIndex] + 1
    return newSenpai
end

----Resolves the fight between the two given Senpais. Returns the winner.
function fight(firstSenpai, secondSenpai)
    local firstSenpaiStats = getSenpaiStats(firstSenpai)
    local secondSenpaiStats = getSenpaiStats(secondSenpai)
    if firstSenpaiStats == secondSenpaiStats then
        return handleWithdraw(firstSenpai, secondSenpai)
    end
    return firstSenpaiStats > secondSenpaiStats and secondSenpai or firstSenpai
end

----Sum all the stats of the given Senpai.
function getSenpaiStats(senpai)
    return senpai[3] + senpai[4] + senpai[5] + senpai[6]
end

----Resolves fight in a withdraw condition
function handleWithdraw(firstSenpai, secondSenpai)
    return withdraw(firstSenpai) > withdraw(secondSenpai) and secondSenpai or firstSenpai
end

----Withdraw formula.
function withdraw(senpai)
    return (((senpai[1] + senpai[2]) * (senpai[1] + senpai[2] - 1)) / 2) + senpai[1] - senpai[2]
end

----Returns the first Senpai that is close to the given Senpai. Returns an empty list if there is no close Senpai.
function findFirstCloseSenpai(senpai, senpais)
    for _, otherSenpai in ipairs(senpais) do
        if senpai ~= otherSenpai and isClose(senpai, otherSenpai) then
            return otherSenpai
        end
    end
    return { }
end

----Returns true if the two given Senpais are close, false otherwise.
----Two Senpais are close if the distance between them is less or equal to 1.
function isClose(firstSenpai, secondSenpai)
    return math.abs(firstSenpai[1] - secondSenpai[1]) <= 1 and math.abs(firstSenpai[2] - secondSenpai[2]) <= 1
end

function logFight(winner, looser)
    print("Senpai at {" .. winner[1] .. ", " .. winner[2] .. "} defeated senpai at {" .. looser[1] .. ", " .. looser[2] .. "}")
end