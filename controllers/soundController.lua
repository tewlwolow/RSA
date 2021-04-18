local this = {}

local modversion = require("Resdayn Sonorant Apparati\\version")
local version = modversion.version
local config = require("Resdayn Sonorant Apparati.config")
local debugLogOn = config.debugLogOn

local function debugLog(string)
    if debugLogOn then
       mwse.log("[Resdayn Sonorant Apparati "..version.."] Sound Controller: "..string)
    end
end

function this.playMusic(path, actor)
    tes3.playSound{
        soundPath = path,
        reference = actor
    }
    debugLog("Playing music: "..path)
end


return this