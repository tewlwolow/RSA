local RSAData = require("Resdayn Sonorant Apparati\\data\\data")

local tooltipsComplete = include("Tooltips Complete.interop")

local tooltipData = {}
local i = 0
for _, instrument in pairs(RSAData.instruments) do
    local rsaID = instrument.id
    local rsaDescr = instrument.description
    i = i + 1
    tooltipData[i] = {id = rsaID, description = rsaDescr}
end
for _, type in pairs(RSAData.accessories) do
    for _, acc in pairs (type) do
        local rsaID = acc.id
        local rsaDescr = acc.description
        i = i + 1
        tooltipData[i] = {id = rsaID, description = rsaDescr}
    end
end



local function initialized()
    if tooltipsComplete then
        for _, data in ipairs(tooltipData) do
            tooltipsComplete.addTooltip(data.id, data.description, data.itemType)
        end
    end
end

initialized()