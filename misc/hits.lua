local config = require("Resdayn Sonorant Apparati.config")
local debugLogOn = config.debugLogOn
local modversion = require("Resdayn Sonorant Apparati\\version")
local version = modversion.version

local data = require("Resdayn Sonorant Apparati\\data\\data")
local hitInstruments = data.hitInstruments

local function debugLog(string)
    if debugLogOn then
       mwse.log("[Resdayn Sonorant Apparati "..version.."] Hit instruments module: "..string)
    end
end

-- Check if the weapon is a mallet, and determine its type --
local function isMallet(w)
    for _, instrument in pairs(hitInstruments) do
        if instrument.requirements ~= nil then
            for _, req in pairs(instrument.requirements) do
                if req.id == w.object.id:lower() then
                    return req.type
                end
            end
        end
    end
    return false
end

-- The following functions for statics are (heavily) inspired by Merlord's Ashfall --
local function onAttack(--[[e]])

    -- Optionally we can block other actors from playing sound, but hey, if it hits, it hits --
    --[[
    local actor = e.reference
    if (actor ~= tes3.player) then
        return
    end]]

    local targetRef = nil

    local eyePos = tes3.getPlayerEyePosition()
    local eyeDirection = tes3.getPlayerEyeVector()

    local result = tes3.rayTest{
        position = eyePos,
        direction = eyeDirection,
        ignore = {tes3.player}
    }

    if result and result.reference then
        local distance = eyePos:distance(result.intersection)
        if distance < 200 then
            targetRef = result.reference
        end
    end

    -- We don't want to continue if the object is too far away or is not a static --
    if (targetRef~=nil) and (targetRef.object.objectType ~= tes3.objectType.static) then return end

    if targetRef~=nil then
        debugLog("Target: "..targetRef.object.id)

        -- Check which hit instrument we're playing --
        for _, instrument in pairs(hitInstruments) do
            if string.startswith(targetRef.object.id, instrument.id) then

                -- Get the player's weapon --
                local weapon = tes3.mobilePlayer.readiedWeapon

                -- If we're not barehanded --
                if weapon then

                    -- Check if weapon is a mallet --
                    debugLog("Checking weapon: "..weapon.object.id)
                    local mallet = isMallet(weapon)
                    local malletPitch
                    if mallet ~= false then

                        debugLog("Detected mallet weapon.")
                        -- Set pitch per mallet type --
                        if mallet == "mallet" then
                            malletPitch = 1.0
                        else
                            malletPitch = 0.8
                        end

                        tes3.playSound{
                            soundPath = "Vo\\RSA\\hits\\"..instrument.id..".mp3",
                            pitch = malletPitch or 1.0,
                            reference = targetRef
                        }
                        debugLog("Played hit sound: "..instrument.id..".mp3")
                        break

                    else
                        -- If we don't use a mallet weapon, play metallic noise --
                        tes3.playSound{
                            soundPath = "Vo\\RSA\\hits\\rsa_gong-failed.mp3",
                            reference = targetRef
                        }
                        debugLog("Played failed hit sound.")
                    end
                else
                    -- If we're barehanded, play metallic noise --
                    tes3.playSound{
                        soundPath = "Vo\\RSA\\hits\\rsa_gong-failed_hh.mp3",
                        reference = targetRef
                    }
                    debugLog("Played failed hit sound (barehands).")
                end
            end
        end
    end

end

debugLog("Module initialised.")
event.register("attack", onAttack)
