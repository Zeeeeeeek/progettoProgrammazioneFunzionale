N = 10
D = {
    S = { { 8, 3, 0, 0, 0, 0 }, { 3, 4, 0, 0, 0, 0 }, { 4, 1, 0, 0, 0, 0 }, { 3, 2, 0, 0, 0, 0 } },
    U = { { 8, 4 }, { 1, 1 } },
    C = { { 3, 8 } },
    G = { { 4, 3 } },
    R = { { 8, 7 }, { 6, 1 }, { 4, 5 } }
}
NoObjects = {
    S = { { 8, 4, 0, 0, 0, 0 }, { 3, 4, 0, 0, 0, 0 }, { 4, 1, 0, 0, 0, 0 }, { 3, 2, 0, 0, 0, 0 } },
    U = { },
    C = { },
    G = { },
    R = { }
}
OneObject = {
    S = { { 8, 4, 0, 0, 0, 0 }, { 3, 4, 0, 0, 0, 0 }, { 4, 1, 0, 0, 0, 0 }, { 3, 2, 0, 0, 0, 0 } },
    U = { },
    C = { },
    G = { { 3, 8 } },
    R = { }
}

require("Lists")
require("Fight")
require("Move")
require("Objects")

function play(config)
    printConfig(config)
    print("--------------------------------------------------\n")
    if isFinalConfig(config) then
        return config
    else
        return play(gong(config))
    end
end

function isFinalConfig(config)
    return #config["S"] == 1 and not objectsArePresents(config)
end

function gong(config)
    local newConfig = collectObjects(config)
    newConfig["S"] = evalFights(newConfig["S"])
    return move(newConfig, N, 1)
end

function printConfig(config)
    local keys = {"S", "U", "C", "G", "R"}
    for _, key in ipairs(keys) do
        io.write(key .. " = { ")
        for _, value in ipairs(config[key]) do
            io.write("{ ")
            for i, v in ipairs(value) do
                io.write(v .. (i < #value and ", " or ""))
            end
            io.write(" }")
        end
        print(" }")
    end
end

play(OneObject, 0)

