AddEventHandler("onResourceStart", function(resource)
	TriggerClientEvent("comet-base:waitForExports", -1)

	if not Components.Base.ExportsReady then return end

	Citizen.CreateThread(function()
		while true do 
			Citizen.Wait(0)
			if Components.Base.ExportsReady then
				TriggerEvent("comet-base:refreshComponents")
				return
			else
				
			end
		end
	end)
end)