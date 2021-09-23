
local IgnoreEvents = {
    "onServerResourceStop",
    "onServerResourceStart",
    "onResourceStart",
    "onResourceStop,"
}   

AddEventHandler("consolelog", function(resource, eventName, eventData, eventSource)
    ignore = false

    for k,v in ipairs(IgnoreEvents) do
        if v == eventName then
            ignore = true
            break
        end
    end

    -- Parse Data from the Event if not ignored
    if not ignore then
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
        
        print("Resource: " .. resource .. " | Event name: " .. eventName .. " | Event Data: " .. __data .. " | Event Source: " .. eventSource)
    end
end)