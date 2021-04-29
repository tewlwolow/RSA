local this = {}

this.IDs = {

    mainHUDBlock = tes3ui.registerID("RSA:HUD_mainBlock"),

    instrumentBorder = tes3ui.registerID("RSA:HUD_instrumentBorder"),

    musicModeBorder = tes3ui.registerID("RSA:HUD_musicModeBorder"),
    musicModeBlock = tes3ui.registerID("RSA:HUD_musicMode"),

    instrumentModeBorder = tes3ui.registerID("RSA:HUD_instrumentModeBorder"),
    instrumentModeBlock = tes3ui.registerID("RSA:HUD_musicMode"),

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

function this.createModeIcon(currentMode)
    if currentMode ~= nil then
        local multiMenu = tes3ui.findMenu(tes3ui.registerID("MenuMulti"))
        local mainHUDBlock = multiMenu:findChild(this.IDs.mainHUDBlock)

        local instrumentModeBorder = mainHUDBlock:createThinBorder({id = this.IDs.instrumentModeBorder})
        --instrumentBorder.layoutWidthFraction = 1.0
		instrumentModeBorder.flowDirection = "top_to_bottom"
		instrumentModeBorder.height = 36
        instrumentModeBorder.width = 36
		instrumentModeBorder.paddingAllSides = 2
        instrumentModeBorder.borderRight = 4

        local instrumentModeBlock = instrumentModeBorder:createBlock({id = this.IDs.instrumentModeBlock})
        instrumentModeBlock.height = 32
        instrumentModeBlock.width = 32
        instrumentModeBlock.borderAllSides = 0

        instrumentModeBlock:register("help", function()
            local headerText = currentMode.name
            local labelText = currentMode.description
            this.createTooltip({header = headerText, text = labelText})
        end)

        local iconPath = currentMode.icon

        local modeIcon = instrumentModeBlock:createImage({path=iconPath})
        modeIcon.autoHeight = 32
        modeIcon.autoWidth = 32
        modeIcon.borderAllSides = 0
        mainHUDBlock:updateLayout()
        return instrumentModeBorder
    end
end

function this.createMusicModeIcon()
    if tes3.player.data.RSA.equipped ~= nil then
        local multiMenu = tes3ui.findMenu(tes3ui.registerID("MenuMulti"))
        local mainHUDBlock = multiMenu:findChild(this.IDs.mainHUDBlock)

        local musicModeBorder = mainHUDBlock:createThinBorder({id = this.IDs.musicModeBorder})
        --instrumentBorder.layoutWidthFraction = 1.0
		musicModeBorder.flowDirection = "top_to_bottom"
		musicModeBorder.height = 36
        musicModeBorder.width = 36
		musicModeBorder.paddingAllSides = 2
        musicModeBorder.borderRight = 4

        local musicModeBlock = musicModeBorder:createBlock({id = this.IDs.musicModeBlock})
        musicModeBlock.height = 32
        musicModeBlock.width = 32
        musicModeBlock.borderAllSides = 0

        musicModeBlock:register("help", function()
            local labelText = "I am ready to play music."
            this.createTooltip({text = labelText})
        end)

        local iconPath = "Icons\\RSA\\ui\\hud\\general\\rsa_musicicon.tga"

        local modeIcon = musicModeBlock:createImage({path=iconPath})
        modeIcon.autoHeight = 32
        modeIcon.autoWidth = 32
        modeIcon.borderAllSides = 0
        mainHUDBlock:updateLayout()
        return musicModeBorder
    end
end

function this.createInstrumentIcon()

    if tes3.player.data.RSA.equipped ~= nil then
        local multiMenu = tes3ui.findMenu(tes3ui.registerID("MenuMulti"))
        local mainHUDBlock = multiMenu:findChild(this.IDs.mainHUDBlock)
        local instrumentBorder = mainHUDBlock:createThinBorder({id = this.IDs.instrumentBorder})
        --instrumentBorder.layoutWidthFraction = 1.0
		instrumentBorder.flowDirection = "top_to_bottom"
		instrumentBorder.height = 36
        instrumentBorder.width = 36
		instrumentBorder.paddingAllSides = 2
        instrumentBorder.borderRight = 4

        local instrumentBackground = instrumentBorder:createRect({color = {0.0, 0.0, 0.0} })
        instrumentBackground.height = 32
        instrumentBackground.width = 32
        instrumentBackground.borderAllSides = 0
        instrumentBackground.alpha = tes3.worldController.menuAlpha

        instrumentBorder:register("help", function()
            local labelText = "My currently equipped instrument."
            this.createTooltip({text = labelText})
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
        mainHUDBlock:reorderChildren(0, -1, 1)
        mainHUDBlock:updateLayout()
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

    --mainHUDBlock:reorderChildren(0, -1, 1)
end

return this
