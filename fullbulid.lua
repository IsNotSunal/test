directions = {
    { facing = 1, x = 0, y = -1, z = 0 },
    { facing = 2, x = 0, y = 1, z = 0 },
    { facing = 3, x = 0, y = 0, z = -1 },
    { facing = 4, x = 0, y = 0, z = 1 },
    { facing = 5, x = -1, y = 0, z = 0 },
    { facing = 6, x = 1, y = 0, z = 0 }
}

color = {
    dark_red = '\194\1674',
    red = '\194\167c',
    gold = '\194\1676',
    yellow = '\194\167e',
    dark_green = '\194\1672',
    green = '\194\167a',
    aqua = '\194\167b',
    dark_aqua = '\194\1673',
    dark_blue = '\194\1671',
    blue = '\194\1679',
    light_purple = '\194\167d',
    dark_purple = '\194\1675',
    white = '\194\167f',
    gray = '\194\1677',
    dark_gray = '\194\1678',
    black = '\194\1670'
}

global = {
    getBulid = function ()
        return 1
    end,

    set_module_state = function(mod, state)
        if module_manager.is_module_on(mod) ~= state then
            player.message("." .. mod)
        end
    end,

    hide_module_state = function (mod , state)
        if state == false then
            player.message(".show " .. mod)
        else
            player.message(".hide " .. mod)
        end
    end,

    isMoving = function()
        if input.is_key_down(17) or input.is_key_down(30) or input.is_key_down(31) or input.is_key_down(32) then
            return true
        else
            return false
        end
    end,

    is_holding_sword = function()
        return player.held_item() ~= nil and (string.match(player.held_item(), 'Sword'))
    end,

    is_holding_gap = function()
        return player.held_item() ~= nil and (string.match(player.held_item(), 'Apple'))
    end,

    enableka = function()
        if not module_manager.is_module_on("kawhitelist") then
            player.message(".kawhitelist")
        end
        player.message(".killaura Entities Players true")
        player.message(".killaura Entities Invisibles true")
        player.message(".killaura Entities Teams true")
        player.message(".killaura Entities Astolfo-Users true")
    end,

    disableka = function()
        if module_manager.is_module_on("kawhitelist") then
            player.message(".kawhitelist")
        end
        player.message(".killaura Entities Players false")
        player.message(".killaura Entities Invisibles false")
        player.message(".killaura Entities Teams false")
        player.message(".killaura Entities Astolfo-Users false")
    end,

    contains = function(table, val)
        for i = 1, #table do
           if table[i] == val then 
              return true
           end
        end
        return false
    end
}

antivoid = {
    ground_distance = function () 
        local x,y,z = player.position()
        for i = y, 0, -0.1 do
            if world.block(x, i, z) ~= 'tile.air' then
                return y - i
            end
        end
        return -1
    end
}

nofall = {
    voidcheck = function()
        local x,y,z = player.position()
        for i = y, 0, -1 do
            if world.block(x, i, z) ~= 'tile.air' then
                return false
            end
        end
        return true
    end,
    
    falldist = function()
        for i = 1, 4 do
            local x,y,z = player.position()
            if world.block(x, y-i, z) ~= "tile.air" then
                return false
            end
        end
        return true
    end
}

autoblock = {
    targetting = function()
        return player.kill_aura_target() ~= nil and global.is_holding_sword() and not module_manager.is_module_on("scaffold")
    end,

    block = function()
        player.send_packet_no_event(0x08)
    end,

    swap = function()
        player.send_packet(0x09, player.held_item_slot() % 8 + 1)
        player.send_packet(0x09, player.held_item_slot())
    end,
}

