http.load("https://gitee.com/SunalBest/ast-lib/raw/develop/lib.lua")
http.load("https://gitee.com/SunalBest/ast-lib/raw/develop/scaff.lua")
http.load("https://gitee.com/SunalBest/ast-lib/raw/develop/aura.lua")

local changelogs_type = {
    add = "\n" .. color.gray .. "[" .. color.green .. "+" .. color.gray .. "]" .. color.white,
    change = "\n" .. color.gray .. "[" .. color.white .. "~" .. color.gray .. "]" .. color.white,
    del = "\n" .. color.gray .. "[" .. color.red .. "-" .. color.gray .. "]" .. color.white
}

--bulid
local bulid = "v1.3"
client.print(
    "\n" ..
    "Welcome Back to Sunal " .. color.gold .. "Astolfo's Script!" ..
    "\n\194\1679Latest Script Bulid : \194\1678" .. bulid
)

client.print(
    "------------------------------------------------\n"..
    color.gold .. "Change Logs :" ..
    changelogs_type.add .. "Full Watchdog NoSlow"..
    changelogs_type.add .. "Exhibition WaterMark" ..
    changelogs_type.add .. "ETB Watermark" .. 
    changelogs_type.add .. "Change Logs" ..
    changelogs_type.add .. "Keep-y Scaffold" ..
    changelogs_type.add .. "Optimize BedAura" .. 
    changelogs_type.add .. "SlientAura (Based on xtyo's script)" ..
    changelogs_type.add .. "Float Hop" ..
    changelogs_type.change .. "Recode Scaffold" ..
    changelogs_type.del .. "Del Orginal Scaffold" ..
    changelogs_type.del .. "Script Cloud Bypassing State" 
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
local daair = 0
local jumpss = 0
    --nofallss
local started = false
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
        if module_manager.is_module_on("BlockFly") then
            return
        end

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
}

    --speed
local bhop = {
    on_pre_motion = function()
        if player.on_ground() and global.isMoving() and not module_manager.is_module_on("scaffold") then
            if not input.is_key_down(57) then
                player.jump()
				player.set_speed(bhops.SpeedValue())
                jumpss = jumpss + 1
            else
                player.set_speed(bhops.SpeedValue())
            end
        end

        if player.on_ground() then
            daair = 0
        else
            daair = daair + 1
        end

        player.message('.sprint omnidirectional true')
    end,

    on_player_move = function (t)
        if module_manager.option("LegitSpeed", "Float Hop") then
            local px, py, pz = player.position()
            if jumpss > 1 then
                if daair == 9 and bhops.block_full(px , py - 0.8 , pz) and t.y < -0.27 and t.y > - 0.38 then
                    player.set_motion(t.x , 0 , t.z)
                    player.set_speed(0.37)
                end
            end
        end
    end,

    on_disable = function()
        player.message('.sprint omnidirectional false')
        jumpss = 0
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

    --noslow
local noslow = {
    on_pre_motion = function(t)
        if global.is_holding_items() then
            global.set_module_state('noslow', true)
            global.hide_module_state('noslow' , true)
        else
            global.set_module_state('noslow', false)
            global.hide_module_state('noslow' , false)
        end

        if player.using_item() and global.is_holding_gap() then
            if player.ticks_existed() % 2 == 0 then
                for i = 10, 45 do
                    if not player.inventory.item_information(i - 1) then
                        player.place_block((i - 1) % 36 + 1, -1, -1, -1, 1, -1, -1, -1)
                        return
                    end
                end
            end
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

        local vel_suffix = "0% 0%"
        if module_manager.is_module_on("Velocity\194\1677 Hypixel") then
            vel_suffix = "Hypixel"
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
                    table.insert(combinedList , "Velocity\194\1677" .. suffix_type .. vel_suffix)
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
            local watermark_aglin
            local watermark_text_e = "E"
            local watermark_text = "xhibition " .. "\194\1677[\194\167f" .. client.fps() .. " FPS" .. "\194\1677]\194\167f  " .."\194\1677[\194\167f" .. "Config : " .. client.config() .. "\194\1677]\194\167f"
            if module_manager.option("Custom Arraylist" , "Text Align") == 1 then
                text_aglin = 0
                watermark_aglin = 0
            elseif module_manager.option("Custom Arraylist" , "Text Align") == 2 then
                text_aglin = render.get_string_width(item) / 2
                watermark_aglin = render.get_string_width(watermark_text_e .. watermark_text) / 2
            else
                text_aglin = render.get_string_width(item)
                watermark_aglin = render.get_string_width(watermark_text_e .. watermark_text)
            end

            local more_y = 0

            if module_manager.option("Custom Arraylist" , "WaterMark") then
                if module_manager.option("Custom Arraylist" , "WaterMark Styles") == 1 then
                    arraylist.render_gradient_text(watermark_text_e, top_x - watermark_aglin , top_y, {r1, g1, b1}, {r2, g2, b2})
                    render.string_shadow(watermark_text , top_x - watermark_aglin + 7 , top_y , 255 , 255 , 255 , 255)
                    more_y = 10
                elseif module_manager.option("Custom Arraylist" , "WaterMark Styles") == 2 then
                    local test = 15
                        local wy = 0
                        local wx = 0
                        render.draw_image("https://b.catgirlsare.sexy/1P1M8BsE4Z31.png", 0, 2, 32, 32)
                        render.rect(1, 12 / 0.95 + test, 60 / 0.99, 68 / 0.90+ test, 0, 0, 0, 161) -- background
                        render.rect(59 / 0.99, 12 / 0.95 + test, 60 / 0.99, 68 / 0.90+ test, 0, 0, 0, 255) -- linha direita
                        render.rect(1, 12 / 0.95 + test, 2, 68 / 0.90+ test, 0, 0, 0, 255) -- linha esquerda
                        render.rect(1, 71 / 0.95 + test, 59 / 0.99, 68 / 0.90+ test, 0, 0, 0, 255) -- linha de baixo
                        render.rect(1, 12 / 0.95 + test, 59 / 0.99, 12 / 0.90+ test, 0, 0, 0, 255) -- linha de cima
                        render.rect(2, 13 / 0.95 + test, 59 / 0.99, 23 / 0.90+ test, 255, 77, 76, 255) -- rect principal colorido
                        render.string_shadow("2.0", 22 + wx, 17 + wy, 177, 177, 177, 255)
                        render.string_shadow("Combat", 7, 30 + wy, 255, 255, 255, 255)
                        render.string_shadow("Render", 5, 43 + wy, 159, 159, 159, 255)
                        render.string_shadow("Movement", 5, 55 + wy, 159, 159, 159, 255)
                        render.string_shadow("Player", 5, 67 + wy, 159, 159, 159, 255)
                        render.string_shadow("World", 5, 79 + wy, 159, 159, 159, 255)
                        local facing = player.facing()
                        local directions = {
                            [3] = "N",
                            [4] = "S",
                            [5] = "W",
                            [6] = "E"
                        }
                        if directions[facing] then
                            render.string_shadow("[" .. directions[facing] .. "]", 38 + wx, 17 + wy, 255, 77, 76, 255)
                        end
                    if module_manager.option("Custom Arraylist" , "Text Align") == 1 then
                        more_y = 90
                    end
                end
                
            end

            arraylist.render_gradient_text(item, top_x - text_aglin , y + more_y, {r1, g1, b1}, {r2, g2, b2})
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
module_manager.register_boolean("LegitSpeed", "Float Hop", true)
    --nofalls
module_manager.register('BlinkNoFall', nofalls)
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
module_manager.register_number("Custom Arraylist", "Color Speed", 1, 10, 3)
module_manager.register_number("Custom Arraylist" , "Offset" , 0 , 50 , 5)
module_manager.register_number("Custom Arraylist" , "Text Align" , 1 , 3 , 3)
module_manager.register_number("Custom Arraylist" , "WaterMark Styles" , 1 , 2 , 2)
module_manager.register_number("Custom Arraylist" , "Suffix Type" , 1 , 3 , 3)
module_manager.register_boolean("Custom Arraylist", "WaterMark", false)
module_manager.register_boolean("Custom Arraylist", "Suffix", true)
module_manager.register_boolean("Custom Arraylist", "All Blink", false)
    --indacotor
module_manager.register("Blink Info" , info)

player.message("/language english")
