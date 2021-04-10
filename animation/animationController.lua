local this = {}

function this.cancelAnim(e, playerMesh)
    if e.isAltDown then
        tes3.playAnimation({
            reference = tes3.player,
            mesh = playerMesh,
            group = tes3.animationGroup.idle,
            startFlag = 1
        })
        event.unregister("key", this.cancelAnim, {filter = tes3.scanCode.x})
    end
end

function this.playAnim(instrument)

    tes3.playAnimation({
        reference = tes3.player,
        group = tes3.animationGroup.idle9,
        mesh = "",
        startFlag = tes3.animationStartFlag.immediate,
    })


    local ins = tes3.loadMesh(instrument.mesh):clone()
    ins.name = instrument.name
    local node = tes3.player.sceneNode:getObjectByName("Attach Instrument")
    if node ~= nil then
        ins:clearTransforms()
        tes3.player.sceneNode
        :getObjectByName("Attach Instrument")
        :attachChild(ins, true)
        ins.appCulled = false
    else
        mwse.log("[Resdayn Sonorant Apparati] Attach Instrument node is nil!")
    end

end

function this.attachInstrument(e, instrument)

    if e.group == tes3.animationGroup.idle9 then
        local ins = tes3.loadMesh(instrument.mesh):clone()
        ins.name = instrument.name
        local node = tes3.player.sceneNode:getObjectByName("Attach Instrument")
        if node ~= nil then
            ins:clearTransforms()
            tes3.player.sceneNode
            :getObjectByName("Attach Instrument")
            :attachChild(ins, true)
            ins.appCulled = false
        else
            mwse.log("[Resdayn Sonorant Apparati] Attach Instrument node is nil!")
        end
        event.unregister("playGroup", this.attachInstrument)
    end

end

function this.startImprovCycle(instrument)
    tes3.playAnimation({
        reference = tes3.player,
        group = tes3.animationGroup.idle9,
        mesh = instrument.animation.idle,
        startFlag = tes3.animationStartFlag.immediate,
    })

    timer.delayOneFrame(function()
        tes3.playAnimation({
            reference = tes3.player,
            group = tes3.animationGroup.idle9,
            mesh = instrument.animation.idle,
            startFlag = tes3.animationStartFlag.normal,
        })
        event.register("playGroup", function ()
            this.attachInstrument(instrument)
        end)
    end)

end

return this
