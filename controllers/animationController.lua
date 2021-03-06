local this = {}

local modversion = require("Resdayn Sonorant Apparati\\version")
local version = modversion.version
local config = require("Resdayn Sonorant Apparati.config")
local debugLogOn = config.debugLogOn
local cancelCallback, cancelOptions
this.riffTimer = nil
this.idleTimer = nil
this.compositionTimer = nil

local HUD = require("Resdayn Sonorant Apparati\\shared\\HUD")
local equipInstrument = require("Resdayn Sonorant Apparati\\shared\\equipInstrument")
local playMusic =  require("Resdayn Sonorant Apparati\\shared\\playMusic")

local equipDuration = 3.9

local function debugLog(string)
    if debugLogOn then
       mwse.log("[Resdayn Sonorant Apparati "..version.."] Animation Controller: "..string)
    end
end

-- This function controlls getting rid of natural timers when switching between improvisation/composition modes etc. --
function this.ridTimers()
    -- Remove the idle timer from previous riffs if present --
    if this.idleTimer then
        this.idleTimer:pause()
        this.idleTimer:cancel()
    end
    if this.riffTimer then
        this.riffTimer:pause()
        this.riffTimer:cancel()
    end
    if this.compositionTimer then
        this.compositionTimer:pause()
        this.compositionTimer:cancel()
    end
end

-- Disable player controls --
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

-- Attach instrument for idle and play animations --
function this.attachInstrument(actor, instrument)
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

end

-- This function controls getting out of music mode by cancelling animations --
function this.cancelAnimation(playerMesh, instrument, actor)
    debugLog("Cancelling animation, player mesh: "..playerMesh)

    -- Set music mode flag to false --
    tes3.player.data.RSA.musicMode = false

    -- Remove idle animation control timer --
    if this.riffTimer then
        this.riffTimer:pause()
        this.riffTimer:cancel()
        this.riffTimer = nil
    end

    -- Remove the animation by restoring the stored player mesh --
    tes3.playAnimation({
        reference = actor,
        mesh = playerMesh,
        group = tes3.animationGroup.idle,
        startFlag = 1
    })

    -- Reequip the instrument --
    equipInstrument.unequip(actor)
    equipInstrument.equip(actor, instrument)
    equipInstrument.restoreEquipped(actor)

    -- Get rid of the HUD if present --
    local menuMulti = tes3ui.findMenu(tes3ui.registerID("MenuMulti"))
    local musicModeBorder = menuMulti:findChild(HUD.IDs.musicModeBorder)
    if musicModeBorder then
        musicModeBorder.visible = false
        musicModeBorder:destroy()
    end

    local instrumentModeBorder = menuMulti:findChild(HUD.IDs.instrumentModeBorder)
    if instrumentModeBorder then
        instrumentModeBorder.visible = false
        instrumentModeBorder:destroy()
    end

    -- Remove played sound --
    playMusic.removeMusic(actor)
    tes3.player.data.RSA.currentSound = nil

    -- Reset the played mode --
    tes3.player.data.RSA.currentMode = nil

    -- Set the composition flag to false, needed for proper keybind logic --
    tes3.player.data.RSA.compositionPlaying = false

    -- Reenable player controls --
    tes3.setVanityMode({enabled = false})
    enableControls()

    -- Fix position --
    tes3.player.position = tes3.player.data.RSA.fixPosition
    tes3.player.orientation = tes3.player.data.RSA.fixOrientation

end

        -- Unregister event outside played RSA animation --
function this.onCancelKey(e, playerMesh, instrument, actor)
    if e.isAltDown then
        this.ridTimers()
        event.unregister("key", cancelCallback, cancelOptions)
        cancelCallback, cancelOptions = nil, nil
        this.cancelAnimation( playerMesh, instrument, actor)
    end
end

