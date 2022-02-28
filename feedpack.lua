
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
                minetest.do_item_eat(feeding, nil, nil, player, nil)
                -- Done with them, next!
            end
        end
        interval = 3.0
    end
end)
