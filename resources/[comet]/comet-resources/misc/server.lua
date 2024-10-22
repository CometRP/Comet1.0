-- Blacklisting entities can just be handled entirely server side with onesync events
-- No need to run coroutines to supress or delete these when we can simply delete them before they spawn
AddEventHandler("entityCreating", function(handle)
    local entityModel = GetEntityModel(handle)

    if Misc.BlacklistedVehs[entityModel] or Misc.BlacklistedPeds[entityModel] then
        CancelEvent()
    end
end)