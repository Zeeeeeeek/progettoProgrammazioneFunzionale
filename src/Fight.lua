---- Resolves the fights between all the close Senpais.
---- Returns a new table of Senpais with the winners of the fights and the Senpais that didn't fight.
function evalFights(senpais)
    local newSenpais = cloneTable(senpais)
    for senpaiIndex, senpai in ipairs(newSenpais) do
        local closeSenpaiIndex = findFirstCloseSenpaiIndex(senpai, newSenpais)
        if closeSenpaiIndex ~= -1 then
            local closeSenpai = newSenpais[closeSenpaiIndex]
            local result = fight(senpai, closeSenpai)
            local winner, looser = result[1], result[2]
            logFight(winner, looser)
            local winnerIndex = winner == senpai and senpaiIndex or closeSenpaiIndex
            local looserIndex = winnerIndex == senpaiIndex and closeSenpaiIndex or senpaiIndex
            newSenpais[winnerIndex] = incrementHighestStat(winner)
            table.remove(newSenpais, looserIndex)
        end
    end
    return newSenpais
end

----Returns a new Senpai with the highest stat incremented by 1.
----If there are more than one stat with the highest value, the first one is incremented.
function incrementHighestStat(senpai)
    local newSenpai = cloneTable(senpai)
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

----Resolves the fight between the two given Senpais. Returns a table containing the winner and the looser.
function fight(firstSenpai, secondSenpai)
    local firstSenpaiStats = senpaiStatsSum(firstSenpai)
    local secondSenpaiStats = senpaiStatsSum(secondSenpai)
    if firstSenpaiStats == secondSenpaiStats then
        return handleWithdraw(firstSenpai, secondSenpai)
    end
    return firstSenpaiStats > secondSenpaiStats and { firstSenpai, secondSenpai } or { secondSenpai, firstSenpai }
end

----Sum all the stats of the given Senpai.
function senpaiStatsSum(senpai)
    return senpai[3] + senpai[4] + senpai[5] + senpai[6]
end

----Resolves fight in a withdraw condition
function handleWithdraw(firstSenpai, secondSenpai)
    return withdraw(firstSenpai) > withdraw(secondSenpai) and { firstSenpai, secondSenpai } or { secondSenpai, firstSenpai }
end

----Withdraw formula.
function withdraw(senpai)
    return (((senpai[1] + senpai[2]) * (senpai[1] + senpai[2] - 1)) / 2) + senpai[1] - senpai[2]
end

----Returns the index of the first Senpai that is close to the given Senpai.
----Returns -1 if there is no close Senpai.
function findFirstCloseSenpaiIndex(senpai, senpais)
    for i, otherSenpai in ipairs(senpais) do
        if senpai ~= otherSenpai and isClose(senpai, otherSenpai) then
            return i
        end
    end
    return -1
end

----Returns true if the two given Senpais are close, false otherwise.
----Two Senpais are close if the distance between them is less or equal to 1.
function isClose(firstSenpai, secondSenpai)
    return math.abs(firstSenpai[1] - secondSenpai[1]) <= 1 and math.abs(firstSenpai[2] - secondSenpai[2]) <= 1
end

function logFight(winner, looser)
    print("Senpai at {" .. winner[1] .. ", " .. winner[2] .. "} defeated senpai at {" .. looser[1] .. ", " .. looser[2] .. "}")
end