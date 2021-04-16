local this = {}

local modversion = require("Resdayn Sonorant Apparati\\version")
local version = modversion.version
local config = require("Resdayn Sonorant Apparati.config")
local debugLogOn = config.debugLogOn
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

        local equipInstrument = require("Resdayn Sonorant Apparati\\action\\equipInstrument")
        tes3.player.data.RSA.equipped = nil
        equipInstrument.equip(actor, instrument)
    end
    event.unregister("key", this.cancelAnimation())
end

function this.playAnimation(instrument, playerMesh, actor, start, animType)
    debugLog("Playing animation for instrument: "..instrument.name)
    event.register("key", function (e)
        this.cancelAnimation(e, playerMesh, instrument, actor)
    end,
        {filter = tes3.scanCode.x}
    )

    tes3.playAnimation({
        reference = actor,
        group = tes3.animationGroup.idle9,
        mesh = animType,
        startFlag = start,
    })

    --[[local node = actor.sceneNode:getObjectByName("Attach Instrument")
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
        debugLog("[Resdayn Sonorant Apparati] Attach Instrument node is nil!")
    end]]

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
            debugLog("[Resdayn Sonorant Apparati] Attach Instrument node is nil!")
        end
        event.unregister("playGroup", this.attachInstrument)
    end

end

function this.startImprovCycle(instrument, playerMesh, actor)

    this.playAnimation(instrument, playerMesh, actor, tes3.animationStartFlag.immediate, instrument.animation.equip)

    timer.delayOneFrame(function()
        this.playAnimation(instrument, playerMesh, actor, tes3.animationStartFlag.normal, instrument.animation.idle)
        event.register("playGroup", function (e)
            this.attachInstrument(e, instrument, actor)
        end)
    end)

end

return this
