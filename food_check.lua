
-- Checks if we should allow feednode and feedpack
if medblocks.hunger_installed == false and minetest.get_modpath("stamina") then
    medblocks.hunger_installed = true
end

if medblocks.hunger_installed == false and minetest.get_modpath("hunger_ng") then
    medblocks.hunger_installed = true
end

if medblocks.hunger_installed == false and minetest.get_modpath("hudbars") then
    medblocks.hunger_installed = true
end

if medblocks.hunger_installed == false and minetest.get_modpath("hbhunger") then
    medblocks.hunger_installed = true
end

if medblocks.hunger_installed == true then
    minetest.register_craftitem("medblocks:feeding", {
        description = "Feeding",
        inventory_image = "medblocks_empty.png",
        -- minetest.do_item_eat causes a graphical "crumbs" effect,
        -- I didn't want that so I'm using a empty/transucent image.
        groups = {not_in_creative_inventory = 1}, -- Don't show this in the list of items (you really don't want this item)
        on_use = minetest.item_eat(1)
    })
    -- Just in case some moron gave themselves this item, allow it to be garbage.
    minetest.register_craft({
        type = "fuel",
        recipe = "medblocks:feeding",
        burntime = 1
    })
end

