Config = {}
Config.Debug = true

QBCore = exports['qb-core']:GetCoreObject() 


Config.Settings = {
	Framework = 'QB', -- QB ONLY
	Inventory = 'OX', -- QB/OX
	Target = "OX", -- OX/QB
	WebHook = "", -- Discord webhook 
	ATMs = { -- Props that can be robbed - https://forge.plebmasters.de/
		'prop_atm_01', 'prop_atm_02', 'prop_fleeca_atm', 'prop_atm_03'
	},
	Reward = 500, -- Cash Reward per bill.
	Cooldown = 10, -- Cooldwon in minutes.
	CopsNeeded = 0, -- Cops needed to start the robbery.
	BombItemName = 'sandwich' -- Item Requierd for the robbery.
}

