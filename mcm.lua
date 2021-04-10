local configPath = "Resdayn Sonorant Apparati"
local config = require("Resdayn Sonorant Apparati.config")
mwse.loadConfig("Resdayn Sonorant Apparati")
local modversion = require("Resdayn Sonorant Apparati\\version")
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
        label = "Enable item tooltips? Requires Tooltips Complete.",
        variable = registerVariable("tooltipsOn"),
        restartRequired=true
    }

    page:createYesNoButton{
        label = "Enable playing hit instruments with mallets?\nFind a mallet (blunt weapon) and swing it at a hit instrument (f.ex. a gong) to play it. Using a different weapon will create noise.\nNote: Big mallets hit deeper notes.",
        variable = registerVariable("hitsOn"),
        restartRequired=true
    }

    page:createYesNoButton{
        label = "Show names for static objects?",
        variable = registerVariable("staticNamesOn"),
        restartRequired=true
    }


template:saveOnClose(configPath, config)
mwse.mcm.register(template)
