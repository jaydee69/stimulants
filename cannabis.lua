-- ********************************************************************************************************************
-- Aliases
-- ********************************************************************************************************************
minetest.register_alias("wild_hemp", "stimulants:wild_hemp")
minetest.register_alias("wild_hemp_male", "stimulants:wild_hemp_male")
minetest.register_alias("cannabis", "stimulants:cannabis")
minetest.register_alias("cannabis_seed", "stimulants:seed_cannabis")
minetest.register_alias("marihuana", "stimulants:marihuana")
minetest.register_alias("dope", "stimulants:marihuana")
minetest.register_alias("grass", "stimulants:marihuana")
minetest.register_alias("smoking_paper", "stimulants:smoking_paper")
minetest.register_alias("joint", "stimulants:joint")
minetest.register_alias("hash_cookie_paste", "stimulants:hash_cookie_paste")
minetest.register_alias("hash_cookie", "stimulants:hash_cookie")


-- ********************************************************************************************************************
-- Nodes
-- ********************************************************************************************************************
-- --------------------------------------------------------------------------------------------------------------------
-- Wild hemp for getting cannabis seeds (male or female)
-- --------------------------------------------------------------------------------------------------------------------
minetest.register_node("stimulants:wild_hemp", {
	description = "Wild Hemp",
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 1,
	tiles = {"stimulants_cannabis_8.png"},
	inventory_image = "stimulants_cannabis_8.png",
	wield_image = "stimulants_cannabis_8.png",
	paramtype = "light",
	walkable = false,
	buildable_to = true,
	is_ground_content = true,
	groups = {snappy = 3, flammable = 2, flora = 1, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
	drop = {
		max_items = 1,
		items = {
			{items = {'stimulants:seed_cannabis'}, rarity = 2},
			{items = {'stimulants:wild_hemp_male'}},
		},
	},
})

-- --------------------------------------------------------------------------------------------------------------------
-- Wild male hemp. Can be used for decoration or as fuel
-- --------------------------------------------------------------------------------------------------------------------
minetest.register_node("stimulants:wild_hemp_male", {
	description = "Wild Hemp (male)",
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 1,
	tiles = {"stimulants_cannabis_7.png"},
	inventory_image = "stimulants_cannabis_7.png",
	wield_image = "stimulants_cannabis_7.png",
	paramtype = "light",
	walkable = false,
	buildable_to = true,
	is_ground_content = true,
	groups = {snappy = 3, flammable = 2, flora = 1, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
})

-- ********************************************************************************************************************
-- Plants
-- ********************************************************************************************************************
-- --------------------------------------------------------------------------------------------------------------------
-- Generate agricultural cannabis plant
-- --------------------------------------------------------------------------------------------------------------------
farming.register_plant("stimulants:cannabis", {
	description = "Cannabis Seed",
	inventory_image = "stimulants_cannabis_seed.png",
	steps = 8,
	minlight = 13,
	maxlight = LIGHT_MAX,
	fertility = {"grassland"}
})


-- ********************************************************************************************************************
-- Craft items and crafting
-- ********************************************************************************************************************
-- --------------------------------------------------------------------------------------------------------------------
-- Wild hemp
-- --------------------------------------------------------------------------------------------------------------------
minetest.register_craft({
	type = "fuel",
	recipe = "stimulants:wild_hemp",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "stimulants:wild_hemp_male",
	burntime = 1,
})

-- --------------------------------------------------------------------------------------------------------------------
-- Cannabis
-- --------------------------------------------------------------------------------------------------------------------
minetest.register_craft({
	type = "fuel",
	recipe = "stimulants:cannabis",
	burntime = 1,
})

-- --------------------------------------------------------------------------------------------------------------------
-- Grass (Marihuana)
-- --------------------------------------------------------------------------------------------------------------------
minetest.register_craftitem("stimulants:marihuana", {
	description = "Marihuana",
	inventory_image = "stimulants_cannabis_marihuana.png",
}) 

minetest.register_craft({
	type = "shapeless",
	output = 'stimulants:marihuana 3',
	recipe = {'stimulants:cannabis'}
})

minetest.register_craft({
	type = "shapeless",
	output = 'stimulants:marihuana 1',
	recipe = {'stimulants:wild_hemp'}
})

minetest.register_craft({
	type = "fuel",
	recipe = "stimulants:marihuana",
	burntime = 1,
})

-- --------------------------------------------------------------------------------------------------------------------
-- Smoking Paper
-- --------------------------------------------------------------------------------------------------------------------
minetest.register_craftitem("stimulants:smoking_paper", {
	description = "Smoking Paper",
	inventory_image = "stimulants_smoking_paper.png",
}) 

minetest.register_craft({
	type = "shapeless",
	output = 'stimulants:smoking_paper 3',
	recipe = {'default:paper'}
})

-- --------------------------------------------------------------------------------------------------------------------
-- Joint
-- --------------------------------------------------------------------------------------------------------------------
minetest.register_craftitem("stimulants:joint", {
	description = "Joint",
	inventory_image = "stimulants_cannabis_joint.png",
	on_use = minetest.item_eat(-3)	-- Removing 1.5 hearts. Smoking is bad for health!
}) 

minetest.register_craft({
	output = 'stimulants:joint 3',
	recipe = {
		{'stimulants:smoking_paper', 'stimulants:smoking_paper', 'stimulants:smoking_paper'},
		{'stimulants:marihuana', 'stimulants:marihuana', 'stimulants:marihuana'},
		{'stimulants:smoking_paper', 'stimulants:smoking_paper', 'stimulants:smoking_paper'},
	}
})

-- --------------------------------------------------------------------------------------------------------------------
-- Hash cookies
-- --------------------------------------------------------------------------------------------------------------------
minetest.register_craftitem("stimulants:hash_cookie_paste", {
	description = "Hash Cookies Paste",
	inventory_image = "stimulants_cannabis_hash_cookie_paste.png",
}) 

minetest.register_craft({
	output = 'stimulants:hash_cookie_paste 1',
	recipe = {
		{'farming:flour', 'farming:flour', 'farming:flour'},
		{'farming:flour', 'stimulants:cannabis', 'farming:flour'},
		{'farming:flour', 'farming:flour', 'farming:flour'},
	}
})

minetest.register_craftitem("stimulants:hash_cookie", {
	description = "Hash Cookies",
	inventory_image = "stimulants_cannabis_hash_cookie.png",
	on_use = minetest.item_eat(1)	-- Healing 0.5 hearts!
}) 

minetest.register_craft({
	type = "cooking",
	recipe = "stimulants:hash_cookie_paste",
	cooktime = 20,
	output = "stimulants:hash_cookie 8",
})


-- ********************************************************************************************************************
-- Misc
-- ********************************************************************************************************************
-- --------------------------------------------------------------------------------------------------------------------
-- Generating wild hemp on dirt with grass close to sand or dessert sand for getting cannabis seeds
-- --------------------------------------------------------------------------------------------------------------------
minetest.register_on_generated(function(minp, maxp, seed)
	-- Init
	local surface_y = 0
	local surface_found = false
	local check_node_pos = {x = minp.x + 40, y = maxp.y , z = minp.z + 40}	-- Horizontal centre of the area to be generated

	-- Canceling operation, if by some reason check_node_pos.y is not air
	local check_node_name = minetest.get_node(check_node_pos).name
	if check_node_name ~= "air" then
		return
	end

	-- Searching the surface node
	for y = maxp.y, minp.y, -1 do
		check_node_pos.y = y
		check_node_name = minetest.get_node(check_node_pos).name
		if check_node_name ~= "air" then
			surface_y = y
			surface_found = true
			break
		end
	end

	-- Canceling operation, if by some reason the surface could not be found
	if not surface_found then
		return
	end

	-- Check growing conditions and set plant
	if check_node_name == "default:dirt_with_grass" then
		local find_node_pos = check_node_pos	-- find_node_pos might be modified by find_node_near -> TODO: To be falsified, hopefully
		if minetest.find_node_near(find_node_pos, 30, {"default:desert_sand", "default:sand"}) ~= nil then
			check_node_pos.y = surface_y + 1
			minetest.set_node(check_node_pos, {name = "stimulants:wild_hemp"})
		end
	end

end)

