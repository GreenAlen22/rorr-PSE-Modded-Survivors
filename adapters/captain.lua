-- Captain, Vulcan Shotgun: патрон на отпускании и окно на заряде. Отпустил в окне — залп как при полном заряде.

PSEM = PSEM or {}

local P = PSEM.Projectiles

local NS = "PSEModdedSurvivors"

local FULL = 72

PSEM.Adapters.captain = {
    setup = function(api, found)
        local state = found.states[1]

        local function paid(actor)
            return Instance.get_data(actor, "captain", NS)
        end

        Callback.add(state.on_enter, function(actor, _)
            paid(actor).on = false
        end)

        Callback.add(state.on_step, Callback.Priority.BEFORE, function(actor, data)
            if Net.client or not Util.bool(actor.is_local) or (data.fired or 0) >= 1 then return end
            if not P.has_primary(actor, found.skill) then return end

            local timer = data.chargetimer or FULL
            api.charge(actor, 1 - timer / FULL, 1 / FULL)
            if Util.bool(actor.z_skill) then return end
            if api.charge_release(actor) then data.chargetimer = 0 end
        end)

        Callback.add(state.on_step, Callback.Priority.AFTER, function(actor, data)
            if (data.fired or 0) < 1 or not P.has_primary(actor, found.skill) then return end
            local round = paid(actor)
            if round.on then return end
            round.on = true
            api.spend(actor)
        end)
    end,
}
