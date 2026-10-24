-- Все числа аддона в одном месте: что каждая модовая основная атака получает от PSE.

PSEM = PSEM or {}

PSEM.Config = {

    fps = 60,

    gunners = {
        executionerZ   = { magazine = 10, reload = 1.3, cone = 35 },
        ReclaimerZ     = { magazine = 4,  reload = 1.6, cone = 25 },
        reclaimerZ2    = { magazine = 11, reload = 1.3, cone = 30 },
        reclaimerZ3    = { magazine = 5,  reload = 1.7, cone = 20 },
        rexZ           = { magazine = 5,  reload = 1.5, cone = 30 },
        zerimpZ        = { magazine = 5,  reload = 1.4, cone = 30 },
        hunterZ        = { magazine = 14, reload = 1.4, cone = 30 },
        technicianZ2   = { magazine = 6,  reload = 1.5, cone = 30 },
        WispZ          = { magazine = 5,  reload = 1.3, cone = 30 },
        GreaterWispZ   = { magazine = 6,  reload = 1.4, cone = 25 },
        ArchaicWispZ   = { magazine = 6,  reload = 1.4, cone = 25 },
        NautilusZ      = { magazine = 5,  reload = 1.3, cone = 30 },
        ScavengerZ     = { magazine = 4,  reload = 1.6, cone = 20 },
        captainZ       = { magazine = 3,  reload = 1.6, cone = 20 },

        AdmiralZ          = { magazine = 5,  reload = 1.6, cone = 35 },
        admiralZ2         = { magazine = 5,  reload = 1.4, cone = 35 },
        helperZ           = { magazine = 5,  reload = 1.6, cone = 20 },
        helperZ2          = { magazine = 4,  reload = 1.7 },
        worldsReclaimerZ  = { magazine = 4,  reload = 1.6, cone = 25 },
        worldsReclaimerZ2 = { magazine = 11, reload = 1.3, cone = 30 },
        worldsReclaimerZ3 = { magazine = 5,  reload = 1.7, cone = 20 },
        Bang              = { magazine = 3,  reload = 1.5, cone = 25 },
        Blast             = { cone = 20 },
        Slug              = { cone = 25 },
        Shotty            = { cone = 20 },
    },

    hunter_charged = 4,

    melee = {
        RevenantZ          = 7,
        nemesisMercenaryZ  = 14,
        technicianZ        = 7,
        GigachadZ          = 6,
        GigachadZ2         = 5,
        jammanZ            = 10,
        nemesisCommandoZ   = 8,
        fishmongerZ        = 8,
        GinZ               = 30,
        LemurianZ          = 6,
        ElderLemurianZ     = 3,
        GolemZ             = 4,
        ParentZ            = 4,
        MacrobicPredatorZ  = 3,
        TardigradeZ        = 2,
        muleZ              = 8,
        BitwarriorZ        = 6,
    },

    finisher = {
        GinZ = 90,
    },
}
