-- Technician, Troubleshoot: брошенный ключ летит к курсору. Патрон — бросок.

PSEM = PSEM or {}

local P = PSEM.Projectiles

local RADIUS = 24

PSEM.Adapters.technician = {
    objects = { wrench = { "wrench", "ssr" } },

    setup = function(api, found)
        local state  = found.states[1]
        local wrench = found.objects.wrench

        Callback.add(state.on_step, Callback.Priority.AFTER, function(actor, _)
            if not P.has_primary(actor, found.skill) then return end
            for _, inst in ipairs(P.claim(wrench, actor.x + 6 * actor.image_xscale, actor.y - 4, RADIUS, actor.team)) do
                local side = inst.speed >= 0 and P.side(inst.direction) or P.side(inst.direction + 180)
                local direction = api.aim(actor, inst.x, inst.y, side)
                if direction then
                    if inst.speed < 0 then inst.image_xscale = -inst.image_xscale end
                    inst.speed     = math.abs(inst.speed)
                    inst.direction = direction
                end
            end
        end)
    end,
}
