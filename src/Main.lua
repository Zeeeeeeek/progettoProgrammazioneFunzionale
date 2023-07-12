require("Input")
require("TableUtils")
require("Fight")
require("Move")
require("Objects")

----Play the game until the config is final.
function run(config, N)
    if not isValidConfig(config, N) then
        print("Invalid config")
        return config
    end
    local function play(conf)
        if isFinalConfig(conf) then
            return conf
        end
        printConfig(conf)
        return play(gong(conf))
    end
    return play(config)
end

function isValidConfig(config, N)
    local function isOutOfBounds(position)
        return (position[1] < 0 or position[1] >= N) or (position[2] < 0 or position[2] >= N)
    end
    for _, senpai in ipairs(config["S"]) do
        if senpaiStatsSum(senpai) > 0 then
            return false
        end
    end
    return #config["S"] > 0 and (#filter(map(function(e)
        return { e[1], e[2] }
    end, config["S"]), isOutOfBounds) +
            #filter(tableOfAllObjectsPositions(config), isOutOfBounds)) <= 0
end

----A config is final if there is only one Senpai left and there are no objects left.
function isFinalConfig(config)
    return #config["S"] == 1 and not objectsArePresents(config)
end

----Move the game forward by one round by collecting objects, resolving fights and moving Senpais.
function gong(config)
    local newConfig = collectObjects(config)
    newConfig["S"] = evalFights(newConfig["S"])
    return move(newConfig)
end

function printConfig(config)
    local keys = { "S", "U", "C", "G", "R" }
    for _, key in ipairs(keys) do
        io.write(key .. " = { ")
        for j, value in ipairs(config[key]) do
            io.write("{ ")
            for i, v in ipairs(value) do
                io.write(v .. (i < #value and ", " or ""))
            end
            io.write(" }")
            if j < #config[key] then
                io.write(", ")
            end
        end
        print(" }")
    end
    print("-------------------------------------------------------")
end

function runAll(configs)
    return map(function(config)
        return run(config["D"], config["N"])
    end, configs)
end

function printAll(configs)
    for _, config in ipairs(configs) do
        printConfig(config)
    end
end

--printAll(runAll(loadConfig()))
N = 10
D = {
    S = { { 1, 1, 0, 0, 1, 0 }, { 3, 8, 0, 0, 0, 0 }, { 4, 1, 0, 0, 0, 0 }, { 9, 6, 0, 0, 0, 0 } },
    U = { { 1, 1 }, { 1, 1 } },
    C = { { 5, 1 }, { 9, 9 } },
    G = { { 4, 3 } },
    R = { { 8, 7 }, { 6, 1 }, { 4, 5 } }
}

--printConfig(run(D, N))


E = 10
ERRORCONF = {
    S = { { 1, 1, 1, 0, 0, 0 }, { 3, 8, 0, 0, 0, 0 }, { 4, 1, 0, 0, 0, 0 }, { 9, 6, 0, 0, 0, 0 } },
    U = { { 2, 1 }, { 1, 1 } },
    C = { { 5, 1 }, { 9, 9 } },
    G = { { 4, 3 } },
    R = { { 8, 7 }, { 6, 1 }, { 4, 5 } }
}

--printConfig(run(ERRORCONF, E))


T = 10
TESTCONFIG = {
    S = { { 1, 1, 0, 0, 0, 0 }, { 1, 2, 0, 0, 0, 0 }, { 2, 2, 0, 0, 0, 0 } },
    U = { },
    C = { },
    G = { },
    R = { }
}

printConfig(run(TESTCONFIG, T))