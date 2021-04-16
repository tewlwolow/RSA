local this = {}

local modversion = require("Resdayn Sonorant Apparati\\version")
local version = modversion.version
local config = require("Resdayn Sonorant Apparati.config")
local debugLogOn = config.debugLogOn
local callback, options

local function debugLog(string)
    if debugLogOn then
       mwse.log("[Resdayn Sonorant Apparati "..version.."] Animation Controller: "..string)
    end
end

function this.cancelAnimation(e, playerMesh, instrument, actor)
    if e.isAltDown then
        debugLog("Cancelling animation, player mesh: "..playerMesh)
        tes3.playAnimation({
            reference = actor,
            mesh = playerMesh,
            group = tes3.animationGroup.idle,
            startFlag = 1
        })
        event.unregister("key", callback, options)
        local equipInstrument = require("Resdayn Sonorant Apparati\\shared\\equipInstrument")
        tes3.player.data.RSA.equipped = nil
        equipInstrument.equip(actor, instrument)
    end
end


function this.playAnimation(instrument, actor, start, animType, animGroup)
    debugLog("Playing animation for instrument: "..instrument.name)

    tes3.playAnimation({
        reference = actor,
        group = animGroup,
        mesh = animType,
        startFlag = start,
    })

end

function this.attachInstrument(e, instrument, actor)

    if e.group == tes3.animationGroup.idle9 then
        local node = actor.sceneNode:getObjectByName("Attach Instrument")
        if node ~= nil then
            local ins = tes3.loadMesh(instrument.mesh):clone()
            ins.name = instrument.name
            ins:clearTransforms()
            actor.sceneNode
            :getObjectByName("Attach Instrument")
            :attachChild(ins, true)
            ins.appCulled = false
            debugLog("Attached instrument node: "..instrument.mesh)
        else
            debugLog("Attach Instrument node is nil!")
        end
        event.unregister("playGroup", this.attachInstrument)
    end

end

function this.startImprovCycle(instrument, playerMesh, actor)

    callback = function(e)
    this.cancelAnimation(e, playerMesh, instrument, actor)
    end
    options = { filter = tes3.scanCode.x }
    event.register("key", callback, options)

    this.playAnimation(instrument, actor, tes3.animationStartFlag.immediate, instrument.animation.equip, tes3.animationGroup.idle8)

    timer.delayOneFrame(function()
        event.register("playGroup", function (e)
            this.attachInstrument(e, instrument, actor)
        end)
        this.playAnimation(instrument, actor, tes3.animationStartFlag.normal, instrument.animation.idle, tes3.animationGroup.idle9)
    end)

end

return this
