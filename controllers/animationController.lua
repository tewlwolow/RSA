local this = {}

local modversion = require("Resdayn Sonorant Apparati\\version")
local version = modversion.version
local config = require("Resdayn Sonorant Apparati.config")
local debugLogOn = config.debugLogOn
local cancelCallback, cancelOptions

local equipInstrument = require("Resdayn Sonorant Apparati\\shared\\equipInstrument")

local equipDuration = 3.1

local function debugLog(string)
    if debugLogOn then
       mwse.log("[Resdayn Sonorant Apparati "..version.."] Animation Controller: "..string)
    end
end

local function setControlsDisabled(state)
    tes3.mobilePlayer.controlsDisabled = state
    tes3.mobilePlayer.jumpingDisabled = state
    tes3.mobilePlayer.attackDisabled = state
    tes3.mobilePlayer.magicDisabled = state
    tes3.mobilePlayer.mouseLookDisabled = state
end
local function disableControls()
    setControlsDisabled(true)
end
local function enableControls()
    setControlsDisabled(false)
    tes3.runLegacyScript{command = "EnableInventoryMenu"}
end

-- Cancel animation by forcing the idle animation on actor --
function this.cancelAnimation(e, playerMesh, instrument, actor)
    if e.isAltDown then
        debugLog("Cancelling animation, player mesh: "..playerMesh)
        tes3.playAnimation({
            reference = actor,
            mesh = playerMesh,
            group = tes3.animationGroup.idle,
            startFlag = 1
        })

        --Unregister event outside played RSA animation --
        event.unregister("key", cancelCallback, cancelOptions)
        cancelCallback, cancelOptions = nil, nil

        -- Reequip the instrument --
        tes3.player.data.RSA.equipped = nil
        equipInstrument.equip(actor, instrument)
        equipInstrument.restoreEquipped(actor)
        tes3.player.data.RSA.improvMode = false

        tes3.removeSound{
            sound = tes3.player.data.RSA.currentSound,
            reference = actor
        }
        tes3.player.data.RSA.currentSound = nil

        tes3.player.data.RSA.currentMode = nil
        tes3.setVanityMode({enabled = false})
        enableControls()

        tes3.player.position = tes3.player.data.RSA.fixPosition
        tes3.player.orientation = tes3.player.data.RSA.fixOrientation
    end
end

-- Generic playAnimation function --
function this.playAnimation(actor, start, animType, animGroup)
    debugLog("Playing animation for instrument: "..tes3.player.data.RSA.equipped)
    tes3.playAnimation({
        reference = actor,
        group = animGroup,
        mesh = animType,
        startFlag = start,
    })

    tes3.player.position = tes3.player.data.RSA.fixPosition
    tes3.player.orientation = tes3.player.data.RSA.fixOrientation

end

-- Attach instrument for idle and play animations --
function this.attachInstrument(instrument, actor)
        debugLog("Attaching instrument.")
        -- Get the specific node from animation file --
        local node = actor.sceneNode:getObjectByName("Attach Instrument")
        if node ~= nil then
            -- Load instrument mesh --
            local ins = tes3.loadMesh(instrument.mesh):clone()
            ins.name = instrument.name
            -- Clear transforms just in case --
            ins:clearTransforms()
            -- Attach instrument mesh to specific node --
            actor.sceneNode
            :getObjectByName("Attach Instrument")
            :attachChild(ins, true)
            ins.appCulled = false
            debugLog("Attached instrument node: "..instrument.mesh)
        else
            debugLog("Attach Instrument node is nil!")
        end
        debugLog("Instrument attached.")

        tes3.player.position = tes3.player.data.RSA.fixPosition
        tes3.player.orientation = tes3.player.data.RSA.fixOrientation

end

-- The improvisation animation cycle - equip, then idle loop --
function this.startImprovCycle(instrument, playerMesh, actor)
    tes3.force3rdPerson()
    disableControls()
    tes3.player.data.RSA.improvMode = true

    -- Register alt+x to break the animation cycle --
    cancelCallback = function(e)
    this.cancelAnimation(e, playerMesh, instrument, actor)
    end
    cancelOptions = { filter = tes3.scanCode.x }
    event.register("key", cancelCallback, cancelOptions)

    -- Play the equip animation --
    this.playAnimation(actor, tes3.animationStartFlag.immediate, instrument.animation.equip, tes3.animationGroup.idle8)
    this.attachInstrument(instrument, actor)


    -- Wait some then play the idle animation --
    timer.start{
        duration = equipDuration,
        callback=function()
            this.playAnimation(actor, tes3.animationStartFlag.immediate, instrument.animation.idle, tes3.animationGroup.idle9)
            this.attachInstrument(instrument, actor)
        end,
        type = timer.simulate
    }

end

return this
