local data = require("Resdayn Sonorant Apparati\\data\\data")
local instruments = data.instruments
local equipped


local function equip(ref, instrument)

    local parent = ref.sceneNode:getObjectByName("Bip01 Spine1")
    local node = tes3.loadMesh(instrument.mesh)
    if node then
        node = node:clone()
        node.children[1].name = instrument.id
        node:clearTransforms()

        -- rename the root node so we can easily find it for detaching
        node.name = "Bip01 Attached Instrument"

        -- offset the node to position the instrument correctly

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

        equipped = instrument.id
    end

end


local function unequip(ref)
    local parent = ref.sceneNode:getObjectByName("Bip01 Spine1")
    local node = parent:getObjectByName("Bip01 Attached Instrument")
    if node then
        parent:detachChild(node)
        parent:update()
        parent:updateNodeEffects()
        equipped = nil
    end

end

local function onEquip(e)
    local ref = e.reference
    if equipped == nil then
        for _, instrument in pairs(instruments) do
            if e.item.id == instrument.id then
                equip(ref, instrument)
            end
        end
    else
        if e.item.id == equipped then
            unequip(ref)
        else
            for _, instrument in pairs(instruments) do
                if e.item.id == instrument.id then
                    unequip(ref)
                    equip(ref, instrument)
                end
            end
        end
    end
end


event.register("equip", onEquip)