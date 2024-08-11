local name = "BlockFly"
local blockX, blockY, blockZ, blockFacing
local oldSlot
local swapdelay = 0
local startYLevel = 0

local sairticks = 0
local px,py,pz = 0, 0, 0
local i = 1
local rot2_Yaw, rot2_Pitch = 0, 0
local sstarted = 0
local rand = false
local tower = false
local on_gorunds = false

local space = 0
local extra
local swap

local offgroundticks = 0
local holdticks = 0

local starty = 0

local function set_module_state(mod, state)
    if module_manager.is_module_on(mod) ~= state then
        player.message("." .. mod)
    end
end

local directions = {
    { facing = 1, x = 0, y = -1, z = 0 },
    { facing = 2, x = 0, y = 1, z = 0 },
    { facing = 3, x = 0, y = 0, z = -1 },
    { facing = 4, x = 0, y = 0, z = 1 },
    { facing = 5, x = -1, y = 0, z = 0 },
    { facing = 6, x = 1, y = 0, z = 0 }
}

local function grabBlockSlot()
    local slot = -1
    local highestStack = -1
    for i = 1, 9 do
        local name = player.inventory.item_information(35 + i)
        local size = player.inventory.get_item_stack(35 + i)           
        if size ~= nil and name ~= nil and string.match(name, "tile") and size > 0 then
            if size > highestStack then
                highestStack = size 
                slot = i
            end
        end
    end
    return slot
end

local function offSetPos(x, y, z, facing) 
    if not module_manager.option(name, "KeepY-Sprint") or input.is_key_down(57) then
        if facing == 1 then
            return x, y - 1, z
        elseif facing == 2 then
            return x, y + 1, z
        elseif facing == 3 then
            return x, y, z - 1
        elseif facing == 4 then
            return x, y, z + 1
        elseif facing == 5 then
            return x - 1, y, z
        elseif facing == 6 then
            return x + 1, y, z
        end
    else
        if facing == 1 then
            return x, starty - 1, z
        elseif facing == 2 then
            return x, starty + 1, z
        elseif facing == 3 then
            return x, starty, z - 1
        elseif facing == 4 then
            return x, starty, z + 1
        elseif facing == 5 then
            return x - 1, starty, z
        elseif facing == 6 then
            return x + 1, starty, z
        end
    end
end

local function toOpposite(facing)
    if facing == 1 then
        return 2
    elseif facing == 2 then
        return 1
    elseif facing == 3 then
        return 4
    elseif facing == 4 then
        return 3
    elseif facing == 5 then
        return 6
    elseif facing == 6 then
        return 5
    end
end

