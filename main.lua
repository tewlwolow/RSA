-- A main file to load modules and register MCM

local modversion = require("Resdayn Sonorant Apparati.version")
local version = modversion.version

local function getData()
    tes3.player.data.RSA = tes3.player.data.RSA or {}
end

local function init()

    event.register("loaded", getData)

    mwse.log("[Resdayn Sonorant Apparati] Resdayn Sonorant Apparati version "..version.." initialised.")

    local config=require("Resdayn Sonorant Apparati.config")
    local tooltipsOn = config.tooltipsOn
    local hitsOn = config.hitsOn
    local staticNamesOn = config.staticNamesOn

    -- Load main UI controller
    mwse.log("[Resdayn Sonorant Apparati "..version.."] Loading file: UIController.lua")
    dofile("Data Files\\MWSE\\mods\\Resdayn Sonorant Apparati\\UIController.lua")

    -- Load main equip controller
    mwse.log("[Resdayn Sonorant Apparati "..version.."] Loading file: equipInstrument.lua")
    dofile("Data Files\\MWSE\\mods\\Resdayn Sonorant Apparati\\action\\equipInstrument.lua")


    -- Load modules per config settings --
    if tooltipsOn then
        mwse.log("[Resdayn Sonorant Apparati "..version.."] Loading file: tooltipsCompleteInterop.lua")
        dofile("Data Files\\MWSE\\mods\\Resdayn Sonorant Apparati\\tooltipsCompleteInterop.lua")
    end

    if hitsOn then
        mwse.log("[Resdayn Sonorant Apparati "..version.."] Loading file: hits.lua")
        dofile("Data Files\\MWSE\\mods\\Resdayn Sonorant Apparati\\hits.lua")
    end

    if staticNamesOn then
        mwse.log("[Resdayn Sonorant Apparati "..version.."] Loading file: staticNames.lua")
        dofile("Data Files\\MWSE\\mods\\Resdayn Sonorant Apparati\\staticNames.lua")
    end

end

-- Register MCM menu --
event.register("modConfigReady", function()
    dofile("Data Files\\MWSE\\mods\\Resdayn Sonorant Apparati\\mcm.lua")
end)

event.register("initialized", init)
