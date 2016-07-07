-- ********************************************************************************************************************
-- Aliases
-- ********************************************************************************************************************
minetest.register_alias("wine_red_trunk", "stimulants:wine_red_trunk")
minetest.register_alias("wine_red_grapes", "stimulants:wine_red_grapes")


-- ********************************************************************************************************************
-- Nodes
-- ********************************************************************************************************************
-- --------------------------------------------------------------------------------------------------------------------
-- Red wine
-- --------------------------------------------------------------------------------------------------------------------
minetest.register_node("stimulants:wine_red_trunk", {
	description = "Red Wine Trunk",
	drawtype = "plantlike",
	waving = 0,
	visual_scale = 1.0,
	tiles = {"stimulants_wine_red_trunk.png"},
	inventory_image = "stimulants_wine_red_trunk.png",
	wield_image = "stimulants_wine_red_trunk.png",
	paramtype = "light",
	walkable = true,
	buildable_to = false,
	is_ground_content = false,
	groups = {snappy = 3, flammable = 2, flora = 1, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, 0.5, 0.1},
	},
})

minetest.register_node("stimulants:wine_red_vine", {
	description = "Red Wine Vine",
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 1.0,
	tiles = {"stimulants_wine_red_vine.png"},
	inventory_image = "stimulants_wine_red_vine.png",
	wield_image = "stimulants_wine_red_vine.png",
	paramtype = "light",
	walkable = true,
	buildable_to = false,
	is_ground_content = false,
	groups = {snappy = 3, flammable = 2, flora = 1, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.3, -0.3, 0.3, 0.3, 0.3},
	},
})

minetest.register_node("stimulants:wine_red_vine_grapes", {
	description = "Red Wine Vine with Grapes",
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 1.0,
	tiles = {"stimulants_wine_red_vine_grapes.png"},
	inventory_image = "stimulants_wine_red_vine_grapes.png",
	wield_image = "stimulants_wine_red_vine_grapes.png",
	paramtype = "light",
	walkable = true,
	buildable_to = false,
	is_ground_content = false,
	groups = {snappy = 3, flammable = 2, flora = 1, attached_node = 1},
	drop = {
		max_items = 2,
		items = {
			{items = {'stimulants:wine_red_trunk'}},
			{items = {'stimulants:wine_red_grapes'}},
		},
	},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.3, -0.3, 0.3, 0.3, 0.3},
	},
})


-- ********************************************************************************************************************
-- Craft items and crafting
-- ********************************************************************************************************************
-- --------------------------------------------------------------------------------------------------------------------
-- Red Wine
-- --------------------------------------------------------------------------------------------------------------------
minetest.register_craft({
	type = "fuel",
	recipe = "stimulants:wine_red_trunk",
	burntime = 3,
})

minetest.register_craft({
	type = "fuel",
	recipe = "stimulants:wine_red_vine",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "stimulants:wine_red_vine_grapes",
	burntime = 1,
})

minetest.register_craftitem("stimulants:wine_red_grapes", {
	description = "Red Grapes",
	inventory_image = "stimulants_wine_red_grapes.png",
	on_use = minetest.item_eat(1)
}) 


-- ********************************************************************************************************************
-- Growing
-- ********************************************************************************************************************
-- --------------------------------------------------------------------------------------------------------------------
-- Red wine
-- --------------------------------------------------------------------------------------------------------------------
minetest.register_abm({
	nodenames = {"stimulants:wine_red_trunk"},
	neighbors = {"default:dirt", "default:dirt_with_grass", "stimulants:plant_tub_dirt"},
	interval = 30,
	chance = 20,
	action = function(pos, node)
		pos.y = pos.y - 1
		local name = minetest.get_node(pos).name
		if name == "default:dirt" or name == "default:dirt_with_grass" or name == "stimulants:plant_tub_dirt" then
			pos.y = pos.y + 2
			if minetest.get_node(pos).name == "air" then
				minetest.set_node(pos, {name="stimulants:wine_red_vine"})
			end
		end
	end,
})

minetest.register_abm({
	nodenames = {"stimulants:wine_red_vine"},
	neighbors = {"stimulants:wine_red_trunk"},
	interval = 30,
	chance = 20,
	action = function(pos, node)
		pos.y = pos.y - 1
		local name = minetest.get_node(pos).name
		if name == "stimulants:wine_red_trunk" then 
			pos.y = pos.y + 1
			minetest.set_node(pos, {name="stimulants:wine_red_vine_grapes"})
		end
	end,
})


-- ********************************************************************************************************************
-- Initial generation
-- ********************************************************************************************************************
-- --------------------------------------------------------------------------------------------------------------------
-- Red wine
-- --------------------------------------------------------------------------------------------------------------------
minetest.register_on_generated(function(minp, maxp, seed)

	local rand_number = seed * 123
	local rand_x = seed * 456
	local rand_z = seed * 789
	local trial_total = 0
	local surface_y = 0
	local surface_found = false
	local dirt_neighbour_found = false
	local plant_set = false
	local check_node_pos = {x = minp.x + math.fmod(rand_x, 80), y = maxp.y , z = minp.z + math.fmod(rand_z, 80)}	-- Start somewhere

	for plant_no = 0, math.fmod(rand_number, 20), 1 do
		for trial = 0, 10, 1 do

			-- Calculating the next potential plant pos
			trial_total = trial_total + 1
			if math.fmod(trial_total, 4) ~= 0 then
				check_node_pos.x = check_node_pos.x + 2
			else
				check_node_pos.x = check_node_pos.x - 6
				check_node_pos.z = check_node_pos.z + 2
			end

			local check_node_name = minetest.get_node(check_node_pos).name
			if check_node_name == "air" then

				-- Searching the surface node
				surface_found = false
				surface_y = 0
				for y = maxp.y, minp.y, -1 do
						check_node_pos.y = y
						check_node_name = minetest.get_node(check_node_pos).name
						if check_node_name ~= "air" then
							surface_y = y
							surface_found = true
							break -- Height loop
						end
				end

				if surface_found then
					-- Check growing conditions
					if check_node_name == "default:dirt_with_grass" then

						-- Looking for a higher neighbour node (step in the direct neighbourhood)
						dirt_neighbour_found = false
						for x_neighbour = -1, 1, 1 do
							for z_neighbour = -1, 1, 1 do
								neighbour_node_pos = check_node_pos
								neighbour_node_pos.x = neighbour_node_pos.x + x_neighbour
								neighbour_node_pos.y = neighbour_node_pos.y + 1
								neighbour_node_pos.z = neighbour_node_pos.z + z_neighbour
								if minetest.get_node(neighbour_node_pos).name == "default:dirt_with_grass" or minetest.get_node(neighbour_node_pos).name == "default:dirt" then
									dirt_neighbour_found = true
								end
							end
						end
						if dirt_neighbour_found then
							-- Set plant
							check_node_pos.y = surface_y + 1
							minetest.set_node(check_node_pos, {name = "stimulants:wine_red_trunk"})
							check_node_pos.y = surface_y + 2
							minetest.set_node(check_node_pos, {name = "stimulants:wine_red_vine_grapes"})
							break -- Trial loop
						end
					end
				end
			end
		end
	end

end)