scaffold = {
    grabBlockSlot = function()
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
    end,

    offSetPos = function(x, y, z, facing) 
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
    end,

    toOpposite = function(facing)
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
    end,

    findBlocks = function()
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
                    local offSetX, offSetY, offSetZ = scaffold.offSetPos(x, y - 1, z, enumFacing)
                    if world.block(offSetX, offSetY, offSetZ) ~= "tile.air" then
                        return offSetX, offSetY, offSetZ, scaffold.toOpposite(enumFacing)
                    end
                end
            end
            for _, enumFacing in pairs(enumFacings) do
                if enumFacing ~= 2 then
                    local offSetX1, offSetY1, offSetZ1 = scaffold.offSetPos(x, y - 1, z, enumFacing)
                    if world.block(offSetX1, offSetY1, offSetZ1) == "tile.air" then
                        for _, enumFacing2 in pairs(enumFacings) do
                            if enumFacing2 ~= 2 then
                                local offSetX2, offSetY2, offSetZ2 = scaffold.offSetPos(offSetX1, offSetY1, offSetZ1, enumFacing2)
                                if world.block(offSetX2, offSetY2, offSetZ2) ~= "tile.air" then
                                    return offSetX2, offSetY2, offSetZ2, scaffold.toOpposite(enumFacing2)
                                end
                            end
                        end
                    end
                end
            end
            for _, enumFacing in pairs(enumFacings) do
                if enumFacing ~= 2 then
                    local offSetX1, offSetY1, offSetZ1 = scaffold.offSetPos(x, y - 2, z, enumFacing)
                    if world.block(offSetX1, offSetY1, offSetZ1) == "tile.air" then
                        for _, enumFacing2 in pairs(enumFacings) do
                            if enumFacing2 ~= 2 then
                                local offSetX2, offSetY2, offSetZ2 = scaffold.offSetPos(offSetX1, offSetY1, offSetZ1, enumFacing2)
                                if world.block(offSetX2, offSetY2, offSetZ2) ~= "tile.air" then           
                                    return offSetX2, offSetY2, offSetZ2, scaffold.toOpposite(enumFacing2)
                                end
                            end
                        end
                    end
                end
            end
            for _, enumFacing in pairs(enumFacings) do
                if enumFacing ~= 2 then
                    local offSetX1, offSetY1, offSetZ1 = scaffold.offSetPos(x, y - 3, z, enumFacing)
                    if world.block(offSetX1, offSetY1, offSetZ1) == "tile.air" then
                        for _, enumFacing3 in pairs(enumFacings) do
                            if enumFacing3 ~= 2 then
                                local offSetX3, offSetY3, offSetZ3 = scaffold.offSetPos(offSetX1, offSetY1, offSetZ1, enumFacing3)
                                if world.block(offSetX3, offSetY3, offSetZ3) ~= "tile.air" then           
                                    return offSetX3, offSetY3, offSetZ3, scaffold.toOpposite(enumFacing3)
                                end
                            end
                        end
                    end
                end
            end
        end
    end,

    getDirection = function()
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
    end,

    getCoord = function(facing, coord)
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
    end,

    place = function()
        local blockX, blockY, blockZ, blockFacing = scaffold.findBlocks()
        if blockX == nil or blockY == nil or blockZ == nil or blockFacing == nil then return end
        player.send_packet(0x0A)
        player.place_block(player.held_item_slot(), blockX, blockY, blockZ, blockFacing, (blockX + 0.5) + scaffold.getCoord(blockFacing, "x") * 0.5, (blockY + 0.5) + scaffold.getCoord(blockFacing, "y") * 0.5, (blockZ + 0.5) + scaffold.getCoord(blockFacing, "z") * 0.5)
    end
}

local startTime = os.clock() * 1000
arraylist = {
    clamp = function(val, min, max)
        if val < min then return min end
        if val > max then return max end
        return val
    end,

    blend_colors = function(color1, color2, ratio)
        local r = arraylist.clamp(color1[1] * ratio + color2[1] * (1 - ratio), 0, 255)
        local g = arraylist.clamp(color1[2] * ratio + color2[2] * (1 - ratio), 0, 255)
        local b = arraylist.clamp(color1[3] * ratio + color2[3] * (1 - ratio), 0, 255)
        return {r, g, b}
    end,

    render_gradient_text = function(text, x, y, startColor, endColor)
        local elapsed = os.clock() * 1000 - startTime
        local offset = 0.5 * (math.sin(elapsed * 0.001 * module_manager.option("Custom Arraylist", "Speed") - y * 0.05) + 1)
    
        local currentColor = arraylist.blend_colors(startColor, endColor, offset)
        render.scale(1)
        render.string_shadow(text, x, y, currentColor[1], currentColor[2], currentColor[3], 255)
        render.scale(1/1)
    end
}

modules = {
    getAutoBlock = function ()
        return true
    end,

    getAntiVoid = function ()
        return true
    end,

    getVelocity = function ()
        return true
    end,

    getSpeed = function ()
        return true
    end,

    getNoFall = function ()
        return true
    end,

    getScaffold = function ()
        return true , "Semi" , true
    end
}

