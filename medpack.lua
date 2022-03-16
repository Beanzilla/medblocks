
minetest.register_craftitem("medblocks:medpack", {
    short_description = "Medpack",
    description = "Medpack\nHealing: +"..tostring(medblocks.settings.medpack.healing/2).."H/s\nHeals every 3 seconds.",
    stack_max = 1, -- Don't allow stacking (Everything must have downsides)
    inventory_image = "medblocks_medpack.png"
})

-- Use a global step of 3 seconds so Mednode is better but the Medpack can keep someone alive too
local interval = 0
minetest.register_globalstep(function (dtime)
    interval = interval - dtime
    if interval <= 0 then
        -- Ok, 3 seconds are up, let's check players for medpacks and add up their total healing to apply to players
        for _, player in ipairs(minetest.get_connected_players()) do
            local pname = player:get_player_name()
            local inv = player:get_inventory()
            -- Quick check to ensure they do have a medpack (possibly more)
            if inv:contains_item("main", "medblocks:medpack") then
                -- Count the number of medpacks on them
                local packs_found = 0
                for slot, stack in ipairs(inv:get_list("main")) do
                    if stack:get_name() == "medblocks:medpack" then
                        packs_found = packs_found + 1
                    end
                end
                -- Ok, assuming it's at least 1, let's add the total up
                local healing = medblocks.settings.medpack.healing * packs_found
                if medblocks.settings.debug_mode == true then
                    minetest.log("action", "[medblocks] Medpack "..pname.." x "..tostring(packs_found))
                end
                local hp = player:get_hp()
                player:set_hp(hp+healing, {type="set_hp", from="mod"})
                -- Done with them, next!
            end
        end
        interval = 3.0
    end
end)
