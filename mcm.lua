local configPath = "Resdayn Sonorant Apparati"
local config = require("RSA.config")
mwse.loadConfig("Resdayn Sonorant Apparati")
local modversion = require("RSA\\version")
local version = modversion.version

local function registerVariable(id)
    return mwse.mcm.createTableVariable{
        id = id,
        table = config
    }
end

local template = mwse.mcm.createTemplate{
    name="Resdayn Sonorant Apparati",
    headerImagePath="\\Textures\\RSA\\RSA_logo.tga"}

    local page = template:createPage{label="Main Settings", noScroll=true}
    page:createCategory{
        label = "Resdayn Sonorant Apparati "..version.." by insicht, Leyawynn, and tewlwolow.\nMain lua core.\n\nSettings:",
    }

    page:createYesNoButton{
        label = "Enable debug mode?",
        variable = registerVariable("debugLogOn"),
        restartRequired=true
    }

    page:createYesNoButton{
        label = "Enable tooltips? Requires Tooltips Complete.",
        variable = registerVariable("tooltipsOn"),
        restartRequired=true
    }

    page:createYesNoButton{
        label = "Enable hit instruments functionality?",
        variable = registerVariable("hitsOn"),
        restartRequired=true
    }

    --[[page:createYesNoButton{
        label = "Show names for static objects?",
        variable = registerVariable("staticNamesOn"),
        restartRequired=true
    }]]


template:saveOnClose(configPath, config)
mwse.mcm.register(template)