local function ExtrafindBlocks()
    local enumFacings = {
        down = 1,
        up = 2,
        north = 3,
        south = 4,
        west = 5,
        east = 6
    }
    local rawX, rawY, rawZ = player.position()
    local x, y, z = math.floor(rawX), math.floor(rawY), math.floor(rawZ)
    if world.block(x, y - 1, z) == "tile.air" then
        for _, enumFacing in pairs(enumFacings) do
            if enumFacing ~= 2 then
                local offSetX, offSetY, offSetZ = offSetPos(x, y - 1, z, enumFacing)
                if world.block(offSetX, offSetY, offSetZ) ~= "tile.air" then
                    return offSetX, offSetY, offSetZ, toOpposite(enumFacing)
                end
            end
        end
        for _, enumFacing in pairs(enumFacings) do
            if enumFacing ~= 2 then
                local offSetX1, offSetY1, offSetZ1 = offSetPos(x, y - 1, z, enumFacing)
                if world.block(offSetX1, offSetY1, offSetZ1) == "tile.air" then
                    for _, enumFacing2 in pairs(enumFacings) do
                        if enumFacing2 ~= 2 then
                            local offSetX2, offSetY2, offSetZ2 = offSetPos(offSetX1, offSetY1, offSetZ1, enumFacing2)
                            if world.block(offSetX2, offSetY2, offSetZ2) ~= "tile.air" then
                                return offSetX2, offSetY2, offSetZ2, toOpposite(enumFacing2)
                            end
                        end
                    end
                end
            end
        end
        for _, enumFacing in pairs(enumFacings) do
            if enumFacing ~= 2 then
                local offSetX1, offSetY1, offSetZ1 = offSetPos(x, y - 2, z, enumFacing)
                if world.block(offSetX1, offSetY1, offSetZ1) == "tile.air" then
                    for _, enumFacing2 in pairs(enumFacings) do
                        if enumFacing2 ~= 2 then
                            local offSetX2, offSetY2, offSetZ2 = offSetPos(offSetX1, offSetY1, offSetZ1, enumFacing2)
                            if world.block(offSetX2, offSetY2, offSetZ2) ~= "tile.air" then
                                return offSetX2, offSetY2, offSetZ2, toOpposite(enumFacing2)
                            end
                        end
                    end
                end
            end
        end
        for _, enumFacing in pairs(enumFacings) do
            if enumFacing ~= 2 then
                local offSetX1, offSetY1, offSetZ1 = offSetPos(x, y - 3, z, enumFacing)
                if world.block(offSetX1, offSetY1, offSetZ1) == "tile.air" then
                    for _, enumFacing3 in pairs(enumFacings) do
                        if enumFacing3 ~= 2 then
                            local offSetX3, offSetY3, offSetZ3 = offSetPos(offSetX1, offSetY1, offSetZ1, enumFacing3)
                            if world.block(offSetX3, offSetY3, offSetZ3) ~= "tile.air" then
                                return offSetX3, offSetY3, offSetZ3, toOpposite(enumFacing3)
                            end
                        end
                    end
                end
            end
        end
    end
end

local function findBlocks(ylvl)
    local enumFacings = {
        down = 1,
        up = 2,
        north = 3,
        south = 4,
        west = 5,
        east = 6
    }
    local rawX, rawY, rawZ = player.position()
    local x, y, z = math.floor(rawX), math.floor(rawY), math.floor(rawZ)
    if world.block(x, ylvl, z) == "tile.air" then
        for _, enumFacing in pairs(enumFacings) do
            if enumFacing ~= 2 then
                local offSetX, offSetY, offSetZ = offSetPos(x, ylvl, z, enumFacing)
                if world.block(offSetX, offSetY, offSetZ) ~= "tile.air" then
                    return offSetX, offSetY, offSetZ, toOpposite(enumFacing)
                end
            end
        end
        for _, enumFacing in pairs(enumFacings) do
            if enumFacing ~= 2 then
                local offSetX1, offSetY1, offSetZ1 = offSetPos(x, ylvl, z, enumFacing)
                if world.block(offSetX1, offSetY1, offSetZ1) == "tile.air" then
                    for _, enumFacing2 in pairs(enumFacings) do
                        if enumFacing2 ~= 2 then
                            local offSetX2, offSetY2, offSetZ2 = offSetPos(offSetX1, offSetY1, offSetZ1, enumFacing2)
                            if world.block(offSetX2, offSetY2, offSetZ2) ~= "tile.air" then
                                return offSetX2, offSetY2, offSetZ2, toOpposite(enumFacing2)
                            end
                        end
                    end
                end
            end
        end
    end
end

local function DistanceToGround()
    for i = 1, 20 do
        local x,y,z = player.position()
        if not player.on_ground() and world.block(x, y - (i / 10), z) ~= "tile.air" then
            return (i / 10)
        end
    end
end

local function getDirection()
    local yaw, pitch = player.angles()
	local forward, strafing = player.strafe()
    if forward == 0 and strafing == 0 then
        return yaw
    end
    local strafingYaw
    local reversed = forward < 0
    if forward > 0 then
        strafingYaw = 90 * 0.5
    elseif reversed then
        strafingYaw = 90 * -0.5
    else
        strafingYaw = 90 * 1
    end
    if reversed then
        yaw = yaw + 180
    end
    
    if strafing > 0 then
        yaw = yaw - strafingYaw
    elseif strafing < 0 then
        yaw = yaw + strafingYaw
    end
    return yaw
end

local function getCoord(facing, coord)
    for _, dir in ipairs(directions) do
        if dir.facing == facing then
            if coord == "x" then
                return dir.x
            elseif coord == "y" then
                return dir.y
            elseif coord == "z" then
                return dir.z
            end
        end
    end
end

local function place()
    blockX, blockY, blockZ, blockFacing = findBlocks(startYLevel)
    if blockX == nil or blockY == nil or blockZ == nil or blockFacing == nil then return end
    rot2_Yaw, rot2_Pitch = player.angles_for_cords(blockX, blockY + module_manager.option(name, "Yaw-Offset"), blockZ)
    i = i + 1
    if math.random() > 0.9 then
        rand = true
    else
        rand = false
    end
    if module_manager.option(name, "Rotations") == 3 then
        player.message("." .. name .. " Yaw-Offset "..tostring(-math.floor(math.random() * 5)))
    end
    player.swing_item()
    player.place_block(player.held_item_slot(), blockX, blockY, blockZ, blockFacing, (blockX + 0.5) + getCoord(blockFacing, "x") * 0.5, (blockY + 0.5) + getCoord(blockFacing, "y") * 0.5, (blockZ + 0.5) + getCoord(blockFacing, "z") * 0.5)
end

local function ExtraPlace()
    blockX, blockY, blockZ, blockFacing = ExtrafindBlocks()
    if blockX == nil or blockY == nil or blockZ == nil or blockFacing == nil then return end
    rot2_Yaw, rot2_Pitch = player.angles_for_cords(blockX, blockY + module_manager.option(name, "Yaw-Offset"), blockZ)
    i = i + 1
    if math.random() > 0.9 then
        rand = true
    else
        rand = false
    end
    if not player.on_ground() then
        sstarted = sstarted + 1
    end
    if module_manager.option(name, "Rotations") == 3 then
        player.message("." .. name .. " Yaw-Offset "..tostring(-math.floor(math.random() * 5)))
    end
    player.swing_item()
    player.place_block(player.held_item_slot(), blockX, blockY, blockZ, blockFacing, (blockX + 0.5) + getCoord(blockFacing, "x") * 0.5, (blockY + 0.5) + getCoord(blockFacing, "y") * 0.5, (blockZ + 0.5) + getCoord(blockFacing, "z") * 0.5)
end

local function isMoving()
	if input.is_key_down(17) or input.is_key_down(30) or input.is_key_down(31) or input.is_key_down(32) then
		return true
	else
		return false
	end
end

