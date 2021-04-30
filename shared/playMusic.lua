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

-- Remove currently played music - mainly for switching from composition to improvisation mode --
function this.removeMusic(actor)
    tes3.removeSound{
        sound = tes3.player.data.RSA.currentSound,
        reference = actor
    }
end

-- This function controls the currently played track --
function this.playMusic(path, actor)
    -- Remove the previous stored track --
    tes3.removeSound{
        sound = tes3.player.data.RSA.currentSound,
        reference = actor
    }

    -- Play the current track --
    tes3.playSound{
        soundPath = path,
        reference = actor
    }

    debugLog("Playing music: "..path)

    -- Store the current track length for animation control --
    local length = trackLength.getTrackLength(path)
    debugLog("Current music track length: "..length)
    tes3.player.data.RSA.riffLength = length
end

return this