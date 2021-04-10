local this = {}

--[[
    -- TEMPLATE ==

   {
        id = id from Construction Set,
        name = name from Construction Set,
        type = instrument type - governs which riffs we can play,
        animation = animation type per this.animations,
        mesh = meshes//..path,
        description = this is being fed to game menus and Tooltips Complete interop,
        culture = governs which modes we can play,
        -- leave .modes empty. the code at the bottom of this file will automatically create path per instrument, culture, and mode
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        -- full name for the menus, path to the composition, e.g. "RSA\\instrument.culture\\instrument.type\\compositions\\rsa_compositionname.wav/mp3"
        compositions = {
            {
                name = nil,
                path = nil
            }
        },
        -- this includes accesories, other objects, consumables etc.
        requirements = nil,
    },



]]

this.modes = {
    ["Dunmer"] = {
        {
            name = "Bahraan",
            description = "Bahraan is a solemn Dunmer mode."
        },
        {
            name = "Luvasi",
            description = "Luvasi is a romantic Dunmer mode."
        },
        {
            name = "Ruhn Kelak",
            description = "Ruhn Kelak is a vigorous Dunmer mode."
        },
    },
}

-- TODO - populate via code and string.find from lfs
this.animations = {
    ["bowedSitting"] =
    {
        equip = "",
        idle = "",
        playRiff1 = "RSA\\anims\\",
        playRiff2 = "RSA\\anims\\",
        playRiff3 = "RSA\\anims\\",
    },
    ["frameDrumSitting"] =
    {
        equip = "",
        idle = "",
        playRiff1 = "RSA\\anims\\",
        playRiff2 = "RSA\\anims\\",
        playRiff3 = "RSA\\anims\\",
    },
    ["gobletDrumSitting"] =
    {
        equip = "",
        idle = "",
        playRiff1 = "RSA\\anims\\",
        playRiff2 = "RSA\\anims\\",
        playRiff3 = "RSA\\anims\\",
    },
    ["kushikStanding"] =
    {
        equip = "",
        idle = "",
        playRiff1 = "RSA\\anims\\",
        playRiff2 = "RSA\\anims\\",
        playRiff3 = "RSA\\anims\\",
    },
    ["lute"] =
    {
        equip = "RSA\\anims\\lute\\luteEquip.nif",
        idle = "RSA\\anims\\lute\\luteIdle.nif",
        playRiff1 = "RSA\\anims\\",
        playRiff2 = "RSA\\anims\\",
        playRiff3 = "RSA\\anims\\",
    },
    ["zitherHorizontal"] =
    {
        equip = "",
        idle = "",
        playRiff1 = "RSA\\anims\\",
        playRiff2 = "RSA\\anims\\",
        playRiff3 = "RSA\\anims\\",
    },
}


this.accessories = {
    ["bow"] = {
        {
            id = "rsa_bow",
            name = "Simple Music Bow",
            mesh = "tew\\ins\\bow.nif",
            description = "A simple wooden bow used in traditional Dark Elf music - or \"leyr\" in Dunmeri parlance. The legend has it the early Velothi hunters discovered the musical properties of a simple chitin bow by accident, when their resin-covered hands touched a lute string, producing a sound unlike any before. To this day the resin retrieved from Vvardenfell shalks is widely used in Dunmeri music tradition.",
        },
        {
            id = "rsa_bow2",
            name = "Music Bow",
            mesh = "tew\\ins\\bow.nif",
            description = "A simple wooden bow used in traditional Dark Elf music - or \"leyr\" in Dunmeri parlance. The legend has it the early Velothi hunters discovered the musical properties of a simple chitin bow by accident, when their resin-covered hands touched a lute string, producing a sound unlike any before. To this day the resin retrieved from Vvardenfell shalks is widely used in Dunmeri music tradition.",
        },
        {
            id = "rsa_bow3",
            name = "Music Bow",
            mesh = "tew\\ins\\bow.nif",
            description = "A simple wooden bow used in traditional Dark Elf music - or \"leyr\" in Dunmeri parlance. The legend has it the early Velothi hunters discovered the musical properties of a simple chitin bow by accident, when their resin-covered hands touched a lute string, producing a sound unlike any before. To this day the resin retrieved from Vvardenfell shalks is widely used in Dunmeri music tradition.",
        },

    },
    ["mallet"] = {
        {
            id = "rsa_gong-mallet1",
            name = "Gong Mallet",
            type = "mallet",
            mesh = "tew\\ins\\tew_gong-mallet1.nif",
            description = "This simple mallet made of wood and leather is ideal for playing framed gongs."
        },
        {
            id = "rsa_gong-mallet2",
            name = "Gong Mallet",
            type = "mallet",
            mesh = "tew\\ins\\tew_gong-mallet2.nif",
            description = "This simple mallet made of wood and leather is ideal for playing framed gongs."
        },
        {
            id = "rsa_gong-bigmallet1",
            name = "Big Gong Mallet",
            type = "big mallet",
            mesh = "tew\\ins\\tew_gong-bigmallet1.nif",
            description = "This simple mallet made of wood and leather is ideal for playing framed gongs. This bigger version is used to play deeper notes."
        },
        {
            id = "rsa_gong-bigmallet2",
            name = "Big Gong Mallet",
            type = "big mallet",
            mesh = "tew\\ins\\tew_gong-bigmallet2.nif",
            description = "This simple mallet made of wood and leather is ideal for playing framed gongs. This bigger version is used to play deeper notes."
        },
    }

}

this.hitInstruments = {
    {
        id = "rsa_gong-plain",
        name = "Plain Framed Gong",
        requirements = this.accessories["mallet"]
    },
    {
        id = "rsa_gong-ornate",
        name = "Ornate Framed Gong",
        requirements = this.accessories["mallet"]
    },
    {
        id = "rsa_gong-ancient",
        name = "Ancient Framed Gong",
        requirements = this.accessories["mallet"]
    },
}

this.instruments = {

   {
        id = "rsa_ahlouad",
        name = "Ahlouad",
        type = "ahlouad",
        animation = this.animations["lute"],
        mesh = "tew\\ins\\ahlouad.nif",
        equipRotation = {4.5, 0.05, 4.98},
        equipPosition = {-1, -10, -1},
        description = "This ancient instrument's name can be rendered as \"river surface\", as the upper edge of its neck is covered with a smooth layer, allowing for long-reaching pitch \"slides\", typical for most intricate Dunmeri compositions. The wood's bulkiness is balanced by rich ornamentation, and the price is accordingly high.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil
            }
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_ahlouad-orn",
        name = "Ornate Ahlouad",
        type = "ahlouad",
        animation = this.animations["lute"],
        mesh = "tew\\ins\\ahlouad-orn.nif",
        equipRotation = {4.5, 0.05, 4.98},
        equipPosition = {-1, -10, -1},
        description = "This ancient instrument's name can be rendered as \"river surface\", as the upper edge of its neck is covered with a smooth layer, allowing for long-reaching pitch \"slides\", typical for most intricate Dunmeri compositions. The wood's bulkiness is balanced by rich ornamentation, and the price is accordingly high.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
                },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil
            }
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_ahlouad-seryn",
        name = "St. Seryn's Solace",
        type = "ahlouad",
        animation = this.animations["lute"],
        mesh = "tew\\ins\\ahlouad-seryn.nif",
        equipRotation = {4.5, 0.05, 4.98},
        equipPosition = {-1, -10, -1},
        description = "This elaborate ahlouad is rumoured to have been used by St. Seryn, the great Dunmer healer. The instrument's soothing tones are said to ease the burdens of life.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
                },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil
            }
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_cahnjerlosh",
        name = "Simple Cahnjerlosh",
        type = "cahnjerlosh",
        animation = this.animations["lute"],
        mesh = "tew\\ins\\cahn-jerlosh.nif",
        equipRotation = {4.8, 0.101, 5.01},
        equipPosition = {0, -11, 2},
        description = "Literally meaning \"three ropes\", the cahnjerlosh is a traditional Dunmeri long-necked, fretless lute, sporting two drone strings and one thin melody string. Vastly popular throughout Morrowind, the cahnjerlosh is usually accompanied by a guarskin drum or voice.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
                },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_cahnjerlosh-tel",
        name = "Telvanni Ceremonial Cahnjerlosh",
        type = "cahnjerlosh",
        animation = this.animations["lute"],
        mesh = "tew\\ins\\cahn-jerl-tel.nif",
        equipRotation = {4.8, 0.101, 5.01},
        equipPosition = {0, -11, 2},
        description = "Literally meaning \"three ropes\", the cahnjerlosh is a traditional Dunmeri long-necked, fretless lute, sporting two drone strings and one thin melody string. Vastly popular throughout Morrowind, the cahnjerlosh is usually accompanied by a guarskin drum or voice.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_dayereh-alit",
        name = "Alitskin Dayereh",
        type = "dayereh",
        animation = this.animations["frameDrumSitting"],
        mesh = "tew\\ins\\dayereh-alit.nif",
        equipRotation = {4.7, -0.1, 5.6},
        equipPosition = {10, -11, 0},
        description = "A simple frame drum made of a carved piece of wood and a piece of thin skin of the local alit. The Dunmer play the dayereh using a variety of hand strokes, producing a wide array of sounds - from low thumb thuds to rapid finger trills.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_dayereh-daed",
        name = "Daedric Skin Dayereh",
        type = "dayereh",
        animation = this.animations["frameDrumSitting"],
        mesh = "tew\\ins\\dayereh-daed.nif",
        equipRotation = {4.7, -0.1, 5.6},
        equipPosition = {10, -11, 0},
        description = "A simple frame drum made of a carved piece of wood and a piece of thin skin from a Daedric creature. The Dunmer play the dayereh using a variety of hand strokes, producing a wide array of sounds - from low thumb thuds to rapid finger trills.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_dayereh-guar1",
        name = "Guarskin Dayereh",
        type = "dayereh",
        animation = this.animations["frameDrumSitting"],
        mesh = "tew\\ins\\dayereh-guar.nif",
        equipRotation = {4.7, -0.1, 5.6},
        equipPosition = {10, -11, 0},
        description = "A simple frame drum made of a carved piece of wood and a piece of thin skin of the local guar. The Dunmer play the dayereh using a variety of hand strokes, producing a wide array of sounds - from low thumb thuds to rapid finger trills.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_dayereh-guar2",
        name = "Guarskin Dayereh",
        type = "dayereh",
        animation = this.animations["frameDrumSitting"],
        mesh = "tew\\ins\\dayereh-guar2.nif",
        equipRotation = {4.7, -0.1, 5.6},
        equipPosition = {10, -11, 0},
        description = "A simple frame drum made of a carved piece of wood and a piece of thin skin of the local guar. The Dunmer play the dayereh using a variety of hand strokes, producing a wide array of sounds - from low thumb thuds to rapid finger trills.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_fisrokahr",
        name = "Simple Fisrokahr",
        type = "fisrokahr",
        animation = this.animations["bowedSitting"],
        mesh = "tew\\ins\\fis-rokahr.nif",
        equipRotation = {4.7, -6.3, 4.5},
        equipPosition = {10, -14, 0},
        description = "The fisrokahr can be translated as \"bowl-sounding instrument\", since this bowed lyre resonates through a metal-encrusted cavity, skilfully crafted to amplify frequencies of ancient Velothi heptatonic scales. The fisrokahr are said to invoke strong emotions, and the weeping, droning sounds were so mind-altering that the instrument was historically banned from Temple grounds.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = this.accessories["bow"],
        effects = nil,
    },

    {
        id = "rsa_fisrokahr2",
        name = "Fisrokahr",
        type = "fisrokahr",
        animation = this.animations["bowedSitting"],
        mesh = "tew\\ins\\fis-rokahr2.nif",
        equipRotation = {4.7, -6.3, 4.5},
        equipPosition = {10, -14, 0},
        description = "The fisrokahr can be translated as \"bowl-sounding instrument\", since this bowed lyre resonates through a metal-encrusted cavity, skilfully crafted to amplify frequencies of ancient Velothi heptatonic scales. The fisrokahr are said to invoke strong emotions, and the weeping, droning sounds were so mind-altering that the instrument was historically banned from Temple grounds.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = this.accessories["bow"],
        effects = nil,
    },

    {
        id = "rsa_fisrokahr3",
        name = "Mercy of the Redoran",
        type = "fisrokahr",
        animation = this.animations["bowedSitting"],
        mesh = "tew\\ins\\fis-rokahr3.nif",
        equipRotation = {4.7, -6.3, 4.5},
        equipPosition = {10, -14, 0},
        description = "This fisrokahr is associated with Redoran warrior named Lllandu Runyon, a Redoran warrior-poet known for his mercy for captured Imperial legionnaires during Tiber Septim's invasion of Morrowind. To show the civilised side of the settled Dunmer, he would sit down and play traditional Redoran tunes to the captives. The fisrokahr is said to possess magical qualities.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = this.accessories["bow"],
        effects = nil,
    },

    {
        id = "rsa_jentreng",
        name = "Simple Jentreng",
        type = "jentreng",
        animation = this.animations["zitherHorizontal"],
        mesh = "tew\\ins\\jentreng.nif",
        equipRotation = {4.7, -6.3, 4.5},
        equipPosition = {-9, -10, 0},
        description = "A central part of Dunmeri ancestral rituals, the jentreng is a plucked zither fashioned from a large piece of dry wood and decorated in a variety of ways. The traditional way of playing the jentreng involves memorising a set of \"gashneh\", or movements, each tied closely to an ancestral dance piece, where a dancer swirls gracefully on one foot, holding a piece of coloured fabric fluttering through incense-filled air. The performance is said to summon spirits of the ancestors.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_jentreng2",
        name = "Vivec's Sonance",
        type = "jentreng",
        animation = this.animations["zitherHorizontal"],
        mesh = "tew\\ins\\jentreng2.nif",
        equipRotation = {4.7, -6.3, 4.5},
        equipPosition = {-9, -10, 0},
        description = "This ornate jentreng is said to have been given by Vivec themselves to a poor farmer in the Ascadian Isles, who had been born to unknown parents, and thus could not perform ancestor worship. The sound of this jentreng is rumoured to invoke powerful spirits to aid the owner.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_jentreng3",
        name = "Ashen Jentreng",
        type = "jentreng",
        animation = this.animations["zitherHorizontal"],
        mesh = "tew\\ins\\jentreng3.nif",
        equipRotation = {4.7, -6.3, 4.5},
        equipPosition = {-9, -10, 0},
        description = "A central part of Dunmeri ancestral rituals, the jentreng is a plucked zither fashioned from a large piece of dry wood and decorated in a variety of ways. The traditional way of playing the jentreng involves memorising a set of \"gashneh\", or movements, each tied closely to an ancestral dance piece, where a dancer swirls gracefully on one foot, holding a piece of coloured fabric fluttering through incense-filled air. The performance is said to summon spirits of the ancestors.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_jentreng4",
        name = "St. Aralor's Blessing",
        type = "jentreng",
        animation = this.animations["zitherHorizontal"],
        mesh = "tew\\ins\\jentreng4.nif",
        equipRotation = {4.7, -6.3, 4.5},
        equipPosition = {-9, -10, 0},
        description = "Saint Aralor, a former wrongdoer, repented his sins and performed sacred pilgrimages on his own knees. His example shows that any and all Dunmer, no matter what wrong they might have done, can be accepted into the Tribunal Temple and be blessed with mercy of the Almsivi. This jentreng is said to have accompanied Saint Aralor in his travels, often reminding him of the importance of honourable deeds to be performed at daily basis.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_kushik",
        name = "Simple Kushik",
        type = "kushik",
        animation = this.animations["kushikStanding"],
        mesh = "tew\\ins\\kushik.nif",
        equipRotation = {4.4, -6.28, 4.5},
        equipPosition = {-9, -8.4, -5},
        description = "The kushik is the Dunmer version of a small hand drum, widely popular amongst many cultures of Tamriel due to of its simple design. Nevertheless, an able musician will be able to use the thin membrane and two sets of loose zills to play a nearly innumerable number of rhytmic patterns.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_kushik2",
        name = "Ancestral Kushik",
        type = "kushik",
        animation = this.animations["kushikStanding"],
        mesh = "tew\\ins\\kushik2.nif",
        equipRotation = {4.4, -6.28, 4.5},
        equipPosition = {-9, -8.4, -5},
        description = "The kushik is the Dunmer version of a small hand drum, widely popular amongst many cultures of Tamriel due to of its simple design. Nevertheless, an able musician will be able to use the thin membrane and two sets of loose zills to play a nearly innumerable number of rhytmic patterns.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_kushik3",
        name = "Ornate Kushik",
        type = "kushik",
        animation = this.animations["kushikStanding"],
        mesh = "tew\\ins\\kushik3.nif",
        equipRotation = {4.4, -6.28, 4.5},
        equipPosition = {-9, -8.4, -5},
        description = "The kushik is the Dunmer version of a small hand drum, widely popular amongst many cultures of Tamriel due to of its simple design. Nevertheless, an able musician will be able to use the thin membrane and two sets of loose zills to play a nearly innumerable number of rhytmic patterns.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_kushik4",
        name = "Fishskin Kushik",
        type = "kushik",
        animation = this.animations["kushikStanding"],
        mesh = "tew\\ins\\kushik4.nif",
        equipRotation = {4.4, -6.28, 4.5},
        equipPosition = {-9, -8.4, -5},
        description = "The kushik is the Dunmer version of a small hand drum, widely popular amongst many cultures of Tamriel due to of its simple design. Nevertheless, an able musician will be able to use the thin membrane and two sets of loose zills to play a nearly innumerable number of rhytmic patterns.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_kushik5",
        name = "Ceremonial Kushik",
        type = "kushik",
        animation = this.animations["kushikStanding"],
        mesh = "tew\\ins\\kushik5.nif",
        equipRotation = {4.4, -6.28, 4.5},
        equipPosition = {-9, -8.4, -5},
        description = "The kushik is the Dunmer version of a small hand drum, widely popular amongst many cultures of Tamriel due to of its simple design. Nevertheless, an able musician will be able to use the thin membrane and two sets of loose zills to play a nearly innumerable number of rhytmic patterns.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_kushik6",
        name = "Exquisite Kushik",
        type = "kushik",
        animation = this.animations["kushikStanding"],
        mesh = "tew\\ins\\kushik6.nif",
        equipRotation = {4.4, -6.28, 4.5},
        equipPosition = {-9, -8.4, -5},
        description = "The kushik is the Dunmer version of a small hand drum, widely popular amongst many cultures of Tamriel due to of its simple design. Nevertheless, an able musician will be able to use the thin membrane and two sets of loose zills to play a nearly innumerable number of rhytmic patterns.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_tumbehk",
        name = "Tumbehk",
        type = "tumbehk",
        animation = this.animations["gobletDrumSitting"],
        mesh = "tew\\ins\\tumbehk.nif",
        equipRotation = {3.1, -5.98, 4.2},
        equipPosition = {-2.7, -13.6, 2},
        description = "The tumbehk (an onomatopoeia) are traditional Dunmeri goblet drums, carved from a large piece of wood and covered with a stretched skin membrane. The drum is usually placed horizontally, the slim central piece nested between the player's arm and thigh. The instrument's shape allows a skilled musician to produce a vast amount of different sounds, and the tumbehk can be heard both solo and accompanying other players.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_tumbehk2",
        name = "Tumbehk",
        type = "tumbehk",
        animation = this.animations["gobletDrumSitting"],
        mesh = "tew\\ins\\tumbehk2.nif",
        equipRotation = {3.1, -5.98, 4.2},
        equipPosition = {-2.7, -13.6, 2},
        description = "The tumbehk (an onomatopoeia) are traditional Dunmeri goblet drums, carved from a large piece of wood and covered with a stretched skin membrane. The drum is usually placed horizontally, the slim central piece nested between the player's arm and thigh. The instrument's shape allows a skilled musician to produce a vast amount of different sounds, and the tumbehk can be heard both solo and accompanying other players.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_tumbehk3",
        name = "Ancient Tumbehk",
        type = "tumbehk",
        animation = this.animations["gobletDrumSitting"],
        mesh = "tew\\ins\\tumbehk3.nif",
        equipRotation = {3.1, -5.98, 4.2},
        equipPosition = {-2.7, -13.6, 2},
        description = "The tumbehk (an onomatopoeia) are traditional Dunmeri goblet drums, carved from a large piece of wood and covered with a stretched skin membrane. The drum is usually placed horizontally, the slim central piece nested between the player's arm and thigh. The instrument's shape allows a skilled musician to produce a vast amount of different sounds, and the tumbehk can be heard both solo and accompanying other players.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_tumbehk4",
        name = "Simple Tumbehk",
        type = "tumbehk",
        animation = this.animations["gobletDrumSitting"],
        mesh = "tew\\ins\\tumbehk4.nif",
        equipRotation = {3.1, -5.98, 4.2},
        equipPosition = {-2.7, -13.6, 2},
        description = "The tumbehk (an onomatopoeia) are traditional Dunmeri goblet drums, carved from a large piece of wood and covered with a stretched skin membrane. The drum is usually placed horizontally, the slim central piece nested between the player's arm and thigh. The instrument's shape allows a skilled musician to produce a vast amount of different sounds, and the tumbehk can be heard both solo and accompanying other players.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_tumbehk5",
        name = "Noble Tumbehk",
        type = "tumbehk",
        animation = this.animations["gobletDrumSitting"],
        mesh = "tew\\ins\\tumbehk5.nif",
        equipRotation = {3.1, -5.98, 4.2},
        equipPosition = {-2.7, -13.6, 2},
        description = "The tumbehk (an onomatopoeia) are traditional Dunmeri goblet drums, carved from a large piece of wood and covered with a stretched skin membrane. The drum is usually placed horizontally, the slim central piece nested between the player's arm and thigh. The instrument's shape allows a skilled musician to produce a vast amount of different sounds, and the tumbehk can be heard both solo and accompanying other players.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = nil,
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_zuileyr",
        name = "Zuileyr",
        type = "zuileyr",
        animation = this.animations["lute"],
        mesh = "tew\\ins\\zuileyr.nif",
        equipRotation = {4.8, 0.16, 5},
        equipPosition = {-2, -10, 0},
        description = "This wooden lute with curved, protruding frets was so popular amongst the settled Dunmer that its name literally translates as \"music thing\" or simply \"instrument\". The zuileyr's six strings - two drone strings, a double sympathetic string, and two melody strings - are more than enough to perform any piece of the poetry-inspired \"morhbaldefur\" (\"the hand above\") genre that brings together the myths and tales of all Dumner Houses.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = "RSA\\Dunmer\\zuileyr\\compositions\\rsa_zuileyr_velothgrace.wav",
            },
        },
        requirements = nil,
        effects = nil,
    },

    {
        id = "rsa_zuileyr-wht",
        name = "Zuileyr",
        type = "zuileyr",
        animation = this.animations["lute"],
        mesh = "tew\\ins\\zuileyr-wht.nif",
        equipRotation = {4.8, 0.16, 5},
        equipPosition = {-2, -10, 0},
        description = "This wooden lute with curved, protruding frets was so popular amongst the settled Dunmer that its name literally translates as \"music thing\" or simply \"instrument\". The zuileyr's six strings - two drone strings, a double sympathetic string, and two melody strings - are more than enough to perform any piece of the poetry-inspired \"morhbaldefur\" (\"the hand above\") genre that brings together the myths and tales of all Dumner Houses.",
        culture = "Dunmer",
        modes = {
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",
            },
            {
            name = "",
            description = "",
            riff1 = "",
            riff2 = "",
            riff3 = "",
            },
            {
                name = "",
                description = "",
                riff1 = "",
                riff2 = "",
                riff3 = "",

            },
        },
        compositions = {
            {
                name = nil,
                path = "RSA\\Dunmer\\zuileyr\\compositions\\rsa_zuileyr_velothgrace.wav",
            },
        },
        requirements = nil,
        effects = nil,
    },

}

local i = 0
for _, instrument in pairs(this.instruments) do
    for _, mode in pairs(this.modes[instrument.culture]) do
        local spacelessModeName = mode.name:gsub("%s+", "")
        local specelessInstrumentType = instrument.type:gsub("%s+", ""):lower()
        i = i + 1
        instrument.modes[i].name = mode.name
        instrument.modes[i].description = mode.description
        instrument.modes[i].riff1 = "RSA//"..instrument.culture.."//"..specelessInstrumentType.."//modes//"..mode.name.."//rsa_"..instrument.type:lower().."_"..spacelessModeName:lower().."1.wav"
        instrument.modes[i].riff2 = "RSA//"..instrument.culture.."//"..specelessInstrumentType.."//modes//"..mode.name.."//rsa_"..instrument.type:lower().."_"..spacelessModeName:lower().."2.wav"
        instrument.modes[i].riff3 = "RSA//"..instrument.culture.."//"..specelessInstrumentType.."//modes//"..mode.name.."//rsa_"..instrument.type:lower().."_"..spacelessModeName:lower().."3.wav"
    end
    i = 0
end

--[[
-- Let's check if we didn't fuck up big time.

for _, instrument in pairs(this.instruments) do
      print (instrument.name.."\n")
      print (instrument.type.."\n")
  for _, mode in pairs(instrument.modes) do
    print(mode.name, mode.description, mode.riff1, mode.riff2, mode.riff3)
  end
end

]]

return this
