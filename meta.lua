---@meta
module_manager = {
	---@param name string
	---@param module table
	register = function(name, module)
	end,
	---@param module_name string
	---@param option_name string
	---@param default_value boolean
	register_boolean = function(module_name, option_name, default_value)
	end,
	---@param module_name string
	---@param option_name string
	option = function(module_name, option_name, ...)
	end,
	---@param module_name string
	---@param module_option string
	---@return string , boolean
	set_option = function(module_name, module_option, ...)
	end,
	---@param module_name string
	---@param option_name string
	---@param min_value integer
	---@param max_value integer
	---@param current_value integer
	register_number = function(module_name, option_name, min_value, max_value, current_value)
	end,
	---@param module_name string
	is_module_on = function(module_name)
	end
}
player = {
	use_item = function()
	end,
	inventory = {
		---@param slot_id number
		---@return string, string, number, number, table
		---Returns item name, display name, item damage, efficiency and a table containung all enchants
		item_information = function(slot_id)
		end,
		---@param slot_id number
		---@param hotbar_slot number
		swap = function(slot_id, hotbar_slot)
		end,
		---@param slot_id number
		---@return string
		slot = function(slot_id)
		end,
		---@param slot_id number
		---@param mouse_click number
		---@param mode number
		click = function(slot_id, mouse_click, mode)
		end,
		---@param slot_id number
		drop = function(slot_id)
		end,
		---@param slot_id number
		---@return number
		get_item_stack = function(slot_id)
		end
	},
	click_mouse = function()
	end,
	---@return boolean
	sprinting = function()
	end,
	---@return number
	fall_distance = function()
	end,
	---@return boolean
	using_item = function()
	end,
	---@param bool boolean
	set_sprinting = function(bool)
	end,
	---@return boolean
	on_ladder = function()
	end,
	---@return number, ...
	---This function will return values depending on the firdst returned number. If the first number is 1, this means your player is not aiming at anything. If the number is 3, this means its aiming at an entity, second number will return the index of that entity 
	---If the number is 2, this means its aiming at a block, will return side_hit, block_x, block_y, block_z, hit_x, hit_y, hit_z
	over_mouse = function()
	end,
	---@return string
	held_item = function()
	end,
	---@return boolean
	is_sneaking = function()
	end,
	---@return number
	food_stats = function()
	end,
	---@return boolean
	is_in_lava = function()
	end,
	---@return number
	ticks_existed = function()
	end,
	---@return boolean
	is_in_cobweb = function()
	end,
	---@param slot_id number
	set_held_item_slot = function(slot_id)
	end,
	---@param x number
	---@param y number
	---@param z number
	---Sets the player motion, the distance the player will travel in a single tick
	set_motion = function(x, y, z)
	end,
	---@return boolean
	collided_horizontally = function()
	end,
	---@return number
	hurt_time = function()
	end,
	---@param yaw number
	---@param pitch number
	set_angles = function(yaw, pitch)
	end,
	---@return boolean
	on_ground = function()
	end,
	---@return number yaw, number pitch
	angles = function()
	end,
	---@param message string
	message = function(message)
	end,
	---@return string
	name = function()
	end,
	---@return number x, number y, number z
	position = function()
	end,
	held_item_slot = function()
	end,
	---@return number
	max_health = function()
	end,
	---@return number
	absorption = function()
	end,
	
	---@return boolean
	riding = function()
	end,
	right_click_mouse = function()
	end,
	---@param x number
	---@param y number
	---@param z number
	set_position = function(x, y, z)
	end,
	---@return number, number, number
	prev_position = function()
	end,
	---@return number yaw, number pitch
	prev_angles = function()
	end,
	---@return boolean
	is_in_water = function()
	end,
	---@param yaw number
	---@param pitch number
	---@param range number
	ray_cast = function(yaw, pitch, range)
	end,
	---@return number
	---This function will return a direction on a number, 1: Down, 2: Up, 3: North, 4: South, 5: West, 6: East
	facing = function()
	end,
	swing_item = function()
	end,
	---@return boolean
	collided_vertically = function()
	end,
	---@param bool boolean
	set_sneaking = function(bool)
	end,
	---@param packet_id number
	---packet IDS can be found here https://wiki.vg/index.php?title=Protocol&oldid=7368#Serverbound_2
	---Packets supported: 0x0A, 0x07, 0x08, 0x0B, 0x03, 0x04, 0x05, 0x06, 0x07, 0x0F
	send_packet = function(packet_id, ...)
	end,
	---@return boolean
	dead = function()
	end,
	---makes the player jump
	jump = function()
	end,
	---@param entity_id number
	distance_to_entity = function(entity_id)
	end,
	---@return number x, number y, number z
	motion = function()
	end,
	---@param potion_id number
	---@return boolean
	is_potion_active = function(potion_id)
	end,
	---@return number
	eye_height = function()
	end,
	---@return number
	health = function()
	end,
	---@param x number
	---@param y number
	---@param z number
	---@return number
	distance_to = function(x,y,z)
	end,
	---@return number
	---returns the entity id of the current killaura target
	kill_aura_target = function()
	end,
	---@return number
	base_speed = function()
	end,
	---@param current_motion table 
	---@param motion number
	convert_speed = function(current_motion, motion)
	end,
	---@return number
	---returns the entity id of the player
	id = function()
	end,
	---@param x number
	---@param y number
	---@param z number
	---@return number yaw, number pitch
	angles_for_cords = function(x,y,z)
	end,
}
render = {
	---@param x number
	---@param y number
	---@param x1 number
	---@param y1 number
	---@param r number
	---@param g number
	---@param b number
	---@param a number
	--creates a rectangle starting from point x,y and ending at point x1,y1
	rect = function(x, y, x1, y1, r, g, b, a)
	end,
	---@param x number
	---@param y number
	---@param x1 number
	---@param y1 number
	---@param size number
	---@param r number
	---@param g number
	---@param b number
	---@param a number
	line = function(x, y, x1, y1, size, r, g, b, a)
	end,
	---@param x number
	---@param y number
	---@param size number
	---@param entity_id number
	player_head = function(x, y, size, entity_id)
	end,
	---@param x number
	---@param y number
	---@param degrees number
	---@param rotation number
	---@param diameter number
	---@param r number 0-255
	---@param g number 0-255
	---@param b number 0-255
	---@param a number 0-255
	circle = function(x, y, degrees, rotation, diameter, r, g, b, a)
	end,
	---@param x number
	---@param y number
	---@param size number
	---@param yaw number
	---@param pitch number
	---@param entity_id number
	player = function(x, y, size, yaw, pitch, entity_id)
	end,
	---@param text string
	---@param x number
	---@param y number
	---@param r number
	---@param g number
	---@param b number
	---@param a number
	string = function(text, x, y, r, g, b, a)
	end,
	---@param text string
	---@param x number
	---@param y number
	---@param r number
	---@param g number
	---@param b number
	---@param a number
	string_shadow = function(text, x, y, r, g, b, a)
	end,
	---@param text string
	---@return number
	get_string_width = function(text)
	end,
	---@param scaling number
	scale = function(scaling)
	end,
	---@param x number
	---@param y number
	---@param z number
	---@return number, number, number
	world_to_screen = function(x, y, z)
	end,
	---@param gui_table table
	show_gui = function(gui_table)
	end,
	---@param url string
	---@param x number
	---@param y number
	---@param width number
	---@param height number
	draw_image = function(url, x, y, width, height)
	end
}
input = {
	---@param key_code number
	---@return boolean
	---Key codes can be found at https://minecraft.fandom.com/el/wiki/Key_codes
	is_key_down = function(key_code)
	end,
	---@param mouse_button number
	---@return boolean
	is_mouse_down = function(mouse_button)
	end,
	---@param key_code number
	---@return string
	get_key_name = function(key_code)
	end,
	---@param key_name string
	---@return number
	get_key_number = function(key_name)
	end,
	---@return number
	---Returns the scrolled amount in mouse wheel
	get_scroll = function()
	end
}
world = {
	---@return number
	timer = function()
	end,
	---@param timer_speed number
	set_timer = function(timer_speed)
	end,
	---Refreshes the loaded chunks, just like F3+A does
	refresh_chunks = function()
	end,
	---@return table number
	---Returns a table with all the loaded entities' IDs
	entities = function()
	end,
	---@param x number
	---@param y number
	---@param z number
	---@return string
	block = function(x,y,z)
	end,
	---@param entity_id number
	---@return string
	name = function(entity_id)
	end,
	---@param entity_id number
	---@return string
	display_name = function(entity_id)
	end,
	---@param entity_id number
	---@return string
	held_item = function(entity_id)
	end,
	---@param entity_id number
	---@return number
	hurt_time = function(entity_id)
	end,
	---@param entity_id number
	---@return number
	health = function(entity_id) 
	end,
	---@param entity_id number
	---@return number
	max_health = function(entity_id)
	end,
	---@param entity_id number
	---@return boolean
	sprinting = function(entity_id)
	end,
	---@param entity_id number
	---@return number
	---This function will return a direction on a number, 1: Down, 2: Up, 3: North, 4: South, 5: West, 6: East
	facing = function(entity_id)
	end,
	---@param entity_id number
	---@return number yaw, number pitch
	angles = function(entity_id)
	end,
	---@param entity_id number
	---@return number min_X, number min_Y, number min_Z, number max_X, number max_Y, number max_Z
	bounding_box = function(entity_id)
	end,
	---@param entity_id number
	---@return boolean
	is_player = function(entity_id)
	end,
	---@param entity_id number
	---@return number, number
	width_height = function(entity_id)
	end,
	---@param entity_id number
	---@return boolean
	is_sneaking = function(entity_id)
	end,
	---@param entity_id number
	---@return boolean
	is_invisible = function(entity_id)
	end,
	---@param entity_id number
	---@return boolean
	burning = function(entity_id)
	end,
	---@param entity_id number
	---@return boolean
	---Returns if the entity is detected as a bot by the client
	is_bot = function(entity_id)
	end,
	---@param entity_id number
	---@return boolean
	is_friend = function(entity_id)
	end,
	---@param entity_id number
	---@return boolean
	is_enemy = function(entity_id)
	end,
	---@param entity_id number
	---@return boolean
	riding = function(entity_id)
	end,
	---@param entity_id number
	---@return number x, number y, number z
	position = function(entity_id)
	end,
	---@param entity_id number
	---@return number x, number y, number z
	prev_position = function(entity_id)
	end,
	---@param entity_id number
	---@param potion_id number
	---@return boolean
	is_potion_active = function(entity_id, potion_id)
	end,
	---@return string
	biome = function()
	end,
	---@return table {helmet, chestplate, leggings, boots, hand}
	inventory = function()
	end,
}
client = {
	---@return string
	gui_name = function()
	end,
	---@return number
	---Returns the system time in milliseconds
	time = function()
	end,
	---@return string name the config name
	config = function()
	end,
	---@param message string
	---Prints the message to chat. NOTE `§` should be written as `\194\167`
	print = function(message)
	end,
	---@return string
	title = function()
	end,
	---@return string
	subtitle = function()
	end,
	---@return string
	chest_name = function()
	end,
	---@return number
	fps = function()
	end,
}
http = {
	---@param url string
	---@return string
	---Makes a request to the url with method GET
	get = function(url)
	end,
	---@param url string
	---@param callback table
	---This method wont hang the game while the request doesnt have a response
	get_async = function(url, callback)
	end,
	---@param url string URL to request to, containing parameters
	---@return string
	---the http api currently does not support the use of headers. Spotify overlay is currently not possible.
	post = function(url)
	end,
	---@param url string
	---@param callback table
	---This method wont hang the game while the request doesnt have a response
	post_async = function(url, callback)
	end,
	---@param url string
	---This method will load the code inside the specified URL into the script context. This is enabled manually ingame with `.script unsafe`
	---```json = (http.load("http://regex.info/code/JSON.lua")())```	
	load = function(url)
	end
}