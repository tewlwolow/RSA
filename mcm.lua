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

    page:createDropdown{
        label = "Choose a keybind map to play riffs with:",
        options = {
            {label = "Numpad 1-2-3(default)", value = "numpad"},
            {label = "Q-W-E", value = "QWE"},
        },
        variable=registerVariable("riffKeys")
    }


    page:createKeyBinder{
        label = "This key controls the music mode. Press alt+key to bring up the RSA menu or long press to go into improvisation mode.\nPress again in improvisation mode to show the composition menu.\nDefault = N.",
        allowCombinations = false,
        variable = registerVariable("musicModeKey"),
    }

    page:createKeyBinder{
        label = "This key enables switching between instrument modes (scales) in the improvisation mode.\nDefault = numpad 0.",
        allowCombinations = false,
        variable = registerVariable("modeToggleKey"),
    }

    page:createKeyBinder{
        label = "This is the cancel key. Press alt+key in the music mode to switch the music mode off and get back to regular playing\nPressing this key in the music mode will stop the currently played riff or composition.\nDefault = X.",
        allowCombinations = false,
        variable = registerVariable("cancelKey"),
    }

    page:createKeyBinder{
        label = "This key enables vanity mode in the music mode.\nDefault = TAB.",
        allowCombinations = false,
        variable = registerVariable("vanityKey"),
    }


template:saveOnClose(configPath, config)
mwse.mcm.register(template)
