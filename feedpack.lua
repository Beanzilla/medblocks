
minetest.register_craftitem("medblocks:feedpack", {
    short_description = "Feedpack",
    description = "Feedpack\nFeeding: +"..tostring(medblocks.settings.feedpack.feeding/2).."H/s\nFeeds every 3 seconds.",
    stack_max = 1, -- Don't allow stacking (Everything must have downsides)
    inventory_image = "medblocks_feedpack.png"
})

-- Use a global step of 3 seconds so Mednode is better but the Medpack can keep someone alive too
local interval = 0
minetest.register_globalstep(function (dtime)
    interval = interval - dtime
    local food_mod = nil
    if medblocks.hunger_installed == "stamina" then
        food_mod = rawget(_G, "stamina")
    elseif medblocks.hunger_installed == "hbhunger" then
        food_mod = rawget(_G, "hbhunger")
    end
    if interval <= 0 then
        -- Ok, 3 seconds are up, let's check players for medpacks and add up their total healing to apply to players
        for _, player in ipairs(minetest.get_connected_players()) do
            local inv = player:get_inventory()
            -- Quick check to ensure they do have a medpack (possibly more)
            if inv:contains_item("main", "medblocks:feedpack") then
                -- Count the number of medpacks on them
                local packs_found = 0
                for slot, stack in ipairs(inv:get_list("main")) do
                    if stack:get_name() == "medblocks:feedpack" then
                        packs_found = packs_found + 1
                    end
                end
                -- Ok, assuming it's at least 1, let's add the total up
                local feeding = medblocks.settings.feedpack.feeding * packs_found
                if medblocks.settings.debug_mode == true then
                    minetest.log("action", "[medblocks] Feedpack "..player:get_player_name().." x "..tostring(packs_found))
                end
                --minetest.do_item_eat(feeding, nil, ItemStack("medblocks:feeding"), player, player:get_pos())
                if food_mod ~= nil then
                    -- Stamina Mod
                    if food_mod.change_saturation ~= nil then
                        food_mod.change_saturation(player:get_player_name(), feeding)
                    end
                    if food_mod.change ~= nil then
                        food_mod.change(player:get_player_name(), feeding)
                    end
                    -- HBHunger Mod
                    if food_mod.hunger ~= nil then
                        food_mod.hunger[pname] = food_mod.get_hunger_raw(player) + feeding + 1
                        food_mod.set_hunger_raw(player)
                    end
                end
                -- Done with them, next!
            end
        end
        interval = 3.0
    end
end)
