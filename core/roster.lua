-- Что аддон знает о чужих модах: какая основная атака, из каких состояний она бьёт или стреляет, какие трассеры у её пуль.

PSEM = PSEM or {}

local R = {}

R.ATTACKS = {

    { key = "executionerZ", package = "RobomandosLab-StarstormReturns", kind = "gunner",
      skill = { "executionerZ", "ssr" }, states = { { "executionerPrimary", "ssr" } },
      tracers = { "COMMANDO1" } },

    { key = "ReclaimerZ", package = "GIC-Reclaimer", kind = "gunner",
      skill = { "ReclaimerZ", "ReclaimerSurvivor" }, states = { { "ReclaimerPrimary", "ReclaimerSurvivor" } },
      tracers = { "SNIPER2" } },

    { key = "reclaimerZ2", package = "GIC-Reclaimer", kind = "gunner",
      skill = { "reclaimerZ2", "ReclaimerSurvivor" }, states = { { "ReclaimerPrimary2", "ReclaimerSurvivor" } },
      tracers = { "COMMANDO1" } },

    { key = "RevenantZ", package = "LostGearProductions-Revenant", kind = "melee",
      skill = { "RevenantZ", "Revenant Mod" },
      states = { { "SmashingBlade1", "Revenant Mod" }, { "SmashingBlade2", "Revenant Mod" }, { "SmashingBlade3", "Revenant Mod" } },
      sparks = "sSparks7" },

    { key = "nemesisMercenaryZ", package = "RobomandosLab-StarstormReturns", kind = "melee",
      skill = { "nemesisMercenaryZ", "ssr" },
      states = { { "nemMercenaryAttachmentStabA", "ssr" }, { "nemMercenaryAttachmentStabB", "ssr" },
                 { "nemMercenaryAttachmentStabC", "ssr" }, { "nemMercenaryAttachmentStabD", "ssr" },
                 { "nemMercenaryAttachmentStabE", "ssr" } },
      sparks = "sSparks9" },

    { key = "technicianZ", package = "RobomandosLab-StarstormReturns", kind = "melee",
      skill = { "technicianZ", "ssr" }, states = { { "technicianPrimary", "ssr" } },
      sparks = "sSparks7", absent = "Starstorm beta off" },

    { key = "GigachadZ", package = "GreenAlen22-Gigachad", kind = "melee",
      skill = { "GigachadZ", "GreenAlen22" }, states = { { "GigachadZ", "GreenAlen22" } },
      sparks = "sSparks7" },
    { key = "GigachadZ2", package = "GreenAlen22-Gigachad", kind = "melee",
      skill = { "GigachadZ2", "GreenAlen22" }, states = { { "GigachadZ2", "GreenAlen22" } },
      sparks = "sSparks7" },

    { key = "jammanZ", package = "RoRRModdingToolkit-Jam", kind = "melee",
      skill = { "jammanZ", "RMT" }, states = { { "jammanZ", "RMT" } },
      sparks = "sSparks7", unless = "ricottakitten-Deserter" },

    { key = "reclaimerZ3", package = "GIC-Reclaimer", kind = "gunner",
      skill = { "reclaimerZ3", "ReclaimerSurvivor" }, states = { { "ReclaimerPrimary3", "ReclaimerSurvivor" } },
      tracers = { "SNIPER1" }, shot = "enter", aim = "host" },

    { key = "rexZ", package = "syntaxevasion-RiskOfRexReturns", kind = "gunner",
      skill = { "rexZ", "rex" }, states = { { "rexPrimary", "rex" } },
      shot = "enter", aim = "custom", adapter = "rex" },

    { key = "zerimpZ", package = "ANXvariable-Zerimp_Returns", kind = "gunner",
      skill = { "zerimpZ", "zerimp" }, states = { { "zerimpZ", "zerimp" } },
      shot = "enter", aim = "custom", adapter = "zerimp" },

    { key = "hunterZ", package = "ANXvariable-Hunter", kind = "gunner",
      skill = { "hunterZ", "hunter" }, states = { { "hunterZ", "hunter" } },
      shot = "custom", aim = "custom", adapter = "hunter" },

    { key = "technicianZ2", package = "RobomandosLab-StarstormReturns", kind = "gunner",
      skill = { "technicianZ2", "ssr" }, states = { { "technicianPrimaryAlt", "ssr" } },
      shot = "enter", aim = "custom", adapter = "technician", absent = "Starstorm beta off" },

    { key = "WispZ", package = "Neorit-LoseHumanity", kind = "gunner",
      skill = { "WispZ", "SmoothSpatula" }, activity = 1, late = true },
    { key = "GreaterWispZ", package = "Neorit-LoseHumanity", kind = "gunner",
      skill = { "GreaterWispZ", "SmoothSpatula" }, activity = 1, tracers = { "WISPG" }, late = true },
    { key = "ArchaicWispZ", package = "Neorit-LoseHumanity", kind = "gunner",
      skill = { "ArchaicWispZ", "SmoothSpatula" }, activity = 1, tracers = { "WISPG2" }, late = true },
    { key = "NautilusZ", package = "Neorit-LoseHumanity", kind = "gunner",
      skill = { "NautilusZ", "Neorit" }, activity = 1, late = true },
    { key = "ScavengerZ", package = "Neorit-LoseHumanity", kind = "gunner",
      skill = { "ScavengerZ", "Neorit" }, activity = 2, late = true },

    { key = "captainZ", package = "CoolLoaders_Inc-CaptainReturns", kind = "gunner",
      skill = { "captainZ", "CaptainReturns" }, states = { { "vulcanShotgun", "CaptainReturns" } },
      tracers = { "BANDIT3_R" }, shot = "custom", aim = "host", adapter = "captain" },

    { key = "muleZ", package = "RobomandosLab-StarstormReturns", kind = "melee",
      skill = { "muleZ", "ssr" }, states = { { "mulePrimaryPunch", "ssr" }, { "mulePrimarySlam", "ssr" } },
      sparks = "sSparks7", adapter = "mule" },

    { key = "nemesisCommandoZ", package = "RobomandosLab-StarstormReturns", kind = "melee",
      skill = { "nemesisCommandoZ", "ssr" }, states = { { "nemCommandoPrimary", "ssr" } },
      strike = "attack", host = true, sparks = "sSparks9" },

    { key = "fishmongerZ", package = "SmoothSpatula-Fishmonger", kind = "melee",
      skill = { "fishmongerZ", "fishmonger" },
      states = { { "fishmongerZA", "fishmonger" }, { "fishmongerZB", "fishmonger" } },
      host = true, sparks = "sSparks7" },

    { key = "GinZ", package = "cginc-GinMod", kind = "melee",
      skill = { "GinZ", "Gin" }, states = { { "GinZ", "Gin" } },
      sparks = "sSparks7" },

    { key = "LemurianZ", package = "Neorit-LoseHumanity", kind = "melee",
      skill = { "LemurianZ", "SmoothSpatula" }, states = { { "lemurianZ", "ror" }, { "lemurianZClimb", "ror" } },
      strike = "attack", host = true, sparks = "sSparks7", late = true },
    { key = "ElderLemurianZ", package = "Neorit-LoseHumanity", kind = "melee",
      skill = { "ElderLemurianZ", "Neorit" }, activity = 1,
      strike = "attack", gap = 60, host = true, sparks = "sSparks7", late = true },
    { key = "GolemZ", package = "Neorit-LoseHumanity", kind = "melee",
      skill = { "GolemZ", "SmoothSpatula" }, activity = 1,
      strike = "attack", host = true, sparks = "sSparks7", late = true },
    { key = "ParentZ", package = "Neorit-LoseHumanity", kind = "melee",
      skill = { "ParentZ", "SmoothSpatula" }, activity = 1,
      strike = "attack", host = true, sparks = "sSparks7", late = true },
    { key = "MacrobicPredatorZ", package = "Neorit-LoseHumanity", kind = "melee",
      skill = { "MacrobicPredatorZ", "Neorit" },
      states = { { "monsterMacropredZ", "ror" }, { "monsterMacropredZUp", "ror" }, { "monsterMacropredZDown", "ror" } },
      strike = "attack", host = true, sparks = "sSparks7", late = true },
    { key = "TardigradeZ", package = "Neorit-LoseHumanity", kind = "melee",
      skill = { "TardigradeZ", "Neorit" }, states = { { "monsterTardigradeZ", "ror" } },
      strike = "attack", host = true, sparks = "sSparks7", late = true },

    { key = "AdmiralZ", package = "GIC-Worlds_Incursion", kind = "gunner",
      skill = { "AdmiralZ", "Worlds Collide" }, states = { { "admiralPrimary", "Worlds Collide" } },
      tracers = { "BANDIT1" } },
    { key = "admiralZ2", package = "GIC-Worlds_Incursion", kind = "gunner",
      skill = { "admiralZ2", "Worlds Collide" }, states = { { "admiralPrimary2", "Worlds Collide" } },
      tracers = { "COMMANDO2" } },

    { key = "helperZ", package = "GIC-Worlds_Incursion", kind = "gunner",
      skill = { "helperZ", "Worlds Collide" }, states = { { "helperPrimary", "Worlds Collide" } },
      tracers = { "COMMANDO1" }, shot = "enter", aim = "host" },

    { key = "helperZ2", package = "GIC-Worlds_Incursion", kind = "gunner",
      skill = { "helperZ2", "Worlds Collide" }, states = { { "helperPrimary2", "Worlds Collide" } },
      shot = "enter", aim = "none" },

    { key = "worldsReclaimerZ", package = "GIC-Worlds_Incursion", kind = "gunner",
      skill = { "reclaimerZ", "Worlds Collide" }, states = { { "ReclaimerPrimary", "Worlds Collide" } },
      tracers = { "SNIPER2" } },
    { key = "worldsReclaimerZ2", package = "GIC-Worlds_Incursion", kind = "gunner",
      skill = { "reclaimerZ2", "Worlds Collide" }, states = { { "ReclaimerPrimary2", "Worlds Collide" } },
      tracers = { "COMMANDO1" } },
    { key = "worldsReclaimerZ3", package = "GIC-Worlds_Incursion", kind = "gunner",
      skill = { "reclaimerZ3", "Worlds Collide" }, states = { { "ReclaimerPrimary3", "Worlds Collide" } },
      tracers = { "SNIPER1" }, shot = "enter", aim = "host" },

    { key = "Blast", package = "GIC-Worlds_Incursion", kind = "gunner",
      skill = { "Blast", "Worlds Collide" }, states = { { "Blast", "Worlds Collide" } },
      tracers = { "BANDIT1" }, shot = "enter", aim = "host" },
    { key = "Slug", package = "GIC-Worlds_Incursion", kind = "gunner",
      skill = { "Slug", "Worlds Collide" }, states = { { "Slug", "Worlds Collide" } },
      tracers = { "BANDIT3", "PILOT_PRIMARY_STRONG", "BANDIT1" } },
    { key = "Shotty", package = "GIC-Worlds_Incursion", kind = "gunner",
      skill = { "Shotty", "Worlds Collide" }, states = { { "Shotty", "Worlds Collide" } },
      tracers = { "BANDIT1" }, shot = "enter", aim = "host" },

    { key = "Bang", package = "GIC-Worlds_Incursion", kind = "gunner",
      skill = { "Bang", "Worlds Collide" }, states = { { "Bang", "Worlds Collide" } },
      tracers = { "SNIPER2" } },

    { key = "BitwarriorZ", package = "GIC-Worlds_Incursion", kind = "melee",
      skill = { "BitwarriorZ", "Worlds Collide" },
      states = { { "bitwarriorPrimary", "Worlds Collide" }, { "bitwarriorSwing2", "Worlds Collide" },
                 { "bitwarriorSwing3", "Worlds Collide" } },
      sparks = "sSparks2" },
}

PSEM.Roster = R
