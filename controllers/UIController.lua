local data = require("Resdayn Sonorant Apparati\\data\\data")
local animController = require("Resdayn Sonorant Apparati\\controllers\\animationController")

local RSAmenuCreated = 0
local improvMenuCreated = 0
local menuElementsPath = "Icons\\RSA\\ui\\menu\\"

local playerMesh, equippedData, equippedInstrument

local ImageButton = {}

local modversion = require("Resdayn Sonorant Apparati\\version")
local version = modversion.version
local config = require("Resdayn Sonorant Apparati.config")
local debugLogOn = config.debugLogOn
local function debugLog(string)
    if debugLogOn then
       mwse.log("[Resdayn Sonorant Apparati "..version.."] Main UI Controller: "..string)
    end
end

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

-- Main RSA menu --
local RSAMenuID = tes3ui.registerID("RSA:Menu")
local function createMenu(e)
    if e.isAltDown then
        debugLog("Creating RSA Menu.")
        -- Get the player mesh to restore controls later --
        playerMesh = tes3.player.object.mesh

        -- Check if we have equipped an RSA instrument, return if false --
        equippedData = tes3.player.data.RSA.equipped
        local node = tes3.player.sceneNode:getObjectByName("Bip01 Attached Instrument")
        if node == nil then
            tes3.messageBox("You haven't got any instrument equipped.")
            return
        else
            for _, instrument in pairs(data.instruments) do
                if equippedData == instrument.id then
                    equippedInstrument = instrument
                    break
                end
            end
        end

        -- Check the flag, otherwise it somehow triggers twice --
        if RSAmenuCreated ~= 1 then
            RSAmenuCreated = 1
            local RSAMenu = tes3ui.createMenu{ id = RSAMenuID, fixedFrame = true }
            RSAMenu:getContentElement().childAlignX = 0.5
            tes3ui.enterMenuMode(RSAMenuID)

            local equippedName = equippedInstrument.name
            local title = RSAMenu:createLabel{id = tes3ui.registerID("RSA:Menu_Title"), text = equippedName}

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
            optionImprov.flowDirection = "top_to_bottom"

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

                    local modeBlock = improvMenu:createBlock({id=tes3ui.registerID("RSA:ImprovMenu_ModeBlock")})
                    modeBlock.borderTop = 6
                    modeBlock.autoHeight = true
                    modeBlock.autoWidth = true
                    modeBlock.flowDirection = "left_to_right"

                    local modeButtonID = tes3ui.registerID("RSA:ImprovMenu_ModeButton")

                    for _, mode in pairs(equippedInstrument.modes) do
                        local modeButton = modeBlock:createButton{
                            id = modeButtonID,
                            text = mode.name,
                        }
                        modeButton:register("mouseClick", function()
                            tes3ui.leaveMenuMode()
                            improvMenu:destroy()
                            improvMenuCreated = 0
                            --tes3.messageBox("Playing mode: "..mode.name..": "..mode.description)

                            animController.startImprovCycle(equippedInstrument, playerMesh, tes3.player)

                        end)
                    end
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
                    tes3.messageBox("[TODO: COMPOSITION MENU]")
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
                footerDivider.imageScaleX=0.8
                footerDivider.imageScaleY=0.8
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

event.register("key", createMenu, {filter = tes3.scanCode.n})
