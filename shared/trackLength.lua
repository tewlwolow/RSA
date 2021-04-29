local this = {}

-- A small and fast function to return Morrwind MP3 length in seconds --
-- This will only work with tagless MP3s that conform to the Morrowind voice files format (merged mono 64 kbit/s CBR) --
function this.getTrackLength(path)

    -- Get the total file size in bytes --
    local lfs = require "lfs"
	local size = lfs.attributes ("Data Files\\Sound\\"..path, "size")

	-- We're only going to work with 64 CBR bitrate --
	local bitRate = 64

	-- Set the milisec calc value --
	local milisec = 0.001

	-- Return length in seconds by dividing size by bitrate and converting to seconds from miliseconds
	return (size / (bitRate / (8))) * milisec

end

return this