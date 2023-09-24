RegisterNetEvent('comet-weapons:talkToDealer', function()
  -- local currentGangInfo = exports['comet-gangsystem']:GetCurrentGangInfo()
  -- if not currentGangInfo then
  --   return TriggerEvent('DoLongHudText', 'Looks at you confused...', 2)
  -- end

  	local prices = exports['comet-base']:FetchComponent("Callback").Execute('comet-weapons:getCurrentBodyPrices')

  	local menuData = {
		{
			header = "What would you like to purchase?",
			isMenuHeader = true, -- Set to true to make a nonclickable title
		},
		{
			header = 'Rifle Body  '..'  $' .. prices.rifle,
			-- txt = "This goes to a sub menu",
			params = {
				event = "comet-weapons:purchaseWeaponBody",
				args = {
					type = 'rifle',
				}
			}
		},
		{
			header = 'SMG Body  '..'  $' .. prices.smg,
			-- txt = "This goes to a sub menu",
			params = {
				event = "comet-weapons:purchaseWeaponBody",
				args = {
					type = 'rifle',
				}
			}
		},
		{
			header = 'Pistol Body  '..'  $' .. prices.pistol,
			-- txt = "This goes to a sub menu",
			params = {
				event = "comet-weapons:purchaseWeaponBody",
				args = {
					type = 'rifle',
				}
			}
		},
		{
			header = 'Shotgun Body  '..'  $' .. prices.shotgun,
			-- txt = "This goes to a sub menu",
			params = {
				event = "comet-weapons:purchaseWeaponBody",
				args = {
					type = 'shotgun',
				}
			}
		},
	
	}
	exports['comet-context']:openMenu(menuData)
end)

RegisterNetEvent('comet-weapons:purchaseWeaponBody', function(data)
	local bodyType = data.type
	local input = exports["comet-input"]:ShowInput({
		header = "Amount",
		submitText = "Purchase",
		inputs = {
			{
				text = "Amount",
				name = "amount",
				type = "number", 
				isRequired = true,
			},
		}
	})
	if input then
		if not input.name then return end
		exports['comet-base']:FetchComponent("Callback").Execute('comet-weapons:purchaseWeaponBody', { pType = bodyType, pAmont = prompt.name})
	end
end)

--init
-- local pedd = {GetHashKey("a_m_o_tramp_01"),}
-- exports["qb-interact"]:AddPeekEntryByModel(pedd, {{
--     event = "comet-weapons:talkToDealer",
--     id = "gun_parts",
--     icon = "fas fa-circle",
--     label = 'Talk To Me?????!!!@!?',
--   }}, {
--     distance = { radius = 1.0 },
--     isEnabled = function(pEntity)
--       return true
--     end,
-- })

-- RegisterCommand('fsdfsdsdfs', function()
--   TriggerEvent('comet-weapons:talkToDealer')
-- end)