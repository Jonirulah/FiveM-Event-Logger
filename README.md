# [STAND-ALONE] FiveM-Event-Logger
Registers everything in the console, it was terrible now it is just bad

![image](![image](https://user-images.githubusercontent.com/25936173/134549774-6bff7a1a-4495-4a91-868a-c0a410b81469.png))

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
	

