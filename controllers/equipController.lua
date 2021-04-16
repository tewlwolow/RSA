local modversion = require("Resdayn Sonorant Apparati\\version")
local version = modversion.version
local config = require("Resdayn Sonorant Apparati.config")
local debugLogOn = config.debugLogOn

local equipInstrument = require("Resdayn Sonorant Apparati\\shared\\equipInstrument")

local function debugLog(string)
    if debugLogOn then
       mwse.log("[Resdayn Sonorant Apparati "..version.."] Equip Controller: "..string)
    end
end

local function onBarterOffer(e)
    if tes3.player.data.RSA.equipped ~= nil and
    #e.selling > 0 and e.success == true then
        for _, tile in ipairs(e.selling) do
            if tile.item.id == tes3.player.data.RSA.equipped then
                debugLog("Player sold the equipped instrument - unequipping.")
                equipInstrument.unequip(tes3.player)
            end
        end
    end
end

local function onItemDropped(e)
    if tes3.player.data.RSA.equipped ~= nil and
    e.reference.id == tes3.player.data.RSA.equipped then
        debugLog("Player dropped the equipped instrument - unequipping.")
        equipInstrument.unequip(tes3.player)
    end
end
event.register("itemDropped", onItemDropped)

-- Register equip events --
debugLog("Registering events.")
event.register("loaded", equipInstrument.getEquipData, {priority = -50})
event.register("equip", equipInstrument.onEquip)
event.register("barterOffer", onBarterOffer)