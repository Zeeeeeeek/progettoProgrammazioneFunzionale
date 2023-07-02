require("Lists")
function evalFights(senpais)
    local newSenpais = cloneList(senpais)
    for _, senpai in ipairs(newSenpais) do
        local closeSenpai = findFirstCloseSenpai(senpai, newSenpais)
        if #closeSenpai ~= 0 then
            local looser, winner = fight(senpai, closeSenpai)
            table.remove(newSenpais, findIndex(newSenpais, looser))
            table.remove(newSenpais, findIndex(newSenpais, winner))
            table.insert(newSenpais, incrementHighestStat(winner))
        end
    end
    return newSenpais
end

----incrementa la statistica più alta del senpai, restituisce il un nuovo senpai.
----Se ci sono più statistiche con lo stesso valore, incrementa la prima che trova
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

----restituisce lo sconfitto e il vincitore
function fight(firstSenpai, secondSenpai)
    local firstSenpaiStats = getSenpaiStats(firstSenpai)
    local secondSenpaiStats = getSenpaiStats(secondSenpai)
    if firstSenpaiStats == secondSenpaiStats then
        return handleWithdraw(firstSenpai, secondSenpai)
    end
    if firstSenpaiStats > secondSenpaiStats then
        return secondSenpai, firstSenpai
    end
    return firstSenpai, secondSenpai
end

function getSenpaiStats(senpai)
    return senpai[3] + senpai[4] + senpai[5] + senpai[6]
end

function handleWithdraw(firstSenpai, secondSenpai)
    if withdraw(firstSenpai) > withdraw(secondSenpai) then
        return secondSenpai, firstSenpai
    end
    return firstSenpai, secondSenpai
end

function withdraw(senpai)
    return (((senpai[1]+senpai[2]) * (senpai[1] + senpai[2] -1) ) / 2) + senpai[1] - senpai[2]
end

--Restituisce il primo senpai vicino, se non c'è nessuno restituisce una lista vuota
function findFirstCloseSenpai(senpai, senpais)
    for _, otherSenpai in ipairs(senpais) do
        if senpai ~= otherSenpai and isClose(senpai, otherSenpai) then
            return otherSenpai
        end
    end
    return { }
end

function isClose(firstSenpai, secondSenpai)
    return math.abs(firstSenpai[1] - secondSenpai[1]) <= 1 and math.abs(firstSenpai[2] - secondSenpai[2]) <= 1
end