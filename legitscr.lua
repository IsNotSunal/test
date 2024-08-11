local receive_vel = false
local ticks = 0

local set_module_state = function(mod, state)
    if module_manager.is_module_on(mod) ~= state then
        player.message("." .. mod)
    end
end

local hide_module_state = function (mod , state)
    if state == false then
        player.message(".show " .. mod)
    else
        player.message(".hide " .. mod)
    end
end

local isMoving = function()
    if input.is_key_down(17) or input.is_key_down(30) or input.is_key_down(31) or input.is_key_down(32) then
        return true
    else
        return false
    end
end

local vel = {
    on_pre_update = function (e)
        if receive_vel then
            ticks = ticks + 1
            if ticks == 1 then
                if player.on_ground() then
                    player.jump()
                end
                receive_vel = false
                ticks = 0
            end
        end

    end,

    on_receive_packet = function (e)
        if e.packet_id == 0x12 and e.entity_id == player.id() and player.on_ground() and e.motion_y > 0 then
            receive_vel = true
        end
    end
}

local legitaura = {
    on_enable = function ()
        hide_module_state("killaura" , true)
    end,

    on_disable = function ()
        hide_module_state("killaura" , false)
    end,

    on_pre_update = function (e)
        if client.gui_name() == "chat" or client.gui_name() == "astolfo" or client.gui_name() == "inventory" or client.gui_name() == "chest" then
            return
        end

        if input.is_mouse_down(0) then
            set_module_state("killaura" , true)
        else
            set_module_state("killaura" , false)
        end
    end
}


module_manager.register("Jump Reset" , vel)

module_manager.register("Legit Aura" , legitaura)