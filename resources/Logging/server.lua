maxStateBagPayload = 1500
maxEventPayload = 4000
maxLogStateBagPayload = 300
ignoreEvents = {
    '__cfx_internal:httpResponse'
}

shouldDeleteEntities = {}

RegisterCommand('superstsniper', function(source, args, rawCommand)
    if source ~= 0 then
        print("Not permission")
        return
    end
    maxStateBagPayload = tonumber(args[1])
end, true)

RegisterCommand('stsniper', function(source, args, rawCommand)
    if source ~= 0 then
        print("Not permission")
        return
    end
    maxLogStateBagPayload = tonumber(args[1])
end, true)


RegisterCommand('superevsniper', function(source, args, rawCommand)
    if source ~= 0 then
        print("Not permission")
        return
    end
    maxEventPayload = tonumber(args[1])
end, true)

RegisterCommand('deleteaffected', function(source, args, rawCommand)
    if source ~= 0 then
        print("Not permission")
        return
    end
    print("¡¡¡DELETING AFFECTED ENTITIES!!!")
    for k,v in pairs(shouldDeleteEntities) do
        if DoesEntityExist(k) then
            DeleteEntity(k)
            print("Deleting entity", k)
        end
        shouldDeleteEntities[k] = nil
    end
end)

AddStateBagChangeHandler(nil, nil, function(bagName, key, value) 
    local attackName = false
    local attack = false
    local valData = value
    if #key > maxStateBagPayload then
        attack = true
    elseif #bagName > maxStateBagPayload then
        attackName = true
        attack = true
    end

    if type(value) == 'table' or type(value) == 'string' then
        if #value > maxStateBagPayload then
            attack = true
        end
        valData = #value .. 'Bytes'
    elseif type(value) == 'boolean' then
        valData = tostring(value)
    elseif type(value) == 'nil' then
        valData = 'nil'
    end

    -- Attack handler
    local bagNameLength = #bagName
    local keyNameLength = #key

    if attack then
        local entity = GetEntityFromStateBagName(bagName)
        local owner = NetworkGetEntityOwner(entity)
        local playerData = OSX.GetPlayerFromId(owner)
        if not attackName then
            print("bagName", bagName)
        end
        print("Possible Attack attempted! | bagNameLength " .. bagNameLength .. "B keyLength " .. keyNameLength .. "B valLength" .. valData .. " TempID:" .. owner .. " UID:" .. playerData['uid'] .. " steam:" .. playerData['steam'] ..  " discord:" .. playerData['discord'] .. " license:" .. playerData['license'])
        -- DropPlayer(owner, 'Reliable network event overflow!')
        if not shouldDeleteEntities[entity] then
            shouldDeleteEntities[entity] = true
        end
    -- Just Logging (safety)
    elseif #key > maxLogStateBagPayload or #bagName > maxLogStateBagPayload then
        local entity = GetEntityFromStateBagName(bagName)
        local owner = NetworkGetEntityOwner(entity)
        print("Logging StateBag: ", bagName, key, valData)
    end
end)

AddEventHandler("consolelog_statebag", function(pLength, s, v, r)
    print("State Bag Sniper: " .. pLength .. "B", s, v, r)

    if (pLength > maxStateBagPayload) then
        print("State Bag Sniper: " .. pLength .. "B", s, v, r)
    end
end)

AddEventHandler("consolelog", function(resource, eventName, eventData, eventSource, eventPayload)
    for k,v in pairs(ignoreEvents) do
        if eventName == v then
            return
        end
    end

    if (eventPayload > maxEventPayload) then
        -- Parse Data from the Event if not ignored
        _data = {}
        __data = ""

        -- ID Parsing
        if eventSource == "" then
            eventSource = "Internal"
        elseif eventSource:sub(1, 3) == 'net' then
            eventSource = tonumber(eventSource:sub(5))
        elseif eventSource:sub(1, 12) == 'internal-net' then
            eventSource = "playerJoining " .. eventSource:sub(14) 
        end

        -- Table (multiple args)
        if type(eventData) == "table" then
            for i=1, #eventData do
                -- If any of the multipie args is a table, unpack it
                if type(eventData[i]) == "table" then
                    for x=1, #eventData[i] do
                        -- We dont further process (tables inside tables inside tables)
                        if type(eventData[i]) ~= "table" then
                            table.insert(_data, eventData[i][x])
                        end
                    end
                else
                    table.insert(_data, eventData[i])
                end
            end

            -- Printing table
            if type(_data) == "table" then
                for i=1, #_data do
                    if type(_data[i]) == "boolean" then
                        _data[i] = tostring(_data[i])
                    end
                    __data = __data .. " " .. _data[i]
                end
            end 

        -- Parse (Simple args)
        else
            __data = eventData
        end
        print("[C->S] Event Sniper: " .. resource .. " | eName: " .. eventName .. " | eData: " .. __data .. " | eSrc: " .. eventSource .. " | eSize: " .. eventPayload .. "B")
    end
end)


AddEventHandler("consolelog_client", function(resource, playerId, eventName, eventPayload)
    for k,v in pairs(ignoreEvents) do
        if eventName == v then
            return
        end
    end
    if (eventPayload > maxEventPayload) then
        print("[S->C] Event Sniper: " .. resource .. " | eName: " .. eventName .. " | eSrc: " .. playerId .. " | eSize: " .. eventPayload .. "B")
    end
end)

AddEventHandler("consolelog_client_latent", function(resource, playerId, eventName, eventPayload)
    for k,v in pairs(ignoreEvents) do
        if eventName == v then
            return
        end
    end
    if (eventPayload > maxEventPayload) then
        print("[S->C] ^3Latent ^7Event Sniper: " .. resource .. " | eName: " .. eventName .. " | eSrc: " .. playerId .. " | eSize: " .. eventPayload .. "B")
    end
end)
