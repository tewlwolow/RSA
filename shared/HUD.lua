
local this = {}

this.IDs = {

    mainHUDBlock = tes3ui.registerID("RSA:HUD_mainBlock"),
    bottomBlock = tes3ui.registerID("RSA:HUD_bottomBlock"),
    topHUDBlock = tes3ui.registerID("RSA:HUD_topHUDBlock"),

    musicModeBlock = tes3ui.registerID("RSA:HUD_musicMode"),

    instrumentBorder = tes3ui.registerID("RSA:HUD_instrumentBorder"),
    instrumentBlock = tes3ui.registerID("RSA:HUD_instrument"),
    modeBlock = tes3ui.registerID("RSA:HUD_mode"),

}

function this.quickFormat(element, padding)
    element.paddingAllSides = padding
    element.autoHeight = true
    element.autoWidth = true
    return element
end

function this.createTooltip(e)
    local thisHeader, thisLabel = e.header, e.text
    local tooltip = tes3ui.createTooltipMenu()

    local outerBlock = tooltip:createBlock({ id = tes3ui.registerID("RSA:HUD_tooltip_outerBlock") })
    outerBlock.flowDirection = "top_to_bottom"
    outerBlock.paddingTop = 6
    outerBlock.paddingBottom = 12
    outerBlock.paddingLeft = 6
    outerBlock.paddingRight = 6
    outerBlock.maxWidth = 300
    outerBlock.autoWidth = true
    outerBlock.autoHeight = true

    if thisHeader then
        local headerText = thisHeader
        local headerLabel = outerBlock:createLabel({ id = tes3ui.registerID("RSA:HUD_tooltip_header"), text = headerText })
        headerLabel.autoHeight = true
        headerLabel.width = 285
        headerLabel.color = tes3ui.getPalette("header_color")
        headerLabel.wrapText = true
        --header.justifyText = "center"
    end
    if thisLabel then
        local descriptionText = thisLabel
        local descriptionLabel = outerBlock:createLabel({ id = tes3ui.registerID("RSA:HUD_tooltip_description"), text = descriptionText })
        descriptionLabel.autoHeight = true
        descriptionLabel.width = 285
        descriptionLabel.wrapText = true
    end

    tooltip:updateLayout()
end


function this.createInstrumentHUD(parentBlock)

    if tes3.player.data.RSA.equipped ~= nil then
        local instrumentBorder = parentBlock:createThinBorder({id = this.IDs.instrumentBorder})
        --instrumentBorder.layoutWidthFraction = 1.0
		instrumentBorder.flowDirection = "top_to_bottom"
		instrumentBorder.height = 36
        instrumentBorder.width = 36
		instrumentBorder.paddingAllSides = 2


        local instrumentBackground = instrumentBorder:createRect({color = {0.0, 0.05, 0.1} })
        instrumentBackground.height = 32
        instrumentBackground.width = 32
        instrumentBackground.borderAllSides = 0
        instrumentBackground.alpha = tes3.worldController.menuAlpha

        instrumentBorder:register("help", function()
            local headerText = "Instrument"
            local labelText = "My currently equipped instrument"
            this.createTooltip({header = headerText, text = labelText})
        end)

        local iconPath
        local inventory = tes3.player.object.inventory

        for _, inventoryItem in pairs(inventory) do
            if tes3.player.data.RSA.equipped == inventoryItem.object.id then
                iconPath = "Icons\\"..inventoryItem.object.icon
            end
        end

        local instrumentIcon = instrumentBackground:createImage({path=iconPath})
        instrumentIcon.autoHeight = 32
        instrumentIcon.autoWidth = 32
        instrumentIcon.borderAllSides = 0
        parentBlock:updateLayout()
        return instrumentBorder
    end

end

function this.createHUD(e)

    if not e.newlyCreated then return end

    local multiMenu = e.element

    -- Find the UI element that holds the weapon icon --
    local mainBlock = multiMenu:findChild(tes3ui.registerID("MenuMulti_weapon_layout")).parent.parent.parent
    local mainHUDBlock = mainBlock:createBlock({id = this.IDs.mainHUDBlock})

    mainHUDBlock.flowDirection = "left_to_right"
    mainHUDBlock = this.quickFormat(mainHUDBlock, 2)
    mainHUDBlock.widthProportional = 1

    mainHUDBlock:reorderChildren(0, -1, 1)
end

return this
