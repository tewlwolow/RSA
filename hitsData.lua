local this = {}

-- This is the array to point to valid CS records and sound files --
-- The keys indicate a prefix for CS objects --
-- The whole key string is also the exact name of a sound file to play --
-- Values are use to create tooltips for static objects --
this.hitInstruments = {
    ["rsa_gong-plain"] = "Plain Framed Gong",
    ["rsa_gong-ornate"] = "Ornate Framed Gong",
    ["rsa_gong-ancient"] = "Ancient Framed Gong"
}

return this