
local update = function (pos, elapsed)
    local meta = minetest.get_meta(pos)
    local open = meta:get_int("open")
    local owner = meta:get_string("owner")
    local names = meta:get_string("names")
    -- Collect all entities within range
    local objs = minetest.get_objects_inside_radius(pos, medblocks.settings.mednode.range or 1.0)
    for _, obj in ipairs(objs) do
        -- Only target players
        if obj:is_player() then
            local pname = obj:get_player_name()
            if medblocks.settings.debug_mode == true then
                minetest.log("action", "[medblocks] Mednode "..pname)
            end
            -- Process special things
            if open == 0 and pname == owner then
                -- Only U (owner only)
                local hp = obj:get_hp()
                obj:set_hp(hp+(medblocks.settings.mednode.healing or 1.0), {type="set_hp", from="mod"})
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
                    local hp = obj:get_hp()
                    obj:set_hp(hp+(medblocks.settings.mednode.healing or 1.0), {type="set_hp", from="mod"})
                end
            else
                -- Public (everyone)
                local hp = obj:get_hp()
                obj:set_hp(hp+(medblocks.settings.mednode.healing or 1.0), {type="set_hp", from="mod"})
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

minetest.register_node("medblocks:mednode", {
    short_description = "Mednode",
    description = "Mednode\nHealing: +"..tostring(medblocks.settings.mednode.healing/2).."H/s\nRange: "..tostring(medblocks.settings.mednode.range).."\nHeals every second.",
    tiles = {"medblocks_mednode.png"},
    on_timer = update,
    drop = "medblocks:mednode",
    groups = {oddly_breakable_by_hand = 1, handy = 1},
    on_construct = function (pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("infotext", "Mednode")
        meta:set_int("open", 0)
        meta:set_string("names", "")
        meta:set_string("formspec", get_formspec(pos))
    end,
    after_place_node = function (pos, placer, itemstack)
        local meta = minetest.get_meta(pos)
        local pname = placer:get_player_name()
        meta:set_string("infotext", "Mednode ("..pname..")")
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
