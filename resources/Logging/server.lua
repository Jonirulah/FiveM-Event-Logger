maxStateBagPayload = 175
maxEventPayload = 4000
ignoreEvents = {
    '__cfx_internal:httpResponse'
}

RegisterCommand('superstsniper', function(source, args, rawCommand)
    if source ~= 0 then
        print("Not permission")
        return
    end
    maxStateBagPayload = tonumber(args[1])
end, true)

RegisterCommand('superevsniper', function(source, args, rawCommand)
    if source ~= 0 then
        print("Not permission")
        return
    end
    maxEventPayload = tonumber(args[1])
end, true)


AddEventHandler("consolelog_statebag", function(pLength, s, v, r)
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
        print("Event Sniper: " .. resource .. " | eName: " .. eventName .. " | eData: " .. __data .. " | eSrc: " .. eventSource .. " | eSize: " .. eventPayload .. "B")
    end
end)