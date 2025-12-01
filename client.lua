local ESX = exports['es_extended']:getSharedObject()
local Resource = GetCurrentResourceName()
local OnUseVending = false
local CurrentObject = nil
local OnTextUI = false

Wait(3000)
while not NetworkIsPlayerActive(PlayerId()) do Wait(1000) end
print("^7[^2"..Resource.."^7] Loading resources success.")

local InteractionWithObject = function(ObjectConfig, NearbyObject)
	local PlayerData = ESX.GetPlayerData()
	local success = ESX.GetAccount('money').money >= ObjectConfig.Price
	if success then
		OnUseVending = true

		if OnTextUI then
			OnTextUI = false
			Config.CloseTextUI()
		end

		CreateThread(function()
			while OnUseVending do
				Wait(0)

				DisableAllControlActions(0)
			end
		end)

		local AnimDict = "mini@sprunk"

		lib.requestAnimDict(AnimDict)
		RequestAmbientAudioBank("VENDING_MACHINE", 0)

		local Timer1 = (GetAnimDuration(AnimDict, "plyr_buy_drink_pt1")*1000) - 1000
		local Timer2 = GetAnimDuration(AnimDict, "plyr_buy_drink_pt2")*1000
		local Timer3 = GetAnimDuration(AnimDict, "plyr_buy_drink_pt3")*300
		local boneIndex = GetPedBoneIndex(PlayerPed, 28422)
		local ObjectCoords = GetOffsetFromEntityInWorldCoords(NearbyObject, 0.0, -0.94, 0.0)

		TaskLookAtEntity(PlayerPed, NearbyObject, 2000, 2048, 2)
		TaskGoStraightToCoord(PlayerPed, ObjectCoords.x, ObjectCoords.y, ObjectCoords.z, 1.0, 4000, GetEntityHeading(NearbyObject), 0.5)
		Wait(3000)
		CurrentObject = CreateObject(GetHashKey("prop_ecola_can"), GetEntityCoords(NearbyObject, true), true, false, false)
		TaskPlayAnim(PlayerPed, AnimDict, "plyr_buy_drink_pt1", 1.0, -1.0, -1, 1048576, 0, 0, 0, 0)
		Wait(1000)
		AttachEntityToEntity(CurrentObject, PlayerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)	
		Wait(Timer1)
		TaskPlayAnim(PlayerPed, AnimDict, "plyr_buy_drink_pt2", 1.0, -1.0, -1, 49, 0, 0, 0, 0)
		Wait(Timer2)
		TaskPlayAnim(PlayerPed, AnimDict, "plyr_buy_drink_pt3", 1.0, -1.0, -1, 49, 0, 0, 0, 0)
		Wait(Timer3)
		RemoveAnimDict(AnimDict)
		SetModelAsNoLongerNeeded(CurrentObject)
		DeleteEntity(CurrentObject)
		ReleaseAmbientAudioBank()

		ClearPedTasks(PlayerPed)

		if ObjectConfig.Price and ObjectConfig.Price > 0 then
			TriggerServerEvent('t3k.vending:pay', ObjectConfig.Price)
		end

		if ObjectConfig.Action and type(ObjectConfig.Action) == 'function' then
			ObjectConfig.Action()
		end

		Wait(1000)

		OnUseVending = false
	else
		lib.notify({
			title = 'Vending',
			description = 'You have enough money',
			type = 'error'
		})
	end
end

CreateThread(function()
	while true do
		local Timer = 1000
		
		local PlayerPed = lib.cache('ped')
		local PlayerCoords = GetEntityCoords(PlayerPed)
		local ObjectConfig, NearbyObject

		for _, data in pairs(Config.Object) do
			local Object = GetClosestObjectOfType(PlayerCoords, 1.0, GetHashKey(v.Prop), false, true ,true)
			local forward = GetEntityForwardVector(Object)
			local Distance = GetDistanceBetweenCoords(PlayerCoords, GetEntityCoords(Object).x-forward.x, GetEntityCoords(Object).y-forward.y, GetEntityCoords(Object).z, true)
			if Distance < 1.0 then
				ObjectConfig, NearbyObject = data, Object
				break
			end
		end

		if ObjectConfig and IsPedOnFoot(PlayerPed) then
			Timer = 0
			if not OnUseVending and not OnTextUI then
				OnTextUI = true
				Config.ShowTextUI()
			end

			if IsControlJustReleased(0, Config.InteractionControl) and not OnUseVending then
				InteractionWithObject(ObjectConfig, NearbyObject)
			end
		else
			if OnTextUI then
				OnTextUI = false
				Config.CloseTextUI()
			end
		end
		Wait(Timer)
	end
end)