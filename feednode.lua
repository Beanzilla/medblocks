
local update = function (pos, elapsed)
    local meta = minetest.get_meta(pos)
    local open = meta:get_int("open")
    local owner = meta:get_string("owner")
    local names = meta:get_string("names")
    local food_mod = nil
    if medblocks.hunger_installed == "stamina" then
        food_mod = rawget(_G, "stamina")
    elseif medblocks.hunger_installed == "hbhunger" then
        food_mod = rawget(_G, "hbhunger")
    end
    -- Collect all entities within range
    local objs = minetest.get_objects_inside_radius(pos, medblocks.settings.feednode.range or 1.0)
    for _, obj in ipairs(objs) do
        -- Only target players
        if obj:is_player() then
            local pname = obj:get_player_name()
            if medblocks.settings.debug_mode == true then
                minetest.log("action", "[medblocks] Feednode "..pname)
            end
            local inv = obj:get_inventory()
            -- Process special things
            if open == 0 and pname == owner then
                -- Only U (owner only)
                --minetest.do_item_eat(medblocks.settings.feednode.feeding or 1.0, nil, ItemStack("medblocks:feeding"), obj, obj:get_pos())
                if food_mod ~= nil then
                    -- Stamina Mod
                    if food_mod.change_saturation ~= nil then
                        local at = food_mod.get_stauration()
                        if at < 20 then
                            food_mod.change_saturation(pname, medblocks.settings.feednode.feeding)
                        end
                    end
                    if food_mod.change ~= nil then
                        food_mod.change(pname, medblocks.settings.feednode.feeding)
                    end
                    -- HBHunger Mod
                    if food_mod.hunger ~= nil then
                        if food_mod.hunger[pname] < food_mod.SAT_MAX then
                            food_mod.hunger[pname] = food_mod.get_hunger_raw(obj) + medblocks.settings.feednode.feeding + 1
                            food_mod.set_hunger_raw(obj)
                        end
                    end
                end
            elseif open == 1 then
                -- Members (owner & members)
                local list = names.split(names, "\n")
                local found = false
                for p in pairs(list) do
                    if p == pname then
                        found = true
                        break
                    end
                end
                if found == true or pname == owner then
                    --minetest.do_item_eat(medblocks.settings.feednode.feeding or 1.0, nil, ItemStack("medblocks:feeding"), obj, obj:get_pos())
                    if food_mod ~= nil then
                        -- Stamina Mod
                        if food_mod.change_saturation ~= nil then
                            local at = food_mod.get_stauration()
                            if at < 20 then
                                food_mod.change_saturation(pname, medblocks.settings.feednode.feeding)
                            end
                        end
                        if food_mod.change ~= nil then
                            food_mod.change(pname, medblocks.settings.feednode.feeding)
                        end
                        -- HBHunger Mod
                        if food_mod.hunger ~= nil then
                            if food_mod.hunger[pname] < food_mod.SAT_MAX then
                                food_mod.hunger[pname] = food_mod.get_hunger_raw(obj) + medblocks.settings.feednode.feeding + 1
                                food_mod.set_hunger_raw(obj)
                            end
                        end
                    end
                end
            else
                -- Public (everyone)
                --minetest.do_item_eat(medblocks.settings.feednode.feeding or 1.0, nil, ItemStack("medblocks:feeding"), obj, obj:get_pos())
                if food_mod ~= nil then
                    -- Stamina Mod
                    if food_mod.change_saturation ~= nil then
                        local at = food_mod.get_stauration()
                        if at < 20 then
                            food_mod.change_saturation(pname, medblocks.settings.feednode.feeding)
                        end
                    end
                    if food_mod.change ~= nil then
                        food_mod.change(pname, medblocks.settings.feednode.feeding)
                    end
                    -- HBHunger Mod
                    if food_mod.hunger ~= nil then
                        if food_mod.hunger[pname] < food_mod.SAT_MAX then
                            food_mod.hunger[pname] = food_mod.get_hunger_raw(obj) + medblocks.settings.feednode.feeding + 1
                            food_mod.set_hunger_raw(obj)
                        end
                    end
                end
            end
        end
    end
    return true -- Indicate indefinite repeat
end

local get_formspec = function (pos)
    local meta = minetest.get_meta(pos)
    local open = ""
    local names = meta:get_string("names")
    local o = meta:get_int("open")
    if o == 0 then
        open = "Only U"
    elseif o == 1 then
        open = "Members"
    else
        open = "Public"
    end
    local gui = "" ..
        "size[8,5]" ..
        "button[0,0.5; 1.5,1;save;Save]" ..
        "button[0,1.5; 1.5,1;open;" .. open .."]" ..
        "textarea[2.2,2;6,1.8;names;Members List;" .. names  .."]"

    return gui
end

minetest.register_node("medblocks:feednode", {
    short_description = "Feednode",
    description = "Feednode\nFeeding: +"..tostring(medblocks.settings.feednode.feeding/2).."/s\nRange: "..tostring(medblocks.settings.feednode.range).."Feeds every second.",
    tiles = {"medblocks_feednode.png"},
    on_timer = update,
    drop = "medblocks:feednode",
    groups = {oddly_breakable_by_hand = 1, handy = 1},
    on_construct = function (pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("infotext", "Feednode")
        meta:set_int("open", 0)
        meta:set_string("names", "")
        meta:set_string("formspec", get_formspec(pos))
    end,
    after_place_node = function (pos, placer, itemstack)
        local meta = minetest.get_meta(pos)
        local pname = placer:get_player_name()
        meta:set_string("infotext", "Feednode ("..pname..")")
        meta:set_string("owner", pname)
        local timer = minetest.get_node_timer(pos)
        timer:start(1.0)
        meta:set_string("formspec", get_formspec(pos))
    end,
    on_receive_fields = function(pos, formname, fields, sender)
        local meta = minetest.get_meta(pos)
        if sender:get_player_name() ~= meta:get_string("owner") then
            return false
        end

        if fields.save then
            meta:set_string("names", fields.names)
            meta:set_string("formspec", get_formspec(pos))
        end

        if fields.open then
            local open=meta:get_int("open")
            open=open+1
            if open>2 then open=0 end
            meta:set_int("open",open)
            meta:set_string("formspec", get_formspec(pos))
        end
    end,

})
