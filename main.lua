local modversion = require("RSA.version")
local version = modversion.version

local function init()

    mwse.log("[RSA] Resdayn Sonorant Apparati version "..version.." initialised.")

    local config=require("RSA.config")
    local tooltipsOn = config.tooltipsOn
    local hitsOn = config.hitsOn
    local staticNamesOn = config.staticNamesOn

    -- Load modules per config settings --
    if tooltipsOn then
        mwse.log("[RSA "..version.."] Loading file: tooltipsCompleteInterop.lua")
        dofile("Data Files\\MWSE\\mods\\RSA\\tooltipsCompleteInterop.lua")
    end

    if hitsOn then
        mwse.log("[RSA "..version.."] Loading file: hits.lua")
        dofile("Data Files\\MWSE\\mods\\RSA\\hits.lua")
    end

    if staticNamesOn then
        mwse.log("[RSA "..version.."] Loading file: staticNames.lua")
        dofile("Data Files\\MWSE\\mods\\RSA\\staticNames.lua")
    end

end

-- Register MCM menu --
event.register("modConfigReady", function()
    dofile("Data Files\\MWSE\\mods\\RSA\\mcm.lua")
end)


event.register("initialized", init)