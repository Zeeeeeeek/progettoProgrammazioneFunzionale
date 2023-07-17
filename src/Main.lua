require("TableUtils")
require("Fight")
require("Move")
require("Objects")

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

N = 10
D = {
    S = { { 1, 1, 0, 0, 0, 0 }, { 3, 8, 0, 0, 0, 0 }, { 4, 1, 0, 0, 0, 0 }, { 9, 6, 0, 0, 0, 0 } },
    U = { { 1, 1 }, { 1, 1 } },
    C = { { 5, 1 }, { 9, 9 } },
    G = { { 4, 3 } },
    R = { { 8, 7 }, { 6, 1 }, { 4, 5 } }
}

E = 10
ERRORCONF = {
    S = { { 1, 1, 0, 0, 0, 0 }, { 1, 0, 0, 0, 0, 0 }, { 4, 1, 0, 0, 0, 0 }, { 9, 6, 0, 0, 0, 0 } },
    U = { { 11, 1 }, { 1, 1 } },
    C = { { 5, 1 }, { 9, 9 } },
    G = { { 4, 3 } },
    R = { { 8, 7 }, { 6, 1 }, { 4, 5 } }
}

N1 = 10
D1 = {
		S = {{9, 5, 0, 0, 0, 0}, {2, 9, 0, 0, 0, 0}, {8, 9, 0, 0, 0, 0}},
        U = {{9, 5}},
		C = {{8, 3}, {7, 9}},
		G = {},
		R = {{5, 3}}
}

N2 = 10
D2 = {
		S = {{8, 6, 0, 0, 0, 0}, {1, 8, 0, 0, 0, 0}, {6, 9, 0, 0, 0, 0}, {3, 9, 0, 0, 0, 0}},
		U = {},
		C = {{8, 9}, {5, 0}},
		G = {{8, 8}, {4, 6}, {5, 4}},
		R = {{6, 9}}
}

printConfig(run(D, N))