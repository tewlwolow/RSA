local this = {}

local data = require("Resdayn Sonorant Apparati\\data\\data")
local instruments = data.instruments

local modversion = require("Resdayn Sonorant Apparati\\version")
local version = modversion.version
local config = require("Resdayn Sonorant Apparati.config")
local debugLogOn = config.debugLogOn

local HUD = require("Resdayn Sonorant Apparati\\shared\\HUD")

local function debugLog(string)
    if debugLogOn then
       mwse.log("[Resdayn Sonorant Apparati "..version.."] Equip Instrument: "..string)
    end
end

-- Get the instrument object from data file per stored equipped instrument id --
function this.getEquippedInstrument()
    if tes3.player.data.RSA.equipped then
        local equippedData = tes3.player.data.RSA.equipped
        local node = tes3.player.sceneNode:getObjectByName("Bip01 Attached Instrument")
        if node == nil or equippedData == nil then
            return nil
        else
            for _, instrument in pairs(data.instruments) do
                if equippedData == instrument.id then
                    return instrument
                end
            end
        end
    end
end

-- Get the mode data struct from data file per stored mode name --
function this.getCurrentMode()
    if tes3.player.data.RSA.currentMode then
        local equippedInstrument = this.getEquippedInstrument()
        local modeName = tes3.player.data.RSA.currentMode

        if equippedInstrument and modeName then
            for _, mode in pairs(data.modes[equippedInstrument.culture]) do
                if modeName == mode.name then
                    return mode
                end
            end
        end
    end
end

-- Reequip all the items to restore the nodes - paramount for Weapon Sheating, Ashfall, Vanity etc. --
function this.restoreEquipped(actor)
    debugLog("Reequipping items.")
    local equippedStack = actor.object.equipment
    for _, equipped in pairs(equippedStack) do
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
    debugLog("Item reequipped.")
end

-- Faux equip instrument and show it on player mesh --
function this.equip(ref, instrument)
    -- Get the spine node for attaching --
    local parent = ref.sceneNode:getObjectByName("Bip01 Spine1")

    -- Load instrument mesh --
    local node = tes3.loadMesh(instrument.mesh)
    if node then
        debugLog("Equipping instrument: "..instrument.name)
        node = node:clone()
        node.children[1].name = instrument.id
        node:clearTransforms()

        -- Rename the root node so we can easily find it for detaching --
        node.name = "Bip01 Attached Instrument"

        -- Offset the node to position the instrument correctly --
        -- Uses values defined per instrument in main data file --
        local m1 = tes3matrix33.new()
        m1:fromEulerXYZ(table.unpack(instrument.equipRotation))
        local instrumentOffset = {
        translation = tes3vector3.new(table.unpack(instrument.equipPosition)),
        rotation = m1;
        }

        node.translation = instrumentOffset.translation:copy()
        node.rotation = instrumentOffset.rotation:copy()
        parent:attachChild(node, true)
        parent:update()
        parent:updateNodeEffects()

        -- Store the equipped id for other modules to use --
        tes3.player.data.RSA.equipped = instrument.id
        debugLog(instrument.name.." equipped.")

        HUD.createInstrumentIcon()
    end

end

-- Unequip instrument if equipping the same instrument twice --
function this.unequip(ref)
    local parent = ref.sceneNode:getObjectByName("Bip01 Spine1")
    local node = parent:getObjectByName("Bip01 Attached Instrument")
    if node then
        parent:detachChild(node)
        parent:update()
        parent:updateNodeEffects()
        tes3.player.data.RSA.equipped = nil
    end
    debugLog("Instrument unequipped.")

    local menuMulti = tes3ui.findMenu(tes3ui.registerID("MenuMulti"))
    local instrumentBlock = menuMulti:findChild(HUD.IDs.instrumentBorder)
    instrumentBlock.visible = false
    instrumentBlock:destroy()

end

-- Main logic loop for equip event --
-- We need to determine if we need to equip or unequip --
function this.onEquip(e)
    local ref = e.reference
    if  tes3.player.data.RSA.equipped == nil then
        debugLog("No equipped instrument detected.")
        for _, instrument in pairs(instruments) do
            if e.item.id == instrument.id then
                this.equip(ref, instrument)
            end
        end
    else
        debugLog("Equipped instrument detected.")
        if e.item.id ==  tes3.player.data.RSA.equipped then
            debugLog("Same instrument detected - unequipping "..tes3.player.data.RSA.equipped..".")
            this.unequip(ref)
        else
            for _, instrument in pairs(instruments) do
                if e.item.id == instrument.id then
                    debugLog("Different instrument detected - reequipping.")
                    this.unequip(ref)
                    this.equip(ref, instrument)
                end
            end
        end
    end
end

-- Check if the saved game has any instrument attached and attach if necessary --
function this.getEquipData()
    timer.delayOneFrame(function()
        local equippedData, equippedInstrument
        equippedData = tes3.player.data.RSA.equipped
        if equippedData ~= nil then
            for _, instrument in pairs(data.instruments) do
                if equippedData == instrument.id then
                    equippedInstrument = instrument
                    this.equip(tes3.player, equippedInstrument)
                    break
                end
            end
        end
    end)
end


return this