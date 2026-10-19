-- REX, INJECT: залп шприцев летит к курсору. Патрон — залп.

PSEM = PSEM or {}

local P = PSEM.Projectiles

local RADIUS = 160

PSEM.Adapters.rex = {
    objects = { syringe = { "rexSyringe", "rex" }, broken = { "rexSyringeBreak", "rex" } },

    setup = function(api, found)
        local state   = found.states[1]
        local objects = { found.objects.syringe, found.objects.broken }

        Callback.add(state.on_step, Callback.Priority.AFTER, function(actor, _)
            if not P.has_primary(actor, found.skill) then return end
            for _, object in ipairs(objects) do
                for _, syringe in ipairs(P.claim(object, actor.x, actor.y - 6, RADIUS)) do
                    local side = P.side(syringe.direction)
                    local direction = api.aim(actor, syringe.x, syringe.y, side)
                    if direction then P.turn(syringe, direction, side) end
                end
            end
        end)
    end,
}
