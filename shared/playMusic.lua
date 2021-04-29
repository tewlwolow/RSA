local this = {}

local modversion = require("Resdayn Sonorant Apparati\\version")
local version = modversion.version
local config = require("Resdayn Sonorant Apparati.config")
local debugLogOn = config.debugLogOn
local trackLength = require("Resdayn Sonorant Apparati\\shared\\trackLength")

local function debugLog(string)
    if debugLogOn then
       mwse.log("[Resdayn Sonorant Apparati "..version.."] Play Music: "..string)
    end
end

function this.playMusic(path, actor)
    tes3.removeSound{
        sound = tes3.player.data.RSA.currentSound,
        reference = actor
    }

    tes3.playSound{
        soundPath = path,
        reference = actor
    }
    debugLog("Playing music: "..path)
    local length = trackLength.getTrackLength(path)
    debugLog("Current music track length: "..length)
    tes3.player.data.RSA.riffLength = length
end


return this