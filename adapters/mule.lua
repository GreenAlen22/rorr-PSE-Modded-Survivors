-- MULE, Interference Removal: окно на заряде. Отпустил в окне — слэм, как при полном заряде; сами удары — запись ближника.

PSEM = PSEM or {}

local P = PSEM.Projectiles

local FULL = 5
local PACE = 0.06

PSEM.Adapters.mule = {
    states = { charge = { "mulePrimaryCharge", "ssr" } },

    setup = function(api, found)
        local state = found.adapter_states.charge

        Callback.add(state.on_step, Callback.Priority.BEFORE, function(actor, data)
            if not Util.bool(actor.is_local) or (data.fired or 0) >= 1 then return end
            if not P.has_primary(actor, found.skill) then return end

            api.charge(actor, actor.image_index2 / FULL, PACE / FULL)
            if Util.bool(actor.z_skill) then return end
            if api.charge_release(actor) then data.fired = 1 end
        end)
    end,
}
