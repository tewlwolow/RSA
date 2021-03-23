local config = require("RSA.config")
local debugLogOn = config.debugLogOn
local modversion = require("RSA\\version")
local version = modversion.version
local data = require("RSA\\hitsData")
local current

local hitInstruments = data.hitInstruments

local function debugLog(string)
    if debugLogOn then
       mwse.log("[RSA "..version.."] Static names module: "..string)
    end
end

-- The following functions for statics are (heavily) inspired by Merlord's Ashfall --
local function centerText(element)
    element.autoHeight = true
    element.autoWidth = true
    element.wrapText = true
    element.justifyText = "center"
end

-- Register RSA menu IDs --
local id_indicator = tes3ui.registerID("RSA:activatorTooltip")
local id_label = tes3ui.registerID("RSA:activatorTooltipLabel")

-- Create tooltip if we have hit a suitable static object --
-- Otherwise destroy and hide tooltip --
local function createStaticTooltip(txt)

    local menu = tes3ui.findMenu(tes3ui.registerID("MenuMulti"))
    if menu then
        local mainBlock = menu:findChild(id_indicator)

        if (current) and (not tes3.menuMode()) then
            if mainBlock then
                mainBlock:destroy()
            end

            mainBlock = menu:createBlock({id = id_indicator })

            mainBlock.absolutePosAlignX = 0.5
            mainBlock.absolutePosAlignY = 0.03
            mainBlock.autoHeight = true
            mainBlock.autoWidth = true

            local labelBackground = mainBlock:createRect({color = {0, 0, 0}})
            --labelBackground.borderTop = 4
            labelBackground.autoHeight = true
            labelBackground.autoWidth = true

            local labelBorder = labelBackground:createThinBorder({})
            labelBorder.autoHeight = true
            labelBorder.autoWidth = true
            labelBorder.paddingAllSides = 10
            labelBorder.flowDirection = "top_to_bottom"

            local label = labelBorder:createLabel{ id=id_label, text = txt}
            label.color = tes3ui.getPalette("header_color")
            centerText(label)

        else
            if mainBlock then
                mainBlock.visible = false
            end
        end
    end
end

-- Check what we're looking at in real time --
local function staticTooltip()

    -- Run a raycast from player view
    local eyePos = tes3.getPlayerEyePosition()
    local eyeDirection = tes3.getPlayerEyeVector()
    local txt = ""
    current = nil

    local result = tes3.rayTest{
        position = eyePos,
        direction = eyeDirection,
        ignore = { tes3.player }
    }

    if result then
        if (result and result.reference ) then
            local distance = eyePos:distance(result.intersection)

            -- Get a match the static against RSA table
            if distance < 200 then
                local targetRef = result.reference

                if (targetRef~=nil) and (targetRef.object.objectType ~= tes3.objectType.static) then return end

                for rsaID, rsaName in pairs(hitInstruments) do
                    if string.startswith(targetRef.object.id, rsaID) then
                        txt = rsaName
                        current = targetRef.object.id
                    end
                end
            end
        end
    end

    -- Run tooltip creation function
    createStaticTooltip(txt)

end

debugLog("Module initialised.")
event.register("simulate", staticTooltip)
