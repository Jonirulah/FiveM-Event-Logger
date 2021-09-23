# [STAND-ALONE] FiveM-Event-Logger
Registers everything in the console, it was terrible now it is just average progressing.

![image](https://i.gyazo.com/59d911f6a38356ed00acb82b75c7285e.png))

What it's modified it's on line 454-461

	
	-- [START CHANGES]
	-- Cross check event name or we will be starting an infinite loop
	if eventName ~= "consolelog" then
		Citizen.CreateThreadNow(function()
			__data = msgpack_unpack(eventPayload)
			resource = GetCurrentResourceName()
			TriggerEvent("consolelog", resource, eventName, __data, eventSource)	
		end)
	end
	-- [FINISH CHANGES]
	

