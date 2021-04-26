-- A main file to load modules and register MCM
local modversion = require("Resdayn Sonorant Apparati.version")
local version = modversion.version

local function init()
    local config = require("Resdayn Sonorant Apparati.config")
    local debugLogOn = config.debugLogOn
    local function debugLog(string)
        if debugLogOn then
        mwse.log("[Resdayn Sonorant Apparati "..version.."] Main file: "..string)
        end
    end
    debugLog("Mod initialised.")

    -- Load player data on loaded --
    local function getData()
        tes3.player.data.RSA = tes3.player.data.RSA or {}
    end
    event.register("loaded", getData, {priority = 50})

    -- Store currently played sound --
    local function soundPlayed(e)
        --mwse.log("(%s) Reference: %s; Sound: %s; Path: '%s'; Flags: 0x%x; Volume: %.2f; Pitch: %.2f; isVoiceover: %s", e.eventType, e.reference, e.sound, e.path, e.flags, e.volume / 250, e.pitch, e.isVoiceover)
        if (e.path) and (string.find(e.path, "RSA")) then
            tes3.player.data.RSA.currentSound =  e.sound
        end
    end
    event.register("addTempSound", soundPlayed)

    -- Get proper data structure - create paths for modes and riffs per culture --
    local data = require("Resdayn Sonorant Apparati\\data\\data")
    local i = 0
    local riffPath = "Vo\\RSA\\"
    for _, instrument in pairs(data.instruments) do
        for _, mode in pairs(data.modes[instrument.culture]) do
            local spacelessModeName = mode.name:gsub("%s+", "")
            local spacelessInstrumentType = instrument.type:gsub("%s+", ""):lower()
            i = i + 1
            instrument.modes[i].name = mode.name
            instrument.modes[i].description = mode.description
            instrument.modes[i].riff1 = riffPath..instrument.culture.."\\"..spacelessInstrumentType.."\\modes\\"..mode.name:lower().."\\rsa_"..instrument.name:lower().."_"..spacelessModeName:lower().."-riff1.mp3"
            instrument.modes[i].riff2 = riffPath..instrument.culture.."\\"..spacelessInstrumentType.."\\modes\\"..mode.name:lower().."\\rsa_"..instrument.name:lower().."_"..spacelessModeName:lower().."-riff2.mp3"
            instrument.modes[i].riff3 = riffPath..instrument.culture.."\\"..spacelessInstrumentType.."\\modes\\"..mode.name:lower().."\\rsa_"..instrument.name:lower().."_"..spacelessModeName:lower().."-riff3.mp3"
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
