-- Консольные команды аддона: состояние загрузки, открытие поддержанных выживших для прогона и временный замер хуков.

PSEM = PSEM or {}

local function say(msg)
    Console.print("[psems] "..msg)
end

local function local_player()
    local p = Player.get_local()
    if not Instance.exists(p) or p.object_index ~= gm.constants.oP then
        say("no local player - start a run first")
        return nil
    end
    return p
end

local function pse_api_version()
    local pse = mods["GreenAlen22-PrimarySkillEvolution"]
    if not pse then return nil, "Primary Skill Evolution not loaded" end
    local ok, version = pcall(function() return pse.api.version end)
    if not ok then return nil, "no API - "..tostring(version) end
    return version
end

Console.new{
    "psems_status",
    {
        "Prints whether PSE: Modded Survivors loaded in full, which Primary Skill Evolution API it found and what became of each modded primary.",
    },
    function(args)
        local boot = PSEM.Boot
        if boot then
            say(string.format("modules %d/%d, missing: %s", boot.loaded, boot.total, boot.missing))
        else
            say("no boot report - main.lua did not reach the end of loading")
        end

        local version, why = pse_api_version()
        say(version and "PSE API: version "..tostring(version) or "PSE API: missing ("..why..")")

        local register = PSEM.Register
        if not register then
            say("no registration report - core/register.lua did not load (see the log)")
            return
        end
        for _, s in ipairs(register.status) do
            say(string.format("%s (%s, %s): %s", s.key, s.kind, s.package, s.state))
        end
    end
}

local probe = nil
local probe_fns = nil

local function arm(on)
    for _, f in ipairs(probe_fns) do f:toggle(on) end
end

local function hero_of(v)
    if v == nil or not Instance.exists(v) then return nil end
    return Instance.wrap(v)
end

local function state_name(id)
    if id == -1 then return "no state" end
    local ok, state = pcall(ActorState.wrap, id)
    if not ok or not state then return "state "..tostring(id) end
    return state.namespace.."-"..state.identifier
end

