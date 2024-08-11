---@diagnostic disable: param-type-mismatch
local function set_module_state(mod, state)
    if module_manager.is_module_on(mod) ~= state then
        player.message("." .. mod)
    end
end

local function is_holding_sword()
    return player.held_item() and (string.match(player.held_item(), 'Sword') or string.match(player.held_item(), 'Spireblade'))
end

local packets = {}
local flag

local function release_packets() -- for releasing all the blinked packets
    for i = 1, #packets do
        local packet = packets[i]
        local id, fields = packet[1], packet[2]
        if id == 0x0F then
            player.send_packet(0x0F, 0, fields[1], true)

        elseif id == 0x00 then
            player.send_packet(0x00, fields[1])

        elseif id == 0x07 then
            player.send_packet(0x07)

        elseif id == 0x08 then
            player.send_packet(0x08)

        elseif id == 0x09 then
            player.send_packet(0x09, fields[1])

        elseif id == "Attack" then
            player.swing_item()
            player.send_packet(0x02, fields[1], 2)

        elseif id == "Interact" then
            player.send_packet(0x02, fields[1], 3, {world.position(fields[1])}) 
            player.send_packet(0x02, fields[1], 1)

        elseif id == 0x04 and not flag then
            local packet_x, packet_y, packet_z, packet_ground = fields[1],fields[2],fields[3],fields[4]
            player.send_packet(0x04, packet_x,packet_y,packet_z, packet_ground)
        end
    end
    packets = {}
    flag = false
end

local ticks = 0
local unblock = 0

local prevAngle
local rots = {}

local function wrapAngleTo180(value)
    value = value % 360.0
    if (value >= 180.0) then
        value = value - 360.0
    end
    if (value < -180.0) then
        value = value + 360.0
    end
    return value
end
--><
local function EnemyTarget() -- finds the closest entity to you thats a player
    local entities = world.entities()
    local target = nil
    for i = 1, #entities do
        --if entities[i] ~= player.id() and (world.is_player(entities[i]) or world.is_bot(entities[i])) then
        if entities[i] ~= player.id() and world.is_player(entities[i]) then
            if target == nil then
                target = entities[i]
            else
                if player.distance_to_entity(entities[i]) < player.distance_to_entity(target) then
                    target = entities[i]
                end
            end
        end
    end
    return target
end

local function targetting() -- checks if the enemy is in distance to be attacked
    world.entities()
    local exists = world.name(EnemyTarget())
    if exists then
        if EnemyTarget() ~= nil and is_holding_sword() then
            if player.distance_to_entity(EnemyTarget()) <= module_manager.option('SilentAura', "Block-Range") then
                if not (module_manager.is_module_on("Bridger") or module_manager.is_module_on("Blink") or module_manager.is_module_on("BedAura")) then
                    return true
                else
                    return false
                end
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

local blinking
local x,y,z

module_manager.register('SilentAura', {
    on_enable = function(t)
        set_module_state("killaura",true) -- for animations
        flag = false
        prevAngle = 0
    end,
    on_disable = function(t)
        set_module_state("killaura",false) -- for animations
        if module_manager.option('SilentAura', "Auto-Block") then 
            release_packets()
            player.send_packet_no_event(0x07)
            player.set_held_item_slot(player.held_item_slot() - 2)
            blinking = false
        end
    end,
    
    on_pre_update = function(t)
        player.message(".killaura block-range "..tostring(module_manager.option('SilentAura', "Block-Range")))
        world.entities()
        if not targetting() then
            EnemyTarget()
        end
        if module_manager.option('SilentAura', "Auto-Block") then -- ab from frog
            if targetting() then
                if is_holding_sword() then

                    ticks = ticks + 1
                    local exists = world.name(EnemyTarget())

                    if ticks == 1 then
                        blinking = false
                        release_packets()
                        if exists and player.distance_to_entity(EnemyTarget()) <= module_manager.option('SilentAura', "Attack-Range")  then
                            player.swing_item()
                            player.send_packet(0x02, EnemyTarget(), 2)
                        end
                        player.send_packet(0x02, EnemyTarget(), 1)
                        player.send_packet(0x08)
                    elseif ticks == 2 then
                        blinking = true
                        player.send_packet(0x07)
                        ticks = 0
                    end
                    unblock = 0
                else
                    ticks = 0
                    blinking = false
                    release_packets()
                end
            else
                ticks = 0
                unblock = unblock + 1
                if unblock == 2 then
                    player.send_packet(0x07)
                    blinking = false
                    player.set_held_item_slot(player.held_item_slot() - 2)
                    release_packets()
                end
            end
        elseif targetting() then
            if math.random() > 0.4 then
                if player.distance_to_entity(EnemyTarget()) <= module_manager.option('SilentAura', "Attack-Range") then
                    player.swing_item()
                    player.send_packet(0x02, EnemyTarget(), 2)
                end
            end
        end
    end,

    on_pre_motion = function(t)
        world.entities()
        x,y,z = t.x,t.y,t.z
        if module_manager.option('SilentAura', "Rotations") then -- tweaked from a custom rotation script (dont know the original creator)
            local exists = world.name(EnemyTarget())
            if exists and targetting() and player.distance_to_entity(EnemyTarget()) <= module_manager.option('SilentAura', "Rotation-Range") then
                world.entities()
                local width, height = world.width_height(EnemyTarget())
                local x, y, z = world.position(EnemyTarget())
                local diff = { x - t.x,
                y - t.y + (math.random() * (0 * 0.01)) 
                            -- ^ alan wood bypass $$$
                - 0.11, z - t.z }
                local angle = math.deg(math.atan(diff[3], diff[1]))
                local yaw = angle - 90.0
                local pitch = -math.deg(math.atan(diff[2], player.distance_to_entity(EnemyTarget())))
                local cYaw = player.angles()
                if math.abs(angle - prevAngle) > 1 then -- how much the yaw needs to change to rotate again
                    rots[1] = cYaw + wrapAngleTo180(yaw - cYaw)
                    prevAngle = angle
                end
                rots[2] = wrapAngleTo180(pitch)
                t.yaw = rots[1]
                t.pitch = rots[2]    
            end
        end
        return t
    end,

    on_receive_packet = function(t) -- flag check when blinking
        if t.packet_id == 0x08 then
            blinking = false
            flag = true
            release_packets()
        end
    end,

    on_send_packet = function(t) -- blink for ab
        if blinking then
            if t.packet_id == 0x0F then
                table.insert(packets, {0x0F, {t.uid}})
                t.cancel = true
            elseif t.packet_id >= 3 and t.packet_id <= 6 then
                table.insert(packets, {0x04, {x, y, z, player.on_ground()}})
                t.cancel = true
            elseif true then
                t.cancel = true
            end
        end

        return t
    end
})
module_manager.register_boolean('SilentAura', "Rotations",true)
module_manager.register_boolean('SilentAura', "Auto-Block",true)
module_manager.register_number('SilentAura', "Attack-Range", 3.01, 6.01, 3.15)
module_manager.register_number('SilentAura', "Rotation-Range", 3.01, 8.01, 6.01)
module_manager.register_number('SilentAura', "Block-Range", 3.01, 12.01, 10.01)