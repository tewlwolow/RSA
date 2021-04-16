-- A main file to load modules and register MCM

local modversion = require("Resdayn Sonorant Apparati.version")
local version = modversion.version

local function init()
    mwse.log("[Resdayn Sonorant Apparati] Resdayn Sonorant Apparati version "..version.." initialised.")

    local function getData()
        tes3.player.data.RSA = tes3.player.data.RSA or {}
    end
    event.register("loaded", getData)

    local data = require("Resdayn Sonorant Apparati\\data\\data")
    local i = 0
    for _, instrument in pairs(data.instruments) do
        for _, mode in pairs(data.modes[instrument.culture]) do
            local spacelessModeName = mode.name:gsub("%s+", "")
            local specelessInstrumentType = instrument.type:gsub("%s+", ""):lower()
            i = i + 1
            instrument.modes[i].name = mode.name
            instrument.modes[i].description = mode.description
            instrument.modes[i].riff1 = "RSA//"..instrument.culture.."//"..specelessInstrumentType.."//modes//"..mode.name.."//rsa_"..instrument.type:lower().."_"..spacelessModeName:lower().."1.wav"
            instrument.modes[i].riff2 = "RSA//"..instrument.culture.."//"..specelessInstrumentType.."//modes//"..mode.name.."//rsa_"..instrument.type:lower().."_"..spacelessModeName:lower().."2.wav"
            instrument.modes[i].riff3 = "RSA//"..instrument.culture.."//"..specelessInstrumentType.."//modes//"..mode.name.."//rsa_"..instrument.type:lower().."_"..spacelessModeName:lower().."3.wav"
        end
        i = 0
    end


    local config=require("Resdayn Sonorant Apparati.config")
    local tooltipsOn = config.tooltipsOn
    local hitsOn = config.hitsOn
    local staticNamesOn = config.staticNamesOn

    -- Load main UI controller
    mwse.log("[Resdayn Sonorant Apparati "..version.."] Loading file: UIController.lua")
    dofile("Data Files\\MWSE\\mods\\Resdayn Sonorant Apparati\\controllers\\UIController.lua")

    -- Load main equip controller
    mwse.log("[Resdayn Sonorant Apparati "..version.."] Loading file: equipInstrument.lua")
    local equipInstrument = require("Resdayn Sonorant Apparati\\shared\\equipInstrument")
    event.register("loaded", equipInstrument.getEquipData)
    event.register("equip", equipInstrument.onEquip)

    -- Load modules per config settings --
    if tooltipsOn then
        mwse.log("[Resdayn Sonorant Apparati "..version.."] Loading file: tooltipsCompleteInterop.lua")
        dofile("Data Files\\MWSE\\mods\\Resdayn Sonorant Apparati\\misc\\tooltipsCompleteInterop.lua")
    end

    if hitsOn then
        mwse.log("[Resdayn Sonorant Apparati "..version.."] Loading file: hits.lua")
        dofile("Data Files\\MWSE\\mods\\Resdayn Sonorant Apparati\\misc\\hits.lua")
    end

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
