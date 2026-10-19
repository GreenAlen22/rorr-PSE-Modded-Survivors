-- Общее для переходников: найти свежие снаряды чужого мода у точки рождения и повернуть их к курсору.

PSEM = PSEM or {}

PSEM.Adapters = PSEM.Adapters or {}

local NS = "PSEModdedSurvivors"

local P = {}

function P.claim(object, x, y, radius, team)
    local claimed = {}
    for _, inst in ipairs(Instance.find_all(object)) do
        local mark = Instance.get_data(inst, "taken", NS)
        if not mark.on and (team == nil or inst.team == team)
            and gm.point_distance(inst.x, inst.y, x, y) <= radius then
            mark.on = true
            claimed[#claimed + 1] = inst
        end
    end
    return claimed
end

function P.side(direction)
    return math.cos(math.rad(direction)) >= 0 and 0 or 180
end

function P.turn(inst, direction, side)
    inst.direction   = direction
    inst.image_angle = gm.angle_difference(direction, side)
end

function P.has_primary(actor, skill)
    return actor:get_default_skill(Skill.Slot.PRIMARY).skill_id == skill.value
end

PSEM.Projectiles = P
