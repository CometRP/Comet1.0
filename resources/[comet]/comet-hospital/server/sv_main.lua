-- uncoded i did it all on client :/
local deadPlayers = {}

RegisterNetEvent("comet-hospital:setDeathStatus", function(stat)
	local source = source
	if stat == false then stat = nil end
	deadPlayers[source] = stat
end)
