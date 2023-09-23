Components.Callback = Components.Callback or {}

Components.Callback.Execute = function(name, data)
	local newEvent = nil
	local p = promise.new()
	local key = math.random(1,9999999)
	local event = ("comet-base:%s:%s"):format(name, key)
	RegisterNetEvent(event)
	newEvent = AddEventHandler(event, function(result)
		newEvent = RemoveEventHandler(newEvent)
		p:resolve(result)
	end)
	TriggerServerEvent("comet-base:executeCB", key, name, data)
	return Citizen.Await(p)
end


RegisterCommand("tempcb", function()
	local asshole = Components.Callback.Execute("callbacktester", {cid = "42C"})
	print(asshole)
end)

-- CreateThread(function()
-- 	print("test")
-- 	while true do 
-- 		Wait(100)
-- 		local asshole = Components.Callback.Execute("callbacktester", {cid = "42C"})
-- 		print(asshole)
-- 	end
-- end)
