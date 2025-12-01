Config = {}

Config.InteractionControl = 38

Config.ShowTextUI = function()
	lib.showTextUI('[E] - Interaction')
end

Config.CloseTextUI = function()
	lib.closeTextUI()
end

Config.Object = {
	{
		Prop = "prop_vend_soda_01",
		Price = 10,
		Action = function()
			TriggerEvent('esx_status:set', 'thirst', 500000)
		end
	},
	{
		Prop = "prop_vend_soda_02",
		Price = 10,
		Action = function()
			TriggerEvent('esx_status:set', 'thirst', 500000)
		end
	},
	{
		Prop = "prop_vend_fridge01",
		Price = 10,
		Action = function()
			TriggerEvent('esx_status:set', 'thirst', 500000)
		end
	},
}