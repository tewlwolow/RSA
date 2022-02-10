local RSAmenuCreated = 0
local improvMenuCreated = 0
local vanityFlag = 0
local menuElementsPath = "Icons\\RSA\\ui\\menu\\"

local playerMesh, equippedInstrument

local ImageButton = {}

local modversion = require("Resdayn Sonorant Apparati\\version")
local version = modversion.version
local config = require("Resdayn Sonorant Apparati.config")
local debugLogOn = config.debugLogOn

local equipInstrument = require("Resdayn Sonorant Apparati\\shared\\equipInstrument")
local animController = require("Resdayn Sonorant Apparati\\controllers\\animationController")
local HUD = require("Resdayn Sonorant Apparati\\shared\\HUD")
local playMusic =  require("Resdayn Sonorant Apparati\\shared\\playMusic")

local function debugLog(string)
    if debugLogOn then
       mwse.log("[Resdayn Sonorant Apparati "..version.."] Main UI Controller: "..string)
    end
end

-- Keybinds for playing riffs --
local riffMap =
{
    ["numpad"] =
    {
        riff1 = tes3.scanCode.numpad1,
        riff2 =  tes3.scanCode.numpad2,
        riff3 = tes3.scanCode.numpad3,
    },
    ["QWE"] =
    {
        riff1 = tes3.scanCode.q,
        riff2 =  tes3.scanCode.w,
        riff3 = tes3.scanCode.e,
    },
}
local riffKeys = riffMap[config.riffKeys]

-- Image buttons from UI Expansion --
function ImageButton.over(e)
	if (not e.widget.disabled) then
		e.widget.color = { 0.3, 0.3, 0.3 }
		e.widget.children[1].alpha = 0.85
		e.widget:getTopLevelParent():updateLayout()
	end
end

function ImageButton.leave(e)
	if (not e.widget.disabled) then
		e.widget.color = { 0, 0, 0 }
		e.widget.children[1].alpha = 1.0
		e.widget:getTopLevelParent():updateLayout()
	end
end

function ImageButton.press(e)
	if (not e.widget.disabled) then
		e.widget.color = { 0.3, 0.3, 0.2 }
		e.widget.children[1].alpha = 0.8
		e.widget:getTopLevelParent():updateLayout()
		tes3.worldController.menuClickSound:play()
	end
end

function ImageButton.release(e)
	if (not e.widget.disabled) then
		e.widget.color = { 0, 0, 0 }
		e.widget.children[1].alpha = 1.0
		e.widget:getTopLevelParent():updateLayout()
	end

	e.widget:triggerEvent(e)
end

-- A function to create a clickable image button --
function ImageButton.create(parent, imagePath, w, h)
	local background = parent:createRect{}
	background.width = w
	background.height = h
	background:setPropertyBool("is_part", true)

	local im = background:createImage{ path = imagePath }
	im.width = w
	im.height = h
	im.scaleMode = true
    im.color = tes3ui.getPalette("normal_color")

	im:register("mouseOver", ImageButton.over)
	im:register("mouseLeave", ImageButton.leave)
	im:register("mouseDown", ImageButton.press)
	im:register("mouseRelease", ImageButton.release)
	im:register("mouseClick", ImageButton.release)

	return background
end

-- We need this on several occasions to get some critical data to pass on --
local function getPlayerData()
    -- Check if we have equipped an RSA instrument, return if not --
    equippedInstrument = equipInstrument.getEquippedInstrument()
    if equippedInstrument == nil then
        tes3.messageBox("You haven't got any instrument equipped.")
        return
    end

    -- Get the player mesh to restore controls later --
    playerMesh = tes3.player.object.mesh

    -- Get the player position and orientation to fix animation offset --
    tes3.player.data.RSA.fixPosition = tes3.player.position
    tes3.player.data.RSA.fixOrientation = tes3.player.orientation

end

-- This happens when player selects to enter music mode --
local function startImprov()
    -- Get the mode index for mode switching --
    if not tes3.player.data.RSA.modeIndex or tes3.player.data.RSA.modeIndex == 0 or tes3.player.data.RSA.modeIndex == nil then tes3.player.data.RSA.modeIndex = 1 end
    -- Create music mode icon --
    HUD.createMusicModeIcon()

    -- Get the currently selected instrument mode from saved game or start anew --
    local currentMode = equippedInstrument.modes[tes3.player.data.RSA.modeIndex]
    -- Create instrument mode icon --
    HUD.createModeIcon(currentMode)
    tes3.player.data.RSA.currentMode = currentMode.name
    -- Start the improvisation animation cycle --
    animController.startImprovCycle(equippedInstrument, playerMesh, tes3.player)
end

-- This happens when the player selects a composition option from the main RSA menu --
local function startCompositionUI(composition)
    -- Get current compositions --
    -- TODO: limit those to known compositions stored in a saved game --
    local path
    for _, comp in pairs(equippedInstrument.compositions) do
        if comp.name == composition then
            path = comp.path
        end
    end
    -- Start the composition animation cycle --
    animController.startCompositionCycle(equippedInstrument, playerMesh, tes3.player, path)
end

-- This happens when the player chooses to invoke the composition menu when already in improvisation mode --
local function startCompositionShort(composition)
    -- Get the current mode for the icon --
    -- It's crucial we get this data now, should the player cancel the composition and choose to play modes instead --
    tes3.player.data.RSA.currentMode = tes3.player.data.RSA.currentMode or equippedInstrument.modes[1]
    local path
    for _, comp in pairs(equippedInstrument.compositions) do
        if comp.name == composition then
            path = comp.path
        end
    end
    animController.startCompositionCycleShort(equippedInstrument, tes3.player, path)
end

-- This function controls switching between instruments modes --
local function toggleMode()
    -- Get the current modes from the equipped instrument data --
    local modes = equippedInstrument.modes

    -- Create HUD --
    local menuMulti = tes3ui.findMenu(tes3ui.registerID("MenuMulti"))
    local instrumentModeBorder = menuMulti:findChild(HUD.IDs.instrumentModeBorder)
    instrumentModeBorder.visible = false
    instrumentModeBorder:destroy()
    if tes3.player.data.RSA.modeIndex == #modes then
        tes3.player.data.RSA.modeIndex = 1
        local currentMode = equippedInstrument.modes[tes3.player.data.RSA.modeIndex]
        tes3.player.data.RSA.currentMode = currentMode.name
        HUD.createModeIcon(currentMode)
    else
        tes3.player.data.RSA.modeIndex = tes3.player.data.RSA.modeIndex + 1
        local currentMode = equippedInstrument.modes[tes3.player.data.RSA.modeIndex]
        tes3.player.data.RSA.currentMode = currentMode.name
        HUD.createModeIcon(currentMode)
    end
end

-- Music mode check and register --
local function keyCheck()
    if tes3.worldController.inputController:isKeyDown(config.musicModeKey) then
        if tes3.player.data.RSA.musicMode == false or tes3.player.data.RSA.musicMode == nil then
            getPlayerData()
            startImprov()
        end
    end
end

-- This function creates the composition menu --
-- TODO: detach the improvisation menu from main menu creation function --
local function createCompositionMenu()
    -- Get the name of the currently equipped instrument, return if the player doesn't know any compositions or we didn't create those yet --
    local equippedName = equippedInstrument.name
    if equippedInstrument.compositions[1].name == nil then tes3.messageBox("I don't know any compositions for the "..equippedName.name:lower()..".") return end

    -- Create the composition menu --
    local compMenuID = "RSA:CompMenu"
    local compMenu = tes3ui.createMenu{ id = compMenuID, fixedFrame = true }
    compMenu:getContentElement().childAlignX = 0.5
    tes3ui.enterMenuMode(compMenuID)

    local title = compMenu:createLabel{id = tes3ui.registerID("RSA:CompMenu_Title"), text = equippedName}

    local descrBlock = compMenu:createBlock({id=tes3ui.registerID("RSA:CompMenu_DescriptionBlock")})
    local description = descrBlock:createLabel({id=tes3ui.registerID("RSA:CompMenu_Description"), text = equippedInstrument.description})
    descrBlock.autoHeight = true
    descrBlock.width = 360
    descrBlock.flowDirection = "left_to_right"
    descrBlock.wrapText = true

    local compBlock = compMenu:createBlock({id=tes3ui.registerID("RSA:CompMenu_CompsBlock")})
    compBlock.borderTop = 6
    compBlock.autoHeight = true
    compBlock.autoWidth = true
    compBlock.flowDirection = "top_to_bottom"

    local compButtonId = tes3ui.registerID("RSA:CompMenu_CompButton")

    for _, composition in pairs(equippedInstrument.compositions) do
        local compButton = compBlock:createButton{
            id = compButtonId,
            text = composition.name,
        }

        compButton:register("help", function()
            local labelText = composition.description
            HUD.createTooltip({text = labelText})
        end)

        compButton:register("mouseClick", function()
            tes3ui.leaveMenuMode()
            compMenu:destroy()
            if tes3.player.data.RSA.musicMode == true then
                startCompositionShort(composition.name)
            else
                startCompositionUI(composition.name)
            end
        end)
    end

    local cancelCompBlock = compMenu:createBlock({id=tes3ui.registerID("RSA:CompMenu_CancelBlock")})
    cancelCompBlock.borderTop = 6
    cancelCompBlock.autoHeight = true
    cancelCompBlock.autoWidth = true
    cancelCompBlock.flowDirection = "left_to_right"

    local cancelCompButtonId = tes3ui.registerID("RSA:CompMenu_CancelButton")
    local cancelCompButton = cancelCompBlock:createButton{
        id = cancelCompButtonId,
        text = tes3.findGMST(tes3.gmst.sCancel).value,
    }

    cancelCompButton:register("mouseClick", function()
            tes3ui.leaveMenuMode()
            compMenu:destroy()
        end
    )

end


