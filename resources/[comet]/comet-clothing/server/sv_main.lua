SQL, Callback, Player = nil, nil, nil

AddEventHandler("comet-base:refreshComponents", function()
    exports['comet-base']:LoadComponents({
        "SQL",
        "Callback",
        "Player",
    }, function(pass)
        if not pass then return end
        SQL = exports['comet-base']:FetchComponent("SQL")
        Callback = exports['comet-base']:FetchComponent("Callback")
        Player = exports['comet-base']:FetchComponent("Player")
    end)
end)


local function checkExistenceClothes(cid, cb)
    exports.oxmysql:execute("SELECT charid FROM character_current WHERE cid = @cid LIMIT 1;", {["cid"] = cid}, function(result)
        local exists = result and result[1] and true or false
        cb(exists)
    end)
end

local function checkExistenceFace(cid, cb)
    exports.oxmysql:execute("SELECT charid FROM character_face WHERE cid = @cid LIMIT 1;", {["cid"] = cid}, function(result)
        local exists = result and result[1] and true or false
        cb(exists)
    end)
end

RegisterServerEvent("comet-clothing:insert_character_current")
AddEventHandler("comet-clothing:insert_character_current",function(data)
    if not data then return end
    local src = source
    local Player = Player.GetBySource(src)
    local characterId = Player.PlayerData.cid
    if not characterId then return end
    checkExistenceClothes(characterId, function(exists)
        local values = {
            ["@cid"] = characterId,
            ["charid"] = Player.PlayerData.charid,
            ["model"] = json.encode(data.model),
            ["drawables"] = json.encode(data.drawables),
            ["props"] = json.encode(data.props),
            ["drawtextures"] = json.encode(data.drawtextures),
            ["proptextures"] = json.encode(data.proptextures),
        }

        if not exists then
            local cols = "cid, charid, model, drawables, props, drawtextures, proptextures"
            local vals = "@cid, @charid, @model, @drawables, @props, @drawtextures, @proptextures"

            exports.oxmysql:execute("INSERT INTO character_current ("..cols..") VALUES ("..vals..")", values, function()
            end)
            return
        end

        local set = "model = @model,drawables = @drawables,props = @props,drawtextures = @drawtextures,proptextures = @proptextures"
        exports.oxmysql:execute("UPDATE character_current SET "..set.." WHERE cid = @cid", values)
    end)
end)

RegisterServerEvent("comet-clothing:insert_character_face")
AddEventHandler("comet-clothing:insert_character_face",function(data)
    if not data then return end
    local src = source

    local Player = Player.GetBySource(src)
    local characterId = Player.PlayerData.cid

    if not characterId then return end

    checkExistenceFace(characterId, function(exists)
        if data.headBlend == "null" or data.headBlend == nil then
            data.headBlend = '[]'
        else
            data.headBlend = json.encode(data.headBlend)
        end
        local values = {
            ["@cid"] = characterId,
            ["charid"] = Player.PlayerData.charid,
            ["hairColor"] = json.encode(data.hairColor),
            ["headBlend"] = data.headBlend,
            ["headOverlay"] = json.encode(data.headOverlay),
            ["headStructure"] = json.encode(data.headStructure),
        }

        if not exists then
            local cols = "charid, cid, hairColor, headBlend, headOverlay, headStructure"
            local vals = "@charid, @cid, @hairColor, @headBlend, @headOverlay, @headStructure"

            exports.oxmysql:execute("INSERT INTO character_face ("..cols..") VALUES ("..vals..")", values, function()
            end)
            return
        end

        local set = "hairColor = @hairColor,headBlend = @headBlend, headOverlay = @headOverlay,headStructure = @headStructure"
        exports.oxmysql:execute("UPDATE character_face SET "..set.." WHERE cid = @cid", values )
    end)
end)

RegisterServerEvent("comet-clothing:get_character_face")
AddEventHandler("comet-clothing:get_character_face",function(pSrc)
    local src = (not pSrc and source or pSrc)
    local Player = Player.GetBySource(src)
    local characterId = Player.PlayerData.cid

    if not characterId then return end

    exports.oxmysql:execute("SELECT cc.model, cf.hairColor, cf.headBlend, cf.headOverlay, cf.headStructure FROM character_face cf INNER JOIN character_current cc on cc.cid = cf.cid WHERE cf.cid = @cid", {['cid'] = characterId}, function(result)
        if (result ~= nil and result[1] ~= nil) then
            local temp_data = {
                hairColor = json.decode(result[1].hairColor),
                headBlend = json.decode(result[1].headBlend),
                headOverlay = json.decode(result[1].headOverlay),
                headStructure = json.decode(result[1].headStructure),
            }
            local model = tonumber(result[1].model)
            if model == 1885233650 or model == -1667301416 then
                TriggerClientEvent("comet-clothing:setpedfeatures", src, temp_data)
            end
        else
            TriggerClientEvent("comet-clothing:setpedfeatures", src, false)
        end
	end)
end)

RegisterServerEvent("comet-clothing:get_character_current")
AddEventHandler("comet-clothing:get_character_current",function(pSrc)
    local src = (not pSrc and source or pSrc)
    local Player = Player.GetBySource(src)
    local characterId = Player.PlayerData.cid

    if not characterId then return end

    exports.oxmysql:execute("SELECT * FROM character_current WHERE charid = @charid AND cid = @cid", {['charid'] = Player.PlayerData.charid, ['cid'] = characterId}, function(result)
        local temp_data = {
            model = result[1].model,
            drawables = json.decode(result[1].drawables),
            props = json.decode(result[1].props),
            drawtextures = json.decode(result[1].drawtextures),
            proptextures = json.decode(result[1].proptextures),
        }
        TriggerClientEvent("comet-clothing:setclothes", src, temp_data,0)
	end)
end)

RegisterServerEvent("comet-clothing:retrieve_tats")
AddEventHandler("comet-clothing:retrieve_tats", function(pSrc)
    local src = (not pSrc and source or pSrc)
	local Player = Player.GetBySource(src)
    local char = Player.PlayerData
	exports.oxmysql:execute("SELECT * FROM character_tattoos  WHERE cid = @cid AND charid = @charid", {['cid'] = char.cid,['charid'] = char.charid}, function(result)
        if(#result == 1) then
			TriggerClientEvent("comet-clothing:settattoos", src, json.decode(result[1].tattoos))
		else
			local tattooValue = "{}"
			exports.oxmysql:execute("INSERT INTO character_tattoos (charid, cid, tattoos) VALUES (@identifier, @cid, @tattoo)", {['identifier'] = char.charid, ['cid'] = char.cid, ['tattoo'] = tattooValue})
			TriggerClientEvent("comet-clothing:settattoos", src, {})
		end
	end)
end)

RegisterServerEvent("comet-clothing:set_tats")
AddEventHandler("comet-clothing:set_tats", function(tattoosList)
	local src = source
	local Player = Player.GetBySource(src)
    local char = Player.PlayerData
	exports.oxmysql:execute("UPDATE character_tattoos SET tattoos = @tattoos  WHERE cid = @cid AND charid = @charid", {
        ['tattoos'] = json.encode(tattoosList), 
        ['cid'] = char.cid,
        ['charid'] = char.charid
    })
end)


RegisterServerEvent("comet-clothing:get_outfit")
AddEventHandler("comet-clothing:get_outfit",function(slot)
    if not slot then return end
    local src = source

    local Player = Player.GetBySource(src)
    local characterId = Player.PlayerData.cid

    if not characterId then return end

    exports.oxmysql:execute("SELECT * FROM character_outfits WHERE cid = @cid and slot = @slot", {
        ['cid'] = characterId,
        ['slot'] = slot
    }, function(result)
        if result and result[1] then
            if result[1].model == nil then
                TriggerClientEvent("DoLongHudText", src, "Can not use.",2)
                return
            end

            local data = {
                model = result[1].model,
                drawables = json.decode(result[1].drawables),
                props = json.decode(result[1].props),
                drawtextures = json.decode(result[1].drawtextures),
                proptextures = json.decode(result[1].proptextures),
                hairColor = json.decode(result[1].hairColor)
            }

            TriggerClientEvent("comet-clothing:setclothes", src, data,0)

            local values = {
                ["cid"] = characterId,
                ["model"] = data.model,
                ["drawables"] = json.encode(data.drawables),
                ["props"] = json.encode(data.props),
                ["drawtextures"] = json.encode(data.drawtextures),
                ["proptextures"] = json.encode(data.proptextures),
            }

            local set = "model = @model, drawables = @drawables, props = @props,drawtextures = @drawtextures,proptextures = @proptextures"
            exports.oxmysql:execute("UPDATE character_current SET "..set.." WHERE cid = @cid",values)
        else
            TriggerClientEvent("DoLongHudText", src, "No outfit on slot " .. slot,2)
            return
        end
	end)
end)

RegisterServerEvent("comet-clothing:set_outfit")
AddEventHandler("comet-clothing:set_outfit",function(slot, name, data)
    if not slot then return end
    local src = source
    local Player = Player.GetBySource(src)
    local characterId = Player.PlayerData.cid

    if not characterId then return end

    exports.oxmysql:execute("SELECT slot FROM character_outfits WHERE cid = @cid and slot = @slot", {
        ['cid'] = characterId,
        ['slot'] = slot
    }, function(result)
        if result and result[1] then
            local values = {
                ["cid"] = characterId,
                ["slot"] = slot,
                ["name"] = name,
                ["model"] = json.encode(data.model),
                ["drawables"] = json.encode(data.drawables),
                ["props"] = json.encode(data.props),
                ["drawtextures"] = json.encode(data.drawtextures),
                ["proptextures"] = json.encode(data.proptextures),
                ["hairColor"] = json.encode(data.hairColor),
            }

            local set = "model = @model,name = @name,drawables = @drawables,props = @props,drawtextures = @drawtextures,proptextures = @proptextures,hairColor = @hairColor"
            exports.oxmysql:execute("UPDATE character_outfits SET "..set.." WHERE cid = @cid and slot = @slot and name = @name",values)
        else
            local cols = "cid, model, name, slot, drawables, props, drawtextures, proptextures, hairColor"
            local vals = "@cid, @model, @name, @slot, @drawables, @props, @drawtextures, @proptextures, @hairColor"

            local values = {
                ["cid"] = characterId,
                ["name"] = name,
                ["slot"] = slot,
                ["model"] = data.model,
                ["drawables"] = json.encode(data.drawables),
                ["props"] = json.encode(data.props),
                ["drawtextures"] = json.encode(data.drawtextures),
                ["proptextures"] = json.encode(data.proptextures),
                ["hairColor"] = json.encode(data.hairColor)
            }

            exports.oxmysql:execute("INSERT INTO character_outfits ("..cols..") VALUES ("..vals..")", values, function()
                TriggerClientEvent("DoLongHudText", src, name .. " stored in slot " .. slot,1)
            end)
        end
	end)
end)


RegisterServerEvent("comet-clothing:remove_outfit")
AddEventHandler("comet-clothing:remove_outfit",function(slot)

    local src = source
    local Player = Player.GetBySource(src)
    local cid = Player.PlayerData.cid
    local slot = slot

    if not cid then return end

    exports.oxmysql:execute( "DELETE FROM character_outfits WHERE cid = @cid AND slot = @slot", { ['cid'] = cid,  ["slot"] = slot } )
    TriggerClientEvent("DoLongHudText", src,"Removed slot " .. slot .. ".",1)
end)

RegisterServerEvent("comet-clothing:list_outfits")
AddEventHandler("comet-clothing:list_outfits",function()
    local src = source
    local Player = Player.GetBySource(src)
    local cid = Player.PlayerData.cid
    local slot = slot
    local name = name

    if not cid then return end

    exports.oxmysql:execute("SELECT slot, name FROM character_outfits WHERE cid = @cid", {['cid'] = cid}, function(skincheck)
    	TriggerClientEvent("comet-clothing:ListOutfits",src, skincheck)
	end)
end)


RegisterServerEvent("clothing:checkIfNew")
AddEventHandler("clothing:checkIfNew", function()
    local src = source
    local Player = Player.GetBySource(src)
    local cid = Player.PlayerData.cid

    exports.oxmysql:scalar("SELECT count(model) FROM character_current WHERE cid = @cid LIMIT 1", {['cid'] = cid}, function(result)
        if result == 0 then
            exports.oxmysql:execute("select count(cid) assExist from (select cid  from character_current union select cid from characters_clothes) a where cid =  @cid", {['cid'] = cid}, function(clothingCheck)
                local existsClothing = clothingCheck[1].assExist
                TriggerClientEvent('comet-clothing:setclothes',src,{},existsClothing)
            end)
            return
        else
            TriggerEvent("comet-clothing:get_character_current", src)
        end
    end)
end)

-- RegisterCommand("outfits", function(source,args,raw)
--     TriggerClientEvent("hotel:outfit", source)
-- end)