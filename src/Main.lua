require("TableUtils")
require("Fight")
require("Move")
require("Objects")
require("Input")

----Play the game until the config is final.
----Returns the final config.
----If the config is invalid, returns the config.
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

----Returns true if the config is valid. A config is valid if:
----    - There is at least one Senpai.
----    - There is no Senpai with a stat sum greater than 0.
----    - There is no object or Senpai out of bounds.
function isValidConfig(config, N)
    local function isOutOfBounds(position)
        return (position[1] < 0 or position[1] >= N) or (position[2] < 0 or position[2] >= N)
    end
    return reduce(function(a, b)
        return a + b
    end, 0, map(senpaiStatsSum, config["S"])) == 0 and #config["S"] > 0 and (#filter(map(function(e)
        return { e[1], e[2] }
    end, config["S"]), isOutOfBounds) +
            #filter(tableOfAllObjectsPositions(config), isOutOfBounds)) == 0
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

printConfig(run(D, N))