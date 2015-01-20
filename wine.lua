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
	waving = 1,
	visual_scale = 1.0,
	tiles = {"stimulants_wine_red_trunk.png"},
	inventory_image = "stimulants_wine_red_trunk.png",
	wield_image = "stimulants_wine_red_trunk.png",
	paramtype = "light",
	walkable = true,
	buildable_to = false,
	is_ground_content = true,
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
--[[
minetest.register_on_generated(function(minp, maxp, seed)

end)
--]]
