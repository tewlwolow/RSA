local this = {}

local modversion = require("Resdayn Sonorant Apparati\\version")
local version = modversion.version
local config = require("Resdayn Sonorant Apparati.config")
local debugLogOn = config.debugLogOn
--local animController = require("Resdayn Sonorant Apparati\\controllers\\animationController")

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
    --[[animController.playAnimation(actor, tes3.animationStartFlag.immediate, tes3.player.data.RSA.equipped.animation.idle, tes3.animationGroup.idle9)
    animController.attachInstrument(tes3.player.data.RSA.equipped, actor)]]
    tes3.playSound{
        soundPath = path,
        reference = actor
    }
    debugLog("Playing music: "..path)
end


return this