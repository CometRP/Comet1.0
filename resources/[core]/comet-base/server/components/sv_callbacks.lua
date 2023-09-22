-- -- Components.Callback = Components.Callback or {}

-- -- local res, promises, functions, callIden = GetCurrentResourceName(), {}, {}, 0

-- -- Components.Callback.Register = function(name, func)
-- --     functions[name] = func
-- -- end

-- -- Components.Callback.Remove = function(name)
-- --     functions[name] = nil
-- -- end

-- -- paramPacker = function(...)
-- --     local params, pack = {...}, {}

-- --     for i = 1, 15, 1 do
-- --         pack[i] = {param = params[i]}
-- --     end
    
-- --     return pack
-- -- end

-- -- paramUnpacker = function(params, index)
-- --     local idx = index or 1

-- --     if idx <= #params then
-- --         return params[idx]['param'], paramUnpacker(params, idx + 1)
-- --     end
-- -- end

-- -- unpacker = function(params, index)
-- --     local idx = index or 1

-- --     if idx <= 15 then return params[idx]['param'], unpacker(params, idx + 1) end
-- -- end

-- -- clearPromise = function(callId)
-- --     Citizen.SetTimeout(5000, function()
-- --         promises[callId] = nil
-- --     end)
-- -- end

-- -- RegisterNetEvent('comet-base:server:callback', function(origin, name, callId, params)
-- --     local response
-- --     local src = source
-- --     print(origin, name, callId, params)
-- --     print(json.encode(params))
-- --     if functions[name] == nil then return end
-- --     local success, error = pcall(function()
-- --         if packaged then
-- --             print(paramUnpacker(params))
-- --             response = paramPacker(functions[name](paramUnpacker(params)))
-- --         else
-- --             print(unpacker(params))
-- --             response = paramPacker(functions[name](unpacker(params)))
-- --         end
-- --     end)

-- --     if not success then
-- --         print(string.format('Data Fetch Error: %s %s %s', origin, name, error))
-- --     end

-- --     if response == nil then response = {} end

-- --     TriggerClientEvent('comet-base:client:callback', src, origin, callId, response)
-- -- end)

-- Components.Callback = {

--     -- SERVER -> CLIENT

--     SendCall = function(self, source, eventName, data)

--         local p = promise.new()

--         TriggerEvent(eventName, source, data, function(returnVal)
--             p:resolve(returnVal)
--         end)

--         return Citizen.Await(p)

--     end,

--     -- CLIENT -> SERVER

--     ActiveCalls = {},

--     CallAsync = function(self, source, eventName, data)
        
-- 		local p = promise.new()	
-- 		local callId = #self.ActiveCalls + 1
-- 		self.ActiveCalls[callId] = p
		
-- 		TriggerClientEvent('erp_remotecalls:sendCall', source, callId, eventName, data)

-- 		return Citizen.Await(p)

-- 	end,

-- 	GetData = function(self, callId, ...)

-- 		local p = self.ActiveCalls[callId]
-- 		p:resolve(...)

-- 		self.ActiveCalls[callId] = false

-- 	end,

--     Register = function(eventName, cb)
--         AddEventHandler(eventName, cb)
--     end,

-- }

-- RegisterNetEvent('erp_remotecalls:sendCall', function(callId, eventName, data)
--     local source = source;
--     TriggerClientEvent('erp_remotecalls:getData', source, callId, Components.Callback:SendCall(source, eventName, data))
-- end)

-- exports('CallAsync', function(source, event, data)
-- 	return Components.Callback.Execute(source, event, data)
-- end)

-- -- exports['erp_remotecalls']:CallAsync()

-- RegisterNetEvent('erp_remotecalls:getData', function(callId, ...)
-- 	Components.Callback:GetData(callId, ...)
-- end)