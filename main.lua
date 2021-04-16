-- A main file to load modules and register MCM
local modversion = require("Resdayn Sonorant Apparati.version")
local version = modversion.version

local function init()
    mwse.log("[Resdayn Sonorant Apparati] Resdayn Sonorant Apparati version "..version.." initialised.")

    -- Load player data on loaded --
    local function getData()
        tes3.player.data.RSA = tes3.player.data.RSA or {}
    end
    event.register("loaded", getData, {priority = 50})

    -- Get proper data structure - create paths for modes and riffs per culture --
    local data = require("Resdayn Sonorant Apparati\\data\\data")
    local i = 0
    for _, instrument in pairs(data.instruments) do
        for _, mode in pairs(data.modes[instrument.culture]) do
            local spacelessModeName = mode.name:gsub("%s+", "")
            local spacelessInstrumentType = instrument.type:gsub("%s+", ""):lower()
            i = i + 1
            instrument.modes[i].name = mode.name
            instrument.modes[i].description = mode.description
            instrument.modes[i].riff1 = "RSA//"..instrument.culture.."//"..spacelessInstrumentType.."//modes//"..mode.name.."//rsa_"..instrument.type:lower().."_"..spacelessModeName:lower().."1.wav"
            instrument.modes[i].riff2 = "RSA//"..instrument.culture.."//"..spacelessInstrumentType.."//modes//"..mode.name.."//rsa_"..instrument.type:lower().."_"..spacelessModeName:lower().."2.wav"
            instrument.modes[i].riff3 = "RSA//"..instrument.culture.."//"..spacelessInstrumentType.."//modes//"..mode.name.."//rsa_"..instrument.type:lower().."_"..spacelessModeName:lower().."3.wav"
        end
        i = 0
    end

    -- Load config --
    local config=require("Resdayn Sonorant Apparati.config")
    local tooltipsOn = config.tooltipsOn
    local hitsOn = config.hitsOn
    local staticNamesOn = config.staticNamesOn

    -- Load main UI controller --
    mwse.log("[Resdayn Sonorant Apparati "..version.."] Loading file: UIController.lua")
    dofile("Data Files\\MWSE\\mods\\Resdayn Sonorant Apparati\\controllers\\UIController.lua")

    -- Load main equip functionalities --
    mwse.log("[Resdayn Sonorant Apparati "..version.."] Loading file: equipController.lua")
    dofile("Data Files\\MWSE\\mods\\Resdayn Sonorant Apparati\\controllers\\equipController.lua")

    -- Load modules per config settings --

    -- Tooltips Complete interop --
    if tooltipsOn then
        mwse.log("[Resdayn Sonorant Apparati "..version.."] Loading file: tooltipsCompleteInterop.lua")
        dofile("Data Files\\MWSE\\mods\\Resdayn Sonorant Apparati\\misc\\tooltipsCompleteInterop.lua")
    end

    -- Hit instruments module --
    if hitsOn then
        mwse.log("[Resdayn Sonorant Apparati "..version.."] Loading file: hits.lua")
        dofile("Data Files\\MWSE\\mods\\Resdayn Sonorant Apparati\\misc\\hits.lua")
    end

    -- Static names module --
    if staticNamesOn then
        mwse.log("[Resdayn Sonorant Apparati "..version.."] Loading file: staticNames.lua")
        dofile("Data Files\\MWSE\\mods\\Resdayn Sonorant Apparati\\misc\\staticNames.lua")
    end

end

-- Register MCM menu --
event.register("modConfigReady", function()
    dofile("Data Files\\MWSE\\mods\\Resdayn Sonorant Apparati\\mcm.lua")
end)

event.register("initialized", init)