-- Create the main RSA menu --
local RSAMenuID = tes3ui.registerID("RSA:Menu")
local function createMenu(e)
    if e.isAltDown then
        -- Check the flag, otherwise it somehow triggers twice --
        if RSAmenuCreated ~= 1 then
            if tes3.player.data.RSA.musicMode == true or tes3.player.data.RSA.compositionPlaying == true then return end
            getPlayerData()
            if equippedInstrument == nil then return end

            debugLog("Creating RSA Menu.")

            local RSAMenu = tes3ui.createMenu{ id = RSAMenuID, fixedFrame = true }
            RSAMenu:getContentElement().childAlignX = 0.5
            tes3ui.enterMenuMode(RSAMenuID)
            RSAmenuCreated = 1

            local equippedName = equippedInstrument.name
            local title = RSAMenu:createLabel{id = tes3ui.registerID("RSA:Menu_Title"), text = equippedName}

            local descrBlock = RSAMenu:createBlock({id=tes3ui.registerID("RSA:Menu_DescriptionBlock")})
            local description = descrBlock:createLabel({id=tes3ui.registerID("RSA:Menu_Description"), text = equippedInstrument.description})
            descrBlock.autoHeight = true
            descrBlock.width = 360
            descrBlock.flowDirection = "left_to_right"
            descrBlock.wrapText = true

            local headerBlock = RSAMenu:createBlock({id=tes3ui.registerID("RSA:Menu_Header")})
            headerBlock.borderTop = 4
            headerBlock.borderBottom = 4
            headerBlock.autoHeight = true
            headerBlock.autoWidth = true
            headerBlock.flowDirection = "left_to_right"

            local headerDivider = headerBlock
            :createImage{path = menuElementsPath.."rsa_divider.dds"}
                headerDivider.autoHeight=true
                headerDivider.autoWidth=true
                headerDivider.borderBottom = 5
                headerDivider.borderTop = 5
                headerDivider.imageScaleX=0.6
                headerDivider.imageScaleY=0.6
                headerDivider.color = tes3ui.getPalette("normal_color")
            --

            local optionsBlock = RSAMenu:createBlock({id=tes3ui.registerID("RSA:Menu_OptionsBlock")})
            optionsBlock.autoHeight = true
            optionsBlock.autoWidth = true
            optionsBlock.flowDirection = "left_to_right"
            --

            local optionImprov = optionsBlock:createBlock{id = tes3ui.registerID("RSA:Menu_OptionImprov")}
            optionImprov.width = 180
            optionImprov.autoHeight = true
            optionImprov.flowDirection = "left_to_right"

            local borderImprov = optionImprov:createThinBorder{}
            borderImprov.autoWidth = true
            borderImprov.paddingAllSides = 5
            borderImprov.absolutePosAlignX = 0.5

            local improvIconPath = menuElementsPath.."rsa_improvico.dds"

            -- Create button callbacks for improvisation menu--
            local improvButton = ImageButton.create(borderImprov, menuElementsPath.."rsa_improvbg.dds", 128, 128)
            improvButton:register("mouseClick", function()
                tes3ui.leaveMenuMode()
                RSAMenu:destroy()
                RSAmenuCreated = 0

                if improvMenuCreated ~= 1 then
                    improvMenuCreated = 1
                    local improvMenuID = "RSA:ImprovMenu"
                    local improvMenu = tes3ui.createMenu{ id = improvMenuID, fixedFrame = true }
                    improvMenu:getContentElement().childAlignX = 0.5
                    tes3ui.enterMenuMode(improvMenuID)

                    local equippedName = equippedInstrument.name
                    local title = improvMenu:createLabel{id = tes3ui.registerID("RSA:ImprovMenu_Title"), text = equippedName}

                    local descrBlock = improvMenu:createBlock({id=tes3ui.registerID("RSA:ImprovMenu_DescriptionBlock")})
                    local description = descrBlock:createLabel({id=tes3ui.registerID("RSA:ImprovMenu_Description"), text = equippedInstrument.description})
                    descrBlock.autoHeight = true
                    descrBlock.width = 360
                    descrBlock.flowDirection = "left_to_right"
                    descrBlock.wrapText = true

                    local modeBlock = improvMenu:createBlock({id=tes3ui.registerID("RSA:ImprovMenu_ModeBlock")})
                    modeBlock.borderTop = 6
                    modeBlock.autoHeight = true
                    modeBlock.autoWidth = true
                    modeBlock.flowDirection = "top_to_bottom"

                    local modeButtonID = tes3ui.registerID("RSA:ImprovMenu_ModeButton")

                    for _, mode in pairs(equippedInstrument.modes) do
                        local subBlock = modeBlock:createBlock({id = tes3ui.registerID("RSA:ImprovMenu_ModeSelect")})
                        subBlock.autoHeight = true
                        subBlock.autoWidth = true
                        subBlock.flowDirection = "left_to_right"

                        local iconPath = mode.icon
                        local modeIcon = subBlock:createImage({path=iconPath})
                        modeIcon.autoHeight = 32
                        modeIcon.autoWidth = 32
                        modeIcon.borderAllSides = 4

                        local modeButton = subBlock:createButton{
                            id = modeButtonID,
                            text = mode.name,
                        }

                        modeButton:register("help", function()
                            local labelText = mode.description
                            HUD.createTooltip({text = labelText})
                        end)

                        modeButton:register("mouseClick", function()
                            tes3ui.leaveMenuMode()
                            improvMenu:destroy()
                            improvMenuCreated = 0
                            startImprov()
                        end)
                    end

                    local cancelImprovBlock = improvMenu:createBlock({id=tes3ui.registerID("RSA:ImprovMenu_CancelBlock")})
                    cancelImprovBlock.borderTop = 6
                    cancelImprovBlock.autoHeight = true
                    cancelImprovBlock.autoWidth = true
                    cancelImprovBlock.flowDirection = "left_to_right"

                    local cancelImprovButtonId = tes3ui.registerID("RSA:ImprovMenu_CancelButton")
                    local cancelImprovButton = cancelImprovBlock:createButton{
                        id = cancelImprovButtonId,
                        text = tes3.findGMST(tes3.gmst.sCancel).value,
                    }

                    cancelImprovButton:register("mouseClick", function()
                            tes3ui.leaveMenuMode()
                            improvMenu:destroy()
                            improvMenuCreated = 0
                    end)

                end
            end)

            local improvIcon = borderImprov:createImage{path = improvIconPath}
            improvIcon.consumeMouseEvents = false
            improvIcon.absolutePosAlignX = 0.8
            improvIcon.absolutePosAlignY = 0.8

            borderImprov.height = 136
            --

            -- Create button callbacks for composition menu --
            local optionComposition = optionsBlock:createBlock{id = tes3ui.registerID("RSA:Menu_OptionComposition")}
            optionComposition.width = 180
            optionComposition.autoHeight = true
            optionComposition.flowDirection = "top_to_bottom"

            local borderComposition = optionComposition:createThinBorder{}
            borderComposition.autoWidth = true
            borderComposition.paddingAllSides = 5
            borderComposition.absolutePosAlignX = 0.5

            local compositionIconPath = menuElementsPath.."rsa_compositionico.dds"

            local compositionButton = ImageButton.create(borderComposition, menuElementsPath.."rsa_compositionbg.dds", 128, 128)
            compositionButton:register("mouseClick", function()
                tes3ui.leaveMenuMode()
                RSAMenu:destroy()
                RSAmenuCreated = 0

                createCompositionMenu()

            end)

            local compositionIcon = borderComposition:createImage{path = compositionIconPath}
            compositionIcon.consumeMouseEvents = false
            compositionIcon.absolutePosAlignX = 0.5
            compositionIcon.absolutePosAlignY = 0.5

            borderComposition.height = 136
            --
            local footerBlock = RSAMenu:createBlock({id=tes3ui.registerID("RSA:Menu_Footer")})
            footerBlock.borderTop = 4
            footerBlock.autoHeight = true
            footerBlock.autoWidth = true
            footerBlock.flowDirection = "left_to_right"

            local footerDivider = footerBlock
            :createImage{path = menuElementsPath.."rsa_divider.dds"}
                footerDivider.autoHeight=true
                footerDivider.autoWidth=true
                footerDivider.borderBottom = 5
                footerDivider.borderTop = 5
                footerDivider.imageScaleX=0.6
                footerDivider.imageScaleY=0.6
                footerDivider.color = tes3ui.getPalette("normal_color")
            --

            local cancelBlock = RSAMenu:createBlock({id=tes3ui.registerID("RSA:Menu_CancelBlock")})
            cancelBlock.borderTop = 6
            cancelBlock.autoHeight = true
            cancelBlock.autoWidth = true
            cancelBlock.flowDirection = "left_to_right"

            local cancelButtonId = tes3ui.registerID("RSA:Menu_CancelButton")
            local cancelButton = cancelBlock:createButton{
                id = cancelButtonId,
                text = tes3.findGMST(tes3.gmst.sCancel).value,
            }

            cancelButton:register("mouseClick", function()
                    tes3ui.leaveMenuMode()
                    RSAMenu:destroy()
                    RSAmenuCreated = 0
                end
            )

        end
    end
