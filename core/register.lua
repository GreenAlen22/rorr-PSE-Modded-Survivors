-- Передаёт основные атаки установленных модов в API PSE. Что не нашлось — пропускается с записью в лог.

PSEM = PSEM or {}

local C        = PSEM.Config
local R        = PSEM.Roster
local Adapters = PSEM.Adapters

local G = {
    status = {},
}

local PSE_PACKAGE = "GreenAlen22-PrimarySkillEvolution"
local API_VERSION = 2

local TABLES = { gunner = C.gunners, melee = C.melee }
for _, fact in ipairs(R.ATTACKS) do
    local numbers = TABLES[fact.kind]
    if not numbers then error("fact "..fact.key..": kind must be gunner or melee, got "..tostring(fact.kind)) end
    if not numbers[fact.key] then error("no "..fact.kind.." numbers for "..fact.key.." in core/config.lua") end
    if fact.adapter and not Adapters[fact.adapter] then error("fact "..fact.key..": no adapter "..fact.adapter.." in adapters/") end
end

local function failed(fact, why)
    log.warning("PSE Modded Survivors: "..fact.key.." ("..fact.package..") left out - "..why)
    return "FAILED: "..why
end

local function name_of(pair)
    return pair[2].."-"..pair[1]
end

local function find_api()
    local pse = mods[PSE_PACKAGE]
    if not pse then return nil, "Primary Skill Evolution not loaded" end
    local ok, api = pcall(function()
        local a = pse.api
        return a.version == API_VERSION and a or nil
    end)
    if not ok then return nil, "Primary Skill Evolution has no API - "..tostring(api) end
    if not api then return nil, "Primary Skill Evolution API is not version "..API_VERSION end
    return api
end

local function def_of(fact, found)
    local def = {
        name     = fact.key,
        states   = #found.states > 0 and found.states or nil,
        activity = fact.activity,
    }
    if fact.kind == "gunner" then
        local n = C.gunners[fact.key]
        def.shot, def.aim, def.cut = fact.shot, fact.aim, fact.cut
        def.tracers, def.magazine, def.reload, def.cone = found.tracers, n.magazine, n.reload, n.cone
    else
        def.strike, def.gap, def.host = fact.strike, fact.gap, fact.host
        def.stamina, def.finisher, def.sparks = C.melee[fact.key], C.finisher[fact.key], found.sparks
    end
    return def
end

local function find(fact)
    local skill = Skill.find(fact.skill[1], fact.skill[2])
    if not skill then return nil, "skill "..name_of(fact.skill).." not found", true end

    local found = { skill = skill, states = {}, tracers = {} }
    for _, pair in ipairs(fact.states or {}) do
        local state = ActorState.find(pair[1], pair[2])
        if not state then return nil, "state "..name_of(pair).." not found" end
        found.states[#found.states + 1] = state
    end
    for _, t in ipairs(fact.tracers or {}) do
        local id = Tracer[t]
        if not id then return nil, "tracer "..t.." not found" end
        found.tracers[#found.tracers + 1] = id
    end
    if fact.sparks then
        found.sparks = gm.constants[fact.sparks]
        if not found.sparks then return nil, "sprite "..fact.sparks.." not found" end
    end
    local adapter = fact.adapter and Adapters[fact.adapter] or {}
    found.objects = {}
    for key, pair in pairs(adapter.objects or {}) do
        found.objects[key] = Object.find(pair[1], pair[2])
        if not found.objects[key] then return nil, "object "..name_of(pair).." not found" end
    end
    found.adapter_states = {}
    for key, pair in pairs(adapter.states or {}) do
        found.adapter_states[key] = ActorState.find(pair[1], pair[2])
        if not found.adapter_states[key] then return nil, "state "..name_of(pair).." not found" end
    end
    return found
end

local function register(api, fact, first_run)
    if mods[fact.package] == nil then return "not installed" end
    if fact.unless and mods[fact.unless] ~= nil then
        return "skipped: "..fact.unless.." shares the skill"
    end

    local found, why, missing_skill = find(fact)
    if not found then
        if missing_skill and fact.late and not first_run then return "waiting for the first run" end
        if missing_skill and fact.absent then return "skipped: "..fact.absent end
        return failed(fact, why)
    end

    local fn = fact.kind == "melee" and api.melee or api.gunner
    local ok, err = pcall(fn, found.skill, def_of(fact, found))
    if not ok then return failed(fact, tostring(err)) end
    if fact.adapter then
        local ok, err = pcall(Adapters[fact.adapter].setup, api, found)
        if not ok then return failed(fact, "adapter "..fact.adapter.." - "..tostring(err)) end
    end
    return "registered"
end

local api, why = find_api()
if not api then log.warning("PSE Modded Survivors: nothing registered - "..why) end

local function report()
    local registered, waiting = 0, 0
    for _, s in ipairs(G.status) do
        if s.state == "registered" then registered = registered + 1 end
        if s.state == "waiting for the first run" then waiting = waiting + 1 end
    end
    log.info("PSE Modded Survivors: registered "..registered.." of "..#G.status.." primaries"
        ..(waiting > 0 and ", "..waiting.." waiting for the first run" or ""))
end

for _, fact in ipairs(R.ATTACKS) do
    local state = api and register(api, fact, false) or "FAILED: "..why
    G.status[#G.status + 1] = { key = fact.key, package = fact.package, kind = fact.kind, state = state, fact = fact }
end
report()

local retried = false
Callback.add(Callback.ON_GAME_START, function()
    if retried or not api then return end
    retried = true
    for _, s in ipairs(G.status) do
        if s.state == "waiting for the first run" then s.state = register(api, s.fact, true) end
    end
    report()
end)

PSEM.Register = G