-- Generic function to play various RSA animations --
function this.playAnimation(actor, start, animType, animGroup, instrument)
    -- Fix position --
    tes3.player.position = tes3.player.data.RSA.fixPosition
    tes3.player.orientation = tes3.player.data.RSA.fixOrientation

    -- Enter the music mode --
    tes3.player.data.RSA.musicMode = true

    -- Play animation --
    debugLog("Playing animation for instrument: "..tes3.player.data.RSA.equipped)
    tes3.playAnimation({
        reference = actor,
        group = animGroup,
        mesh = animType,
        startFlag = start,
    })

    tes3.player.position = tes3.player.data.RSA.fixPosition
    tes3.player.orientation = tes3.player.data.RSA.fixOrientation

    -- Attach the instrument --
    this.attachInstrument(actor, instrument)

    tes3.player.position = tes3.player.data.RSA.fixPosition
    tes3.player.orientation = tes3.player.data.RSA.fixOrientation

    -- Fix position again, because Todd --
    timer.delayOneFrame(function()
        tes3.player.position = tes3.player.data.RSA.fixPosition
        tes3.player.orientation = tes3.player.data.RSA.fixOrientation
    end)
end

-- The improvisation animation cycle - equip, then idle loop --
function this.startImprovCycle(instrument, playerMesh, actor)
    -- Remove composition flag --
    tes3.player.data.RSA.compositionPlaying = false

    -- Remove timers --
    this.ridTimers()

    -- Go into third person and disable controls --
    tes3.force3rdPerson()
    disableControls()

    -- Play the equip animation --
    this.playAnimation(actor, tes3.animationStartFlag.immediate, instrument.animation.equip, tes3.animationGroup.idle8, instrument)

    -- Register alt+x to break the animation cycle --
    cancelCallback = function(e)
        this.onCancelKey(e, playerMesh, instrument, actor)
        end
        cancelOptions = { filter = config.cancelKey.keyCode }
    event.register("key", cancelCallback, cancelOptions)

    -- Wait some then play the idle animation --
    this.idleTimer = timer.start{
        duration = equipDuration,
        callback=function()
            this.playAnimation(actor, tes3.animationStartFlag.immediate, instrument.animation.idle, tes3.animationGroup.idle9, instrument)
        end,
        type = timer.simulate
    }

end

-- This controls the full composition animation cycle when selected from the main RSA menu --
function this.startCompositionCycle(instrument, playerMesh, actor, path)
    -- Enter the composition mode --
    tes3.player.data.RSA.compositionPlaying = true

    this.ridTimers()
    tes3.force3rdPerson()
    disableControls()

    -- Play the equip animation --
    this.playAnimation(actor, tes3.animationStartFlag.immediate, instrument.animation.equip, tes3.animationGroup.idle8, instrument)

    -- Register alt+x to break the animation cycle --
    cancelCallback = function(e)
        this.onCancelKey(e, playerMesh, instrument, actor)
        end
        cancelOptions = { filter = config.cancelKey.keyCode }
    event.register("key", cancelCallback, cancelOptions)

    -- Wait some then play the composition animation --
    this.idleTimer = timer.start{
        duration = equipDuration,
        callback=function()
            this.playAnimation(actor, tes3.animationStartFlag.immediate, instrument.animation.composition, tes3.animationGroup.idle9, instrument)

            -- Play the composition track --
            playMusic.playMusic(path, actor)

            -- Create a timer (shared by riff timers for simplicity) to get back to idle after composition --
            this.riffTimer = timer.start{
                duration = tes3.player.data.RSA.riffLength,
                callback=function()
                    this.playAnimation(tes3.player, tes3.animationStartFlag.immediate,  instrument.animation.idle, tes3.animationGroup.idle9, instrument)
                end,
                type = timer.simulate
            }
        end,
        type = timer.simulate
    }

end

-- This controls the full composition animation cycle when selected from the composition menu inside improvisation mode --
function this.startCompositionCycleShort(instrument, actor, path)
    tes3.player.data.RSA.compositionPlaying = true
    this.ridTimers()

    -- No need to play equip animation here, just go straight to composition animation --
    this.playAnimation(actor, tes3.animationStartFlag.immediate, instrument.animation.composition, tes3.animationGroup.idle9, instrument)

    -- Play the composition track --
    playMusic.playMusic(path, actor)

     -- Create a timer (shared by riff timers for simplicity) to get back to idle after composition --
    this.riffTimer = timer.start{
        duration = tes3.player.data.RSA.riffLength,
        callback=function()
            this.playAnimation(tes3.player, tes3.animationStartFlag.immediate,  instrument.animation.idle, tes3.animationGroup.idle9, instrument)
            tes3.player.data.RSA.compositionPlaying = false
        end,
        type = timer.simulate
    }

end

return this