end

-- This is the main function controlling key hits --
local function keyController(e)

    -- Toggle between instrument modes in music mode --
    if tes3.player.data.RSA.musicMode == true then
        if e.keyCode == config.modeToggleKey then
            toggleMode()
        end
    end

    -- Controls whether we should enter improvisation mode if not in music mode at all or create composition menu inside music mode --
    if e.keyCode == config.musicModeKey then
        if tes3.player.data.RSA.musicMode == false or not tes3.player.data.RSA.musicMode then
            timer.start{
                duration = 2,
                type = timer.simulate,
                callback = keyCheck
            }
        elseif tes3.player.data.RSA.compositionPlaying == false then
            createCompositionMenu()
        end
    end

    -- The following function won't trigger unless we are in the music mode --
    if tes3.player.data.RSA.musicMode ~= true then return end

    -- Vanity mode controller --
    if e.keyCode == config.vanityKey then
        if vanityFlag == 0 then
            tes3.setVanityMode({enabled = true})
            vanityFlag = 1
        else
            tes3.setVanityMode({enabled = false})
            vanityFlag = 0
        end
    end

    -- Cancel playing at any time --
    if e.keyCode == config.cancelKey then
        tes3.player.data.RSA.compositionPlaying = false
        playMusic.removeMusic(tes3.player)
        animController.playAnimation(tes3.player, tes3.animationStartFlag.immediate, equippedInstrument.animation.idle, tes3.animationGroup.idle9, equippedInstrument)
    end

    -- THe following control playing riffs --
    if tes3.player.data.RSA.compositionPlaying ~= true then
        local riff1Path, riff2Path, riff3Path
        -- Get valid riff paths from currently selected mode --
        for _, mode in pairs(equippedInstrument.modes) do
            if mode.name == tes3.player.data.RSA.currentMode then
                riff1Path = mode.riff1
                riff2Path = mode.riff2
                riff3Path = mode.riff3
            end
        end

        -- Keybind riff logic --
        if e.keyCode == riffKeys.riff1 then
            animController.ridTimers()
            -- Play current riff track --
            playMusic.playMusic(riff1Path, tes3.player)
            animController.playAnimation(tes3.player, tes3.animationStartFlag.immediate, equippedInstrument.animation.riff1, tes3.animationGroup.idle9, equippedInstrument)

            -- Start the idle timer --
            animController.riffTimer = timer.start{
                duration = tes3.player.data.RSA.riffLength,
                callback=function()
                    animController.playAnimation(tes3.player, tes3.animationStartFlag.immediate,  equippedInstrument.animation.idle, tes3.animationGroup.idle9, equippedInstrument)
                end,
                type = timer.simulate
            }
        elseif e.keyCode == riffKeys.riff2 then
            animController.ridTimers()
            playMusic.playMusic(riff2Path, tes3.player)
            animController.playAnimation(tes3.player, tes3.animationStartFlag.immediate, equippedInstrument.animation.riff2, tes3.animationGroup.idle9, equippedInstrument)
            animController.riffTimer = timer.start{
                duration = tes3.player.data.RSA.riffLength,
                callback=function()
                    animController.playAnimation(tes3.player, tes3.animationStartFlag.immediate,  equippedInstrument.animation.idle, tes3.animationGroup.idle9, equippedInstrument)
                end,
                type = timer.simulate
            }
        elseif e.keyCode == riffKeys.riff3 then
            animController.ridTimers()
            playMusic.playMusic(riff3Path, tes3.player)
            animController.playAnimation(tes3.player, tes3.animationStartFlag.immediate, equippedInstrument.animation.riff3, tes3.animationGroup.idle9, equippedInstrument)
            animController.riffTimer = timer.start{
                duration = tes3.player.data.RSA.riffLength,
                callback=function()
                    animController.playAnimation(tes3.player, tes3.animationStartFlag.immediate,  equippedInstrument.animation.idle, tes3.animationGroup.idle9, equippedInstrument)
                end,
                type = timer.simulate
            }
        end
    end

end

-- Cancel the animation if the player is attacked in the music mode --
-- It only triggers after the equip animation --
local function onAttacked(e)
    if e.targetReference == tes3.player and tes3.player.data.RSA.musicMode == true then
        animController.cancelAnimation(playerMesh, equippedInstrument, tes3.player)
    end
end

event.register("uiActivated", HUD.createHUD, { filter = "MenuMulti" })

event.register("attack", onAttacked)

event.register("keyDown", createMenu, {filter = tes3.scanCode.n})
event.register("keyDown", keyController)
