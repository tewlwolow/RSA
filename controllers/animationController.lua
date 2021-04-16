local this = {}

local modversion = require("Resdayn Sonorant Apparati\\version")
local version = modversion.version
local config = require("Resdayn Sonorant Apparati.config")
local debugLogOn = config.debugLogOn
local cancelCallback, cancelOptions, attachCallback

local function debugLog(string)
    if debugLogOn then
       mwse.log("[Resdayn Sonorant Apparati "..version.."] Animation Controller: "..string)
    end
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

        -- Reequip nodes that get removed when we play our animation --

        -- Reequip the instrument --
        local equipInstrument = require("Resdayn Sonorant Apparati\\shared\\equipInstrument")
        tes3.player.data.RSA.equipped = nil
        equipInstrument.equip(actor, instrument)

        -- Reequip all the items to restore the nodes - paramount for Weapon Sheating, Ashfall, Vanity etc. --
        local equippedStack = actor.object.equipment
        for _, equipped in pairs(equippedStack) do
            print(equipped.object.name)
            timer.delayOneFrame(function()
                actor.mobile:unequip({item = equipped.object.id})
            end)
        end
        local inventory = tes3.player.object.inventory
        for _, equipped in pairs(equippedStack) do
            for _, inventoryItem in pairs(inventory) do
                if equipped.object.id == inventoryItem.object.id then
                    timer.delayOneFrame(function()
                        actor.mobile:equip({item = inventoryItem.object.id})
                    end)
                end
            end
        end
    end
end

-- Generic playAnimation function --
function this.playAnimation(instrument, actor, start, animType, animGroup)
    debugLog("Playing animation for instrument: "..instrument.name)

    tes3.playAnimation({
        reference = actor,
        group = animGroup,
        mesh = animType,
        startFlag = start,
    })

end

-- Attach instrument for idle and play animations --
function this.attachInstrument(e, instrument, actor)

    -- We only care about idle and play animations, so we use idle9 group --
    if e.group == tes3.animationGroup.idle9 then
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
        event.unregister("playGroup", attachCallback)
        attachCallback = nil
    end

end

-- The improvisation animation cycle - equip, then idle loop --
function this.startImprovCycle(instrument, playerMesh, actor)

    -- Register alt+c to break the animation cycle --
    cancelCallback = function(e)
    this.cancelAnimation(e, playerMesh, instrument, actor)
    end
    cancelOptions = { filter = tes3.scanCode.x }
    event.register("key", cancelCallback, cancelOptions)

    -- Play the equip animation --
    this.playAnimation(instrument, actor, tes3.animationStartFlag.immediate, instrument.animation.equip, tes3.animationGroup.idle8)

    -- Wait one frame then register idle animation --
    timer.delayOneFrame(function()
        attachCallback = function(e)
        this.attachInstrument(e, instrument, actor)
        end
        event.register("playGroup", attachCallback)
        -- Play idle animation after equip --
        this.playAnimation(instrument, actor, tes3.animationStartFlag.normal, instrument.animation.idle, tes3.animationGroup.idle9)
    end)

end

return this
