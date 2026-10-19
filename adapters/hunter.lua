-- Hunter, Power Beam: лучи летят к курсору, патроны считает переходник — заряженный луч стоит дороже.

PSEM = PSEM or {}

local C = PSEM.Config
local P = PSEM.Projectiles

local NS = "PSEModdedSurvivors"
local HUNTER_NS = "hunter"

local RADIUS = 24

PSEM.Adapters.hunter = {
    objects = { beam = { "hunter_beam", HUNTER_NS } },

    setup = function(api, found)
        local state = found.states[1]
        local beam  = found.objects.beam

        local function counted(actor)
            return Instance.get_data(actor, "hunter", NS)
        end

        Callback.add(state.on_enter, function(actor, _)
            counted(actor).fired = 0
        end)

        Callback.add(state.on_step, Callback.Priority.AFTER, function(actor, data)
            if not P.has_primary(actor, found.skill) then return end

            local seen  = counted(actor)
            local fired = data.fired or 0
            while (seen.fired or 0) < fired do
                seen.fired = (seen.fired or 0) + 1
                local charged = seen.fired == 2
                    and Instance.get_data(actor, "__main", HUNTER_NS).beamcharged == 1
                api.spend(actor, charged and C.hunter_charged or 1)
            end

            local facing = actor.image_xscale >= 0 and 1 or -1
            for _, inst in ipairs(P.claim(beam, actor.x + 5 * facing, actor.y - 10, RADIUS)) do
                local own   = Instance.get_data(inst, "__main", HUNTER_NS)
                local speed = math.abs(own.horizontal_velocity or 0)
                local side  = (own.horizontal_velocity or 0) >= 0 and 0 or 180
                local direction = api.aim(actor, inst.x, inst.y, side)
                if direction and speed > 0 then
                    own.horizontal_velocity = speed * math.cos(math.rad(direction))
                    Instance.get_data(inst, "beam", NS).vertical = -speed * math.sin(math.rad(direction))
                    inst.image_angle = gm.angle_difference(direction, side)
                end
            end
        end)

        Callback.add(beam.on_step, Callback.Priority.BEFORE, function(inst)
            if not Instance.exists(inst) then return end
            local vertical = Instance.get_data(inst, "beam", NS).vertical
            if vertical then inst.y = inst.y + vertical end
        end)
    end,
}