module_manager.register(name, {
    on_pre_motion = function(t)
        if not input.is_key_down(57) then
            player.set_sprinting(true)
        else
            player.set_sprinting(false)
        end
        
        if player.on_ground() and isMoving() and not input.is_key_down(57) then
            extra = false
            player.jump()
            player.set_speed(player.get_speed())
            sairticks = 0
        else
            sairticks = sairticks + 1
        end
        px, py, pz = player.position()
        if input.is_key_down(57) then
            space = 1
            if math.floor(py - 2) > startYLevel then
                startYLevel = math.floor(py - 2)
            end
        elseif space == 1 then
            space = 2
            if space == 2 then
                player.set_speed(0)
                sstarted = 0
                space = 0
            end
        end

        if py < startYLevel then
            startYLevel = math.floor(py - 2)
        end

        local slot = grabBlockSlot()

        if slot == -1 then return end

        if swap then
            swapdelay = swapdelay + 1
        end

        if swapdelay >= 3 then
            player.set_held_item_slot(slot - 2)
            swapdelay = 0
        end

        if module_manager.option(name, "Rotations") == 1 then
            t.yaw = getDirection() - 180
            if input.is_key_down(57) then
                t.pitch = 83
            else
                t.pitch = 80
            end
        elseif module_manager.option(name, "Rotations") == 2 then
            rand = false
            if rand then
                t.yaw = getDirection() - 180 + (rot2_Yaw * 0.01)
            else
                t.yaw = getDirection() - 180 - (rot2_Yaw * 0.01)
            end
            t.pitch = rot2_Pitch
        elseif module_manager.option(name, "Rotations") == 3 then
            if rand then
                t.yaw = getDirection() - 180 + (rot2_Yaw * 0.01)
            else
                t.yaw = getDirection() - 180 - (rot2_Yaw * 0.01)
            end
            t.pitch = rot2_Pitch
        end
        
        return t
    end,

    on_enable = function()
        sstarted = 0
        px, py, pz = player.position()
        startYLevel = math.floor(py - 2)
        set_module_state("antifireball",false)
        set_module_state("Sprint",false)
        px,py,pz = player.position()
        oldSlot = player.held_item_slot()
        local slot = grabBlockSlot()
        if slot == -1 then return end
        player.set_held_item_slot(slot - 2)
    end,

    on_pre_update = function(t)
        if sstarted < 1 then
            if player.on_ground() and isMoving() and not input.is_key_down(57) then
                player.jump()
                startYLevel = startYLevel + 1
                sstarted = 0
            end
            ExtraPlace()
        else
            if not input.is_key_down(57) then
                place()
            else
                ExtraPlace()
            end
            
            if DistanceToGround() ~= nil then
                if DistanceToGround() < 1.5 and not extra and player.fall_distance() > 0 then
                    ExtraPlace()
                    if player.on_ground() then
                        extra = true
                    end
                end
            end
        end

        if module_manager.option(name, "Swap Tower") then
            if player.on_ground() and input.is_key_down(57) then
                on_gorunds = true
            end

            if on_gorunds then
                if input.is_key_down(57) and input.is_key_down(17) then
                    tower = true
                    local tx, ty, tz = player.motion()
                    local spx, spy, spz = player.position()
                    holdticks = holdticks + 1
                    offgroundticks = offgroundticks + 1
                    if holdticks > 6 then
                        if player.on_ground() then
                            holdticks = 0
                        end
                    end
    
                    if holdticks < 7 then
                        player.set_motion(tx,0.41935,tz)
                        player.set_speed(0.20)
                        if player.on_ground() then
                            offgroundticks = 0
                        end
    
                        if offgroundticks == 1 then
                            player.set_motion(tx,0.33,tz)
                        end
    
                        if offgroundticks == 2 then
                            player.set_motion(tx, 1 - spy % 1 , tz)
                        end
    
                        if offgroundticks == 3 then
                            offgroundticks = 0
                        end
                    end
                end
                if offgroundticks >= 3 then
                    offgroundticks = 0
                end

                if tower and not input.is_key_down(57) or tower and not input.is_key_down(17) then
                    offgroundticks = 0
                    tower = false
                    on_gorunds = false
                end
            end
        end

        px,py,pz = player.position()
    end,

    on_disable = function()
        set_module_state("Sprint",true)
        player.set_held_item_slot(oldSlot - 2)
        swapdelay = 0
    end,

    on_player_move = function(t)
        if not input.is_key_down(57) then
            if sstarted < 1 then
                player.set_motion(t.x * 0.7 , t.y , t.z * 0.7)
            else
                if player.is_potion_active(1) then
                    player.set_motion(t.x * ((module_manager.option(name,"Speed") - 5) / 1000 ), t.y, t.z * ((module_manager.option(name,"Speed") - 5) / 1000) )
                else
                    player.set_motion(t.x * (module_manager.option(name,"Speed") / 1000), t.y, t.z * (module_manager.option(name,"Speed") / 1000))
                end
            end
        end
    end,

    on_send_packet = function(t)
        if t.packet_id == 0x08 then
            swapdelay = 0
            swap = true
        end
    end
})
module_manager.register_number(name, "Rotations", 1, 3, 1)
module_manager.register_number(name, "Yaw-Offset", -9, 2, -4)
module_manager.register_number(name, "Speed", 1, 1000, 999)
module_manager.register_boolean(name, "Swap Tower", true)