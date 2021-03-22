local config = require("RSA.config")
local debugLogOn = config.debugLogOn
local modversion = require("RSA\\version")
local version = modversion.version
local data = require("RSA\\hitsData")

local hitInstruments = data.hitInstruments

local function debugLog(string)
    if debugLogOn then
       mwse.log("[RSA "..version.."]: "..string)
    end
end

local function isMallet(w)
    if string.find(w.object.id:lower(), "mallet") then return true else return false end
end

local function onAttack(--[[e]])

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

    if targetRef~=nil and targetRef.object.objectType ~= tes3.objectType.static then return end

    if targetRef~=nil then
        debugLog("Target: "..targetRef.object.id)
        local weapon = tes3.mobilePlayer.readiedWeapon
        if weapon then
            debugLog("Checking weapon: "..weapon.object.id)
            if isMallet(weapon) == true then
                debugLog("Detected mallet weapon.")
                for rsaID, _ in pairs(hitInstruments) do
                    if string.startswith(targetRef.object.id, rsaID) then
                        tes3.playSound{
                            soundPath = "RSA\\hits\\"..rsaID..".wav",
                            reference = targetRef
                        }
                        debugLog("Played hit sound: "..rsaID..".wav")
                        break
                    end
                end
            else
                tes3.playSound{
                    soundPath = "RSA\\hits\\rsa_gong-failed.wav",
                    reference = targetRef
                }
                debugLog("Played failed hit sound.")
            end
        else
            tes3.playSound{
                soundPath = "RSA\\hits\\rsa_gong-failed.wav",
                reference = targetRef
            }
            debugLog("Played failed hit sound.")
        end
    end

end

event.register("attack", onAttack)