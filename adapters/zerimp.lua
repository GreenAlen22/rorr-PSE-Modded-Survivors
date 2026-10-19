-- Zerimp, Cut: пузырь летит к курсору. Патрон — выстрел.

PSEM = PSEM or {}

local P = PSEM.Projectiles

local RADIUS = 24

PSEM.Adapters.zerimp = {
    objects = { bubble = { "ZerimpBullet", "zerimp" } },

    setup = function(api, found)
        local state  = found.states[1]
        local bubble = found.objects.bubble

        Callback.add(state.on_step, Callback.Priority.AFTER, function(actor, _)
            if not P.has_primary(actor, found.skill) then return end
            for _, inst in ipairs(P.claim(bubble, actor.x + 6 * actor.image_xscale, actor.y, RADIUS)) do
                local side = P.side(inst.direction)
                local direction = api.aim(actor, inst.x, inst.y, side)
                if direction then P.turn(inst, direction, side) end
            end
        end)
    end,
}
