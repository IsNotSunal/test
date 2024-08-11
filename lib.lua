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

    is_holding_items = function ()
        return player.held_item() ~= nil and ((string.match(player.held_item(), 'Apple')) or (string.match(player.held_item(), 'Bow')) or (string.match(player.held_item(), 'Steak')) or (string.match(player.held_item(), 'Sword')))
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
        local offset = 0.5 * (math.sin(elapsed * 0.001 * module_manager.option("Custom Arraylist", "Color Speed") - y * 0.05) + 1)

        local currentColor = arraylist.blend_colors(startColor, endColor, offset)
        render.scale(1)
        render.string_shadow(text, x, y, currentColor[1], currentColor[2], currentColor[3], 255)
        render.scale(1/1)
    end
}

bhops = {
    block_full = function (x , y , z)
        local name = world.block(x , y , z)
        if string.match(name, 'stairs') ~= nil or string.match(name, 'Slab') ~= nil or string.match(name, 'glass') ~= nil or string.match(name, 'air') ~= nil then
            return false
        else
            return true
        end
    end,

    SpeedValue = function()
        if player.base_speed() == 0.221 or player.base_speed() == 0.2873 then 
            return 0.45
        end
        if player.base_speed() == 0.34476 or player.base_speed() == 0.2652 then 
            return 0.52
        end
        if player.base_speed() > 0.40221 and player.base_speed() < 0.40223 or player.base_speed() == 0.3094 then 
            return 0.59
        end
    end
}