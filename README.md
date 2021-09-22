# [STAND-ALONE] FiveM-Event-Logger
Registers everything in the console, it was terrible now it is just bad

![image](https://cdn.discordapp.com/attachments/856660608002818048/890326571506860032/b65141523f4689d380b6be50e7b8d26b.png)

What it's modified it's from line 452-464

	-- added trash
	Citizen.CreateThreadNow(function(),
		__data = msgpack_unpack(eventPayload)
		_data = ""
		if type(__data) == "table" then
			for i=1, #__data do
				if type(__data[i]) ~= "table" then
					_data = _data .. " " .. tostring(__data[i])
				end
			end
		end
		print(eventName, _data, eventSource)
	end)
