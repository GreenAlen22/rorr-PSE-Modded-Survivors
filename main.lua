-- PSE: Modded Survivors — механики Primary Skill Evolution для выживших из других модов.
-- Загрузчик: модули грузятся строго по списку, после инициализации всех модов.
-- В конце проверяется, что каждый модуль завёл свою ветку в PSEM.

mods["ReturnsAPI-ReturnsAPI"].auto{
    namespace = "PSEModdedSurvivors",
    mp        = true,
}

local PATH = _ENV["!plugins_mod_folder_path"].."\\"

local modules = {
    "core/config",
    "core/roster",
    "adapters/projectiles",
    "adapters/rex",
    "adapters/zerimp",
    "adapters/hunter",
    "adapters/technician",
    "adapters/captain",
    "adapters/mule",
    "core/register",
    "settings/debug",
}

local function load(name)
    local file = (PATH..name..".lua"):gsub("/", "\\")

    local f = io.open(file, "r")
    if not f then
        log.warning("PSE Modded Survivors: file not found -> "..file)
        return false
    end
    f:close()

    local ok, err = pcall(function() require(file) end)
    if not ok then
        log.warning("PSE Modded Survivors: FAILED to load "..name.." -> "..tostring(err))
        return false
    end
    return true
end

local expected = {
    "Config", "Roster", "Projectiles", "Adapters", "Register", "Debug",
}

Initialize.add_hotloadable(Callback.Priority.AFTER, function()
    PSEM = PSEM or {}

    local loaded = 0
    for _, name in ipairs(modules) do
        if load(name) then loaded = loaded + 1 end
    end

    local missing = {}
    for _, key in ipairs(expected) do
        if not PSEM[key] then missing[#missing + 1] = key end
    end

    PSEM.Boot = {
        loaded  = loaded,
        total   = #modules,
        missing = #missing > 0 and table.concat(missing, ", ") or "-",
    }

    if loaded == #modules and #missing == 0 then
        log.info("PSE Modded Survivors: initialized ("..loaded.."/"..#modules.." modules)")
    else
        log.warning("PSE Modded Survivors: initialized PARTIALLY ("..loaded.."/"..#modules
            .." modules; missing PSEM: "..PSEM.Boot.missing..")")
    end
end)