local function states_line(counts)
    local parts = {}
    for id, n in pairs(counts) do parts[#parts + 1] = state_name(id).." x"..n end
    return #parts > 0 and table.concat(parts, ", ") or "-"
end

local function finish_probe(reason)
    local pr = probe
    if not pr or not probe_fns then error("luahook: finished with no measurement running") end
    probe = nil
    arm(false)

    local function out(s)
        say(s)
        log.info("[psems] "..s)
    end

    out(string.format("luahook: %s, %s, %.0f s%s", pr.hero, pr.primary, pr.frames / PSEM.Config.fps,
        reason and " - "..reason or ""))
    out(string.format("heaven cracker: called %d times (z_count), hook saw %d (self = hero %d, args[1] = hero %d, unreadable args[1] %d)",
        pr.truth, pr.hc_mine, pr.hc_self, pr.hc_arg, pr.hc_unreadable))
    out(string.format("fire_bullet from the hero: %d (%s), with an empty self: %d",
        pr.fb, states_line(pr.fb_states), pr.fb_noself))
    out(string.format("fire_explosion from the hero: %d, in the frame of its Heaven Cracker call %d (%s)",
        pr.fe, pr.fe_paired, states_line(pr.fe_states)))

    if pr.truth == 0 then
        out("VERDICT: nothing to judge - the hero made no Heaven Cracker call. Attack with the primary for the whole window; "
            .."a hero that never calls it (Nemesis Commando, mods without API) cannot answer this.")
    elseif pr.hc_mine == 0 then
        out("VERDICT: the hook does NOT see this hero's Heaven Cracker calls. Melee strikes of modded heroes "
            .."have to be told by the primary's state, not by this call.")
    elseif pr.hc_mine < pr.truth then
        out(string.format("VERDICT: the hook saw %d of %d calls - some reach it, some do not. Send the log.",
            pr.hc_mine, pr.truth))
    elseif pr.hc_self >= pr.truth then
        out("VERDICT: the hook sees the calls, self is the hero - PSE's strike check works for this call (actor:...).")
    elseif pr.hc_arg >= pr.truth then
        out("VERDICT: the hook sees the calls, but self is empty and the hero is args[1] - PSE's strike check has to "
            .."take the hero from args[1] (GM.... call).")
    else
        out("VERDICT: the hook sees the calls, the hero comes now as self, now as args[1] - PSE's strike check has to read both.")
    end

    if pr.fb > 0 then
        out("VERDICT: fire_bullet from this hero reaches the hook with self = the hero - the magazine and the aim can see its shots.")
    elseif pr.fb_noself > 0 then
        out("VERDICT: fire_bullet reached the hook, but with an empty self - the magazine and the aim would have to find "
            .."the shooter another way. Send the log.")
    else
        out("fire_bullet: none from this hero - expected for a melee hero; for a gunner (Reclaimer) this means the hook misses its shots.")
    end
end

Console.new{
    "psems_luahook [seconds]",
    {
        "TEMPORARY. For the given seconds (10 by default) counts the local hero's Heaven Cracker calls, fire_bullet and "
        .."fire_explosion as mod hooks see them, against the game's own count, then says whether the hooks "
        .."see calls a modded hero makes from Lua.",
        {"[seconds]", "number", "How long to measure, 3 to 60."},
    },
    function(args)
        local p = local_player()
        if not p then return end
        if probe then
            say(string.format("already measuring, %.0f s left", probe.left / PSEM.Config.fps))
            return
        end

        local cracker = Item.find("heavenCracker", "ror")
        if not cracker then error("vanilla item ror-heavenCracker not found") end
        if p:item_count(cracker) > 0 then
            say("refused: Heaven Cracker zeroes z_count, the count this measures against - drop it or start a run without it")
            return
        end

        local seconds = math.max(3, math.min(60, math.floor(tonumber(args[1]) or 10)))
        local skill = Skill.wrap(p:get_default_skill(Skill.Slot.PRIMARY).skill_id)
        local hero = Survivor.wrap(p.class)
        probe = {
            player = p.id, last_z = tonumber(p.z_count) or 0, left = seconds * PSEM.Config.fps, frames = 0,
            hero = hero.namespace.."-"..hero.identifier,
            primary = skill.namespace.."-"..skill.identifier,
            truth = 0, hc_mine = 0, hc_self = 0, hc_arg = 0, hc_unreadable = 0, hc_frame = -1,
            fb = 0, fb_noself = 0, fb_states = {}, fe = 0, fe_paired = 0, fe_states = {},
        }

        if not probe_fns then
            probe_fns = {}

            probe_fns[#probe_fns + 1] = Hook.add_post(gm.constants.skill_util_update_heaven_cracker, function(self, other, result, hook_args)
                local pr = probe
                if not pr then return end
                local by_self = self ~= nil and self.id == pr.player
                local ok, arg = pcall(hero_of, hook_args[1] and hook_args[1].value)
                if not ok then pr.hc_unreadable = pr.hc_unreadable + 1 end
                local by_arg = ok and arg ~= nil and arg.id == pr.player
                if by_self then pr.hc_self = pr.hc_self + 1 end
                if by_arg then pr.hc_arg = pr.hc_arg + 1 end
                if by_self or by_arg then
                    pr.hc_mine = pr.hc_mine + 1
                    pr.hc_frame = Global._current_frame
                end
            end)

            probe_fns[#probe_fns + 1] = Hook.add_post(gm.constants.fire_bullet, function(self, other, result, hook_args)
                local pr = probe
                if not pr then return end
                if self == nil then
                    pr.fb_noself = pr.fb_noself + 1
                    return
                end
                if self.id ~= pr.player then return end
                pr.fb = pr.fb + 1
                local s = self.actor_state_current_id
                pr.fb_states[s] = (pr.fb_states[s] or 0) + 1
            end)

            probe_fns[#probe_fns + 1] = Hook.add_post(gm.constants.fire_explosion, function(self, other, result, hook_args)
                local pr = probe
                if not pr or self == nil or self.id ~= pr.player then return end
                pr.fe = pr.fe + 1
                if Global._current_frame == pr.hc_frame then pr.fe_paired = pr.fe_paired + 1 end
                local s = self.actor_state_current_id
                pr.fe_states[s] = (pr.fe_states[s] or 0) + 1
            end)

            probe_fns[#probe_fns + 1] = Callback.add(Callback.ON_STEP, function()
                local pr = probe
                if not pr then return end
                if not Instance.exists(pr.player) then
                    finish_probe("aborted: the hero is gone")
                    return
                end
                local z = tonumber(Instance.wrap(pr.player).z_count) or 0
                if z > pr.last_z then pr.truth = pr.truth + (z - pr.last_z) end
                pr.last_z = z
                pr.frames = pr.frames + 1
                pr.left = pr.left - 1
                if pr.left <= 0 then finish_probe(nil) end
            end)
        end
        arm(true)

        say(string.format("measuring %d s: %s, primary %s - attack with the primary now", seconds, probe.hero, probe.primary))
    end
}

local function unlock(id, opened)
    if id == nil or id < 0 or opened[id] then return end
    opened[id] = true
    local achievement = Achievement.wrap(id)
    unlock(achievement.parent_id, opened)
    if not Util.bool(achievement:is_unlocked()) then
        gm.achievement_add_progress(id, achievement.progress_needed, true)
        say("unlocked "..achievement.namespace.."-"..achievement.identifier)
    end
end

Console.new{
    "psems_unlock",
    {
        "Opens the survivors and primaries this mod supports from one package, in this save. Offline only.",
        "psems_unlock <package>, as psems_status prints it",
    },
    function(args)
        local package = args[1]
        if not package then
            say("name the package, as psems_status prints it")
            return
        end
        if Net.online then
            say("offline only: online the game would tell the other players of each unlock")
            return
        end

        local skills = {}
        for _, fact in ipairs(PSEM.Roster.ATTACKS) do
            if fact.package == package then
                local skill = Skill.find(fact.skill[1], fact.skill[2])
                if skill then skills[skill.value] = true end
            end
        end
        if next(skills) == nil then
            say("no primary of "..package.." found - not installed, or not made yet")
            return
        end

        local opened = {}
        for _, survivor in ipairs(Survivor.find_all()) do
            for _, skill in ipairs(survivor:get_skills(Skill.Slot.PRIMARY)) do
                if skills[skill.value] then unlock(survivor.achievement_id, opened) end
            end
        end
        for _, unlockable in ipairs(Global.survivor_loadout_unlockables) do
            if skills[unlockable.skill_id] then unlock(unlockable.achievement_id, opened) end
        end
        say("done - pick them in the character select")
    end
}

PSEM.Debug = true