local bulid = 1

if bulid == global.getBulid() then
    client.print(
        "\n\194\1679>Local Script Bulid : \194\1678" .. bulid ..
        "\n\194\1679>Latest Script Bulid : \194\1678" .. global.getBulid()
    )
else
    client.print(
        "\n\194\1679>Local Script Bulid : \194\1678" .. bulid ..
        "\n\194\1679>Latest Script Bulid : \194\167c" .. global.getBulid() ..
        "\n\194\167cPLEASE GET LATEST BULID OF ASTOLFO SCRIPT"
    )
end

local nor_scaffold , tower_scaffold , jump_scaffold = modules.getScaffold()

local function turnState(bool)
    if bool == true then
        return "\194\167aBypass\194\1678"
    elseif bool == "Via" then
        return "\194\167eVia Version Needed\194\1678"
    elseif bool == "Semi" then
        return "\194\167eSemi(Not Stable)\194\1678"
    else
        return "\194\1674Patch\194\1678"
    end
end

client.print(
    "\n\194\167b>Module Bypassing State : \n\194\1678>AutoBlock : " .. turnState(modules.getAutoBlock()) ..
    "\n\194\1678>AntiVoid : " .. turnState(modules.getAntiVoid()) ..
    "\n\194\1678>Blink Nofall : " .. turnState(modules.getNoFall()) ..
    "\n\194\1678>Velocity : " .. turnState(modules.getVelocity()) ..
    "\n\194\1678>Speed : " .. turnState(modules.getSpeed()) ..
    "\n\194\1678>Scaffold : " .. turnState(nor_scaffold) ..
    "\n\194\1678>Tower : " .. turnState(tower_scaffold) ..
    "\n\194\1678>Jump Scaffold : " .. turnState(jump_scaffold)
)

--var register
    --antivoid
local blinking = false
local wason = false
local falling = false
local cutie = false
    --velocity
local airticks = 0
    --speed
local speed = 0
    --nofallss
local started = false
    --autoblock
local blocking = false
local placingBlock = false
local stopKaingBlocks = false
local stopKaingGaps = false
local ateGap = false
local sendBlock = false
local blockTicks = 0
local checkBlock = 0
local gapTicks = 0
local slotChange = 0
local blocked = false
local lookingatblock = false
    --scaffold
local towers = false
local space = 0
local offgroundticks = 0
local wait = 0
local stop = false
local scaffoldon = false
local swap = false
local oldSlot = nil
local swapped = false
local swapdelay = 0
local donetower = false
    --noslow
local item = nil
local food = {
    "item.potion",
    "item.milk"
}
    --arraylist
local mainModules = {
    "BedAura",
    "KillAura",
    "Scaffold",
    "AntiFireball",
    "LegitSpeed",
    "Reach",
    "Inventorymanager",
    "Fly",
    "Stealer" ,
    "Velocity" ,
    "Sprint",
    "Fastplace",
    "Blink",
    "BlinkNoFall",
    "AntiVoid",
    "NoSlow\194\1677 Watchdog",
    "AutoBlock",
    "AutoArmor",
    "AutoHeal",
    "AutoTool"
}
local showModules = {}
    --blink info
local blink_ticks = 0



--module
    --antiboid
local antivoid = {
    on_pre_motion = function(t)
        local dist = antivoid.ground_distance()
        local blinkdist = module_manager.option('AntiVoid', 'Distance')
        local side_hit = player.over_mouse()

        if falling then
            if player.on_ground() or dist ~= -1 then
                falling = false
                cutie = false
                blinking = false
                global.set_module_state('blink', false)
                global.set_module_state('antidesync', false)
                player.message('.killaura Entities Players true')
            end

            if player.fall_distance() > blinkdist and dist == -1 and not cutie then
                local x,y,z = player.position()
                cutie = true
                player.send_packet_no_event(0x04, x, -420, z, false)
                global.set_module_state('blink', false)
                global.set_module_state('antidesync', false)
                if not module_manager.is_module_on("killaura") and wason == true then
                    player.message('.killaura')
                end
            end
        else
            if dist == -1 and not player.on_ground() and not (side_hit == 2 and input.is_mouse_down(1)) and not module_manager.is_module_on('Long-Jump')  and not module_manager.is_module_on('NoFall') and not module_manager.is_module_on('Scaffold')  then
                global.set_module_state('blink', true)
                global.set_module_state('antidesync', true)
                blinking = true
                falling = true
                player.message('.killaura Entities Players false')
            end
        end
    end,
    
    on_send_packet = function(t)
        if blinking and (t.packet_id == 0x07 or t.packet_id == 0x08 or t.packet_id == 0x0A or t.packet_id == 0x02) then
            t.cancel = true
        end
        return t
    end
}
    --hypixel velocity_mod
local velocity_mod = {
    on_pre_update = function()
        player.message(".velocity vertical 0")
		if player.on_ground() then
			airticks = 0
		else
			airticks = airticks + 1
		end
    end,

    on_receive_packet = function(e)
		if module_manager.is_module_on("Velocity") and airticks <= 5 then
			if e.packet_id == 0x12 and e.entity_id == player.id() then
				e.cancel = true
				local mx,my,mz = player.motion()
				player.set_motion(mx, e.motion_y / 8000.0, mz)
			end
		end
        return e
    end,

    on_enable = function ()
        global.set_module_state("velocity" , true)
        global.hide_module_state("velocity" , true)
    end,

    on_disable = function ()
        global.set_module_state("velocity" , false)
        global.hide_module_state("velocity" , false)
    end
}
    --speed
local bhop = {
    on_pre_motion = function()
        if player.is_potion_active(1) then
            speed = 0.55
        else
            speed = 0.48
        end

        if player.on_ground() and global.isMoving() and not module_manager.is_module_on("scaffold") then
            if not input.is_key_down(57) then
                player.jump()
				player.set_speed(speed)
            else
                
                player.set_speed(speed)
            end
        end

        local mx , my , mz = player.motion()
        player.set_motion(mx * 0.995, my, mz * 0.995)
        player.message('.sprint omnidirectional true')

        if module_manager.is_module_on("scaffold") then
            if player.on_ground() then
                player.set_sprinting(true)
                player.message(".scaffold keep-sprint true")
                if global.isMoving() then
                    player.jump()
                    speed = speed - 0.05
                    player.set_speed(speed)
                end
            else
                player.set_sprinting(false)
                player.message(".scaffold keep-sprint false")
            end
        end
    end,

    on_disable = function()
        player.message('.sprint omnidirectional false')
    end,
}
    --nofalls
local nofalls = { 
    on_pre_motion = function()
        if player.kill_aura_target() == nil and not nofall.voidcheck() and not module_manager.is_module_on("Scaffold") and player.is_on_edge() and player.on_ground() and not module_manager.is_module_on("Long-Jump") and not module_manager.is_module_on("Nofall") and nofall.falldist() and not input.is_key_down(57) then
            player.message(".nofall mode spoof")
            global.set_module_state("Nofall", true)
            global.set_module_state("Blink", true)
            started = true
        end

        if started and player.on_ground() and not player.is_on_edge() then
            global.set_module_state("Nofall", false)
            global.set_module_state("Blink", false)
            started = false
        end
    end
}
    --autoblock
local autoblock = {
    on_send_packet = function(t)
        if t.packet_id == 0x08 and player.kill_aura_target() ~= nil then
            t.cancel = true
            blocked = true
        elseif t.packet_id == 0x07 and blocked and player.kill_aura_target() ~= nil then
            t.cancel = true
            blocked = false
        end
        local name = player.inventory.item_information(35 + player.held_item_slot())
        local x,x,x,x,x,  x,y,z = player.over_mouse()
        if t.packet_id == 0x08 and name ~= nil and string.match(name, 'tile') and (lookingatblock or module_manager.is_module_on("Scaffold2")) and not (world.block(x,y,z) ~= 'tile.furnace' or world.block(x,y,z) ~= 'tile.crafting_table') then
            placingBlock = true
            checkBlock = 0
        end

        if t.packet_id == 0x02 and slotChange >= 2 and blocking then
            sendBlock = true
            autoblock.swap()
        end
        return t
    end,

    on_pre_motion = function()
        if sendBlock then
            autoblock.block()
            sendBlock = false
        end

        if global.is_holding_sword() then
            slotChange = slotChange + 1
        end

        if not global.is_holding_sword() then
            slotChange = 0
        end

        if global.is_holding_sword() and player.kill_aura_target() ~= nil then --- main autoblock
            player.message('.killaura auto-block fake') -- for animation
            blocking = true
        end

        if blocking and player.kill_aura_target() == nil then
            player.message('.killaura auto-block none')
            player.send_packet(0x07)
            blocking = false
            sendBlock = false
        end
    end,

    on_pre_update = function()
        if placingBlock and global.is_holding_sword() then  --- spam block ghosting fix
            global.disableka()
            stopKaingBlocks = true
            placingBlock = false
        end

        if stopKaingBlocks then
            blockTicks = blockTicks + 1
        end

        if blockTicks == 3 then
            global.enableka()
            stopKaingBlocks = false
            blockTicks = 0
        end

        if checkBlock == 4 then
            placingBlock = false
            stopKaingBlocks = false
            blockTicks = 0
            checkBlock = 0
        end

        if global.is_holding_gap() and player.using_item() then --- gapping ghosting fix
            ateGap = true
        end

        if ateGap and (not global.is_holding_gap() or global.is_holding_gap() and not player.using_item()) then
            global.disableka()
            stopKaingGaps = true
            ateGap = false
        end

        if stopKaingGaps then
            gapTicks = gapTicks + 1
        end

        if gapTicks == 3 then
            global.enableka()
            stopKaingGaps = false
            gapTicks = 0
        end

        if placingBlock and not blocking and not module_manager.is_module_on("Scaffold2") then
            checkBlock = checkBlock + 1
        end

        local n, v, x, y, z = player.over_mouse()
        if n == 2 then
            lookingatblock = true
        else
            lookingatblock = false
        end
    end
}
    --scaffold
local scaffold = {
    on_pre_motion = function(t)
        if input.is_key_down(57) then
            space = space + 1
        else
            space = 0
        end

        if stop then
            wait = wait + 1
            player.set_motion(0,0,0)
        else
            wait = 0
        end

        if wait == 5 then
            stop = false
        end

        if module_manager.option("BlockFly", "speedy") and input.is_key_down(57) and input.is_key_down(17) then
            local mx , my , mz = player.motion()
            if player.hurt_time() < 9 and global.isMoving() then
                if player.on_ground() then
                    player.jump()
                    if not offgroundticks then
                        offgroundticks = -100
                        return
                    end
                    player.set_speed(0.25)
                    t.y = t.y + 10^-14
                    offgroundticks = 0
                elseif offgroundticks then
                    offgroundticks = offgroundticks + 1
                    if offgroundticks == 4 then
                        player.set_motion(mx , 0.05 , mz)
                    elseif offgroundticks == 6 then
                        player.set_motion(mx , my - 0.1 , mz)
                    end
                end
            else
                offgroundticks = 0
            end
        else
            offgroundticks = 0
        end

        local slot = scaffold.grabBlockSlot()
        if slot == -1 then
            return
        end

        if swap then
            swapdelay = swapdelay + 1
        end

        if swapdelay >= 3 then
            player.set_held_item_slot(slot - 2)
            swapped = true
            swapdelay = 0
        end

        t.yaw = scaffold.getDirection() - 180
        if player.on_ground() then
            t.pitch = 83
        else
            t.pitch = 75
        end
        
        return t
    end,
    on_pre_update = function()
        if input.is_key_down(57) or not player.on_ground()then
            scaffold.place()
            scaffold.place()
        else
            scaffold.place()
        end
        if towers and not input.is_key_down(57) then
            player.set_speed(0)
            towers = false
        end
        
        local mx, my, mz = player.motion()
        
        if player.on_ground() then
            if player.is_potion_active(1) then
                player.set_motion(mx * 0.913, my, mz * 0.913)
            else
                player.set_motion(mx * 0.96, my, mz * 0.96)
            end
        end
        global.disableka()
    end,
    on_enable = function()
        oldSlot = player.held_item_slot()
        local slot = scaffold.grabBlockSlot()
        if slot == -1 then return end
        player.set_held_item_slot(slot - 2)
        swapped = true
        global.set_module_state("scaffold" , true)
        player.message(".scaffold rotation EYE_ANGLE")
        player.message(".scaffold swing CLIENT")
        player.message(".scaffold place-mode PRE")
        player.message(".scaffold down false")
        player.message(".scaffold edge-check false")
        player.message(".scaffold extend 0")
        player.message(".scaffold ray-cast false")
        player.message(".scaffold spoof false")
        player.message(".scaffold tower FALSE")
        player.message(".scaffold tower-center false")
        player.message(".scaffold keep-rotation false")
        player.message(".scaffold slow false")
        player.message(".scaffold keep-sprint false")
        player.message(".scaffold stairs false")
        player.message(".scaffold safe-walk true")
        player.message(".scaffold keep-y false")
        player.message(".scaffold slot 1")
        player.message(".scaffold Biggest-stack false")
        player.message(".scaffold safe-stack false")
        player.message(".scaffold safe-stack-slot 1")
        player.message(".scaffold ncp-hypixel false")
        player.message(".scaffold delay 1")
        player.message(".scaffold hotbar-move false")
    end,

    on_disable = function()
        if scaffoldon and module_manager.is_module_on("Scaffold") then
            player.message(".Scaffold")
            scaffoldon = false
        end
        if swapped then
            player.set_held_item_slot(oldSlot - 2)
            swapped = false
        end
        swapdelay = 0
        global.enableka()
        global.set_module_state("scaffold" , false)
    end,

    on_send_packet = function(t)
        if t.packet_id == 0x08 then
            swapdelay = 0
            swap = true
        end
    end
}
    --noslow
local noslow = {
    on_send_packet = function(t)
        if t.packet_id == 0x08 and global.contains(food, item) then
            global.set_module_state('noslow', false)
        end
    end,

    on_pre_motion = function(t)
        item = player.inventory.item_information(35 + player.held_item_slot())

        if player.using_item() then
            if player.ticks_existed() % 2 == 0 and not global.contains(food, item) then
                for i = 10, 45 do
                    if not player.inventory.item_information(i - 1) then
                        player.place_block((i - 1) % 36 + 1, -1, -1, -1, 1, -1, -1, -1)
                        return
                    end
                end
            end
        else
            global.set_module_state('noslow', true)
        end
    end
}
    --arraylist
local arraylist = {
    on_render_screen = function(ctx)
        local r1, b1, g1, r2, b2, g2 = module_manager.option("Custom Arraylist", "Start R"), module_manager.option("Custom Arraylist", "Start B"), module_manager.option("Custom Arraylist", "Start G"), module_manager.option("Custom Arraylist", "End R"), module_manager.option("Custom Arraylist", "End B"), module_manager.option("Custom Arraylist", "End G")
        
        local top_x
        local top_y = module_manager.option("Custom Arraylist" , "Offset") + 1

        if module_manager.option("Custom Arraylist" , "Text Align") == 1 then
            top_x = module_manager.option("Custom Arraylist" , "Offset")
        elseif module_manager.option("Custom Arraylist" , "Text Align") == 2 then
            top_x = ctx.width / 2
        else
            top_x = ctx.width - module_manager.option("Custom Arraylist" , "Offset")
        end

        for _, mainModule in ipairs(mainModules) do
            if module_manager.is_module_on(mainModule) then
                showModules[mainModule] = true
            elseif not module_manager.is_module_on(mainModule)  then
                showModules[mainModule] = nil
            end
        end

        local combinedList = {}
        local suffix_type = ""

        if module_manager.option("Custom Arraylist" , "Suffix Type") == 1 then
            suffix_type = " "
        elseif module_manager.option("Custom Arraylist" , "Suffix Type") == 2 then
            suffix_type = " - "
        else
            suffix_type = " > "
        end

        for module, _ in pairs(showModules) do
            --normal suffix
            if module_manager.option("Custom Arraylist", "Suffix") then
                if module == "KillAura" then
                    table.insert(combinedList, "KillAura\194\1677" .. suffix_type .. "Silent")
                elseif module == "LegitSpeed" then
                    table.insert(combinedList , "Speed\194\1677" .. suffix_type .. "Hypixel")
                elseif module == "Velocity" then
                    table.insert(combinedList , "Velocity\194\1677" .. suffix_type .. "Hypixel")
                elseif module == "AntiVoid" then
                    table.insert(combinedList , "AntiVoid\194\1677" .. suffix_type .. "Blink")
                elseif module == "BlinkNoFall" then
                    table.insert(combinedList , "NoFall\194\1677" .. suffix_type .. "Blink")
                elseif module == "AutoBlock" then
                    table.insert(combinedList , "AutoBlock\194\1677" .. suffix_type .. "Watchdog")
                elseif module == "NoSlow\194\1677 Watchdog" then
                    table.insert(combinedList , "NoSlow\194\1677" .. suffix_type .. "Hypixel")
                elseif module == "AutoHeal" then
                    table.insert(combinedList , "AutoPot")
                else
                    table.insert(combinedList, module)
                end
            --all blink suffix
            elseif module_manager.option("Custom Arraylist", "All Blink") then
                if module == "NoSlow\194\1677 Watchdog" then
                    table.insert(combinedList, "NoSlow\194\1677" .. suffix_type .. "Blink")
                else
                    table.insert(combinedList, module .. "\194\1677" .. suffix_type .. "Blink")
                end
            else
            --no suffix 
                if module == "LegitSpeed" then
                    table.insert(combinedList, "Speed")
                elseif module == "Inventorymanager" then
                    table.insert(combinedList, "InvManager")
                elseif module == "BlinkNoFall" then
                    table.insert(combinedList , "NoFall")
                elseif module == "NoSlow\194\1677 Watchdog" then
                    table.insert(combinedList , "NoSlow")
                elseif module == "AutoHeal" then
                    table.insert(combinedList , "AutoPot")
                else
                    table.insert(combinedList, module)
                end
            end
        end
        table.sort(combinedList, function(a, b)
            return render.get_string_width(b) < render.get_string_width(a)
        end)
        local y = top_y
        for _, item in ipairs(combinedList) do
            local text_aglin
            if module_manager.option("Custom Arraylist" , "Text Align") == 1 then
                text_aglin = 0
            elseif module_manager.option("Custom Arraylist" , "Text Align") == 2 then
                text_aglin = render.get_string_width(item) / 2
            else
                text_aglin = render.get_string_width(item)
            end
            arraylist.render_gradient_text(item, top_x - text_aglin , y, {r1, g1, b1}, {r2, g2, b2})
            y = y + 10
        end
    end
}
    --info
local info = {
    on_render_screen = function (ctx)
        local strings = "Blinking : " .. blink_ticks
        if module_manager.is_module_on("Blink") then
            render.string_shadow(strings , ctx.width /2 - render.get_string_width(strings) / 2 , ctx.height / 2 , 255 , 255 , 255 , 255)
        end
    end,

    on_pre_update = function ()
        if module_manager.is_module_on("Blink") then
            blink_ticks = blink_ticks + 1
        else
            blink_ticks = 0
        end
    end
}


--reigster module 
    --antivoid
module_manager.register('AntiVoid' , antivoid)
module_manager.register_number('AntiVoid', 'Distance', 1, 20, 15)
    --hypixel velocity
module_manager.register('Velocity\194\1677 Hypixel' , velocity_mod)
    --speed
module_manager.register('LegitSpeed' , bhop)
    --nofalls
module_manager.register('BlinkNoFall', nofalls)
    --autoblock
module_manager.register("AutoBlock", autoblock)
    --scaffold
module_manager.register("BlockFly" , scaffold)
module_manager.register_boolean("BlockFly", "speedy", true)
    --noslow
module_manager.register("NoSlow\194\1677 Watchdog" , noslow)
    --arraylist
module_manager.register("Custom Arraylist" , arraylist)
module_manager.register_number("Custom Arraylist", "Start R", 0, 255, 126)
module_manager.register_number("Custom Arraylist", "Start B", 0, 255, 226)
module_manager.register_number("Custom Arraylist", "Start G", 0, 255, 170)
module_manager.register_number("Custom Arraylist", "End R", 0, 255, 230)
module_manager.register_number("Custom Arraylist", "End B", 0, 255, 154)
module_manager.register_number("Custom Arraylist", "End G", 0, 255, 141)
module_manager.register_number("Custom Arraylist", "Speed", 1, 10, 3)
module_manager.register_number("Custom Arraylist" , "Offset" , 0 , 50 , 5)
module_manager.register_number("Custom Arraylist" , "Text Align" , 1 , 3 , 3)
module_manager.register_number("Custom Arraylist" , "Suffix Type" , 1 , 3 , 3)
module_manager.register_boolean("Custom Arraylist", "Suffix", true)
module_manager.register_boolean("Custom Arraylist", "All Blink", false)
    --indacotor
module_manager.register("Blink Info" , info)