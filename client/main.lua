local playerPed, playerVehicle, playerDriver, vehicleClass, vehicleModel, surfaceMaterial = nil, nil, nil, nil, nil, nil
local offroadVehicles = {}

RegisterNetEvent(clientEvent('receiveUpdate'), function(vehicleList)
	offroadVehicles = vehicleList
end)

RegisterNetEvent(clientEvent('toggleDebug'), function()
	LocalPlayer.state:set('debuggingOffroad', not LocalPlayer.state['debuggingOffroad'])
end)

local class = nil
local wheelflag = nil

CreateThread(function()
	while true do
		Wait(200)

		-- Is player in any vehicle?
		if IsPedInAnyVehicle(playerPed, false) and playerDriver then
			class = GetVehicleClass(playerVehicle)
			wheelflag = GetVehicleWheelType(playerVehicle)
			if InTable(Config.Roads, surfaceMaterial) then
				-- Check if the slippery should go away
				if Entity(playerVehicle).state['noGrip'] and DoesEntityExist(playerVehicle) then
					Entity(playerVehicle).state:set('noGrip', false)

					NetworkRequestControlOfEntity(playerVehicle)

					SetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fTractionCurveMax',
						Entity(playerVehicle).state['defaultCurveMax'])
					SetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fTractionCurveMin',
						Entity(playerVehicle).state['defaultCurveMin'])
					SetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fLowSpeedTractionLossMult',
						Entity(playerVehicle).state['defaultTractionLoss'])

					ModifyVehicleTopSpeed(playerVehicle, 1.0)

					Wait(100)
				else
					Wait(100)
				end
			else
				if not (InTable(Config.BypassVehicleClasses, vehicleClass) or InTable(offroadVehicles, vehicleModel)) and
					not Entity(playerVehicle).state['noGrip'] and DoesEntityExist(playerVehicle) then
					-- Make grip go away!

					NetworkRequestControlOfEntity(playerVehicle)

					local defaultCurveMax = GetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fTractionCurveMax')
					local defaultCurveMin = GetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fTractionCurveMin')
					local defaultTractionLoss = GetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fLowSpeedTractionLossMult')

					Entity(playerVehicle).state:set('defaultCurveMax', defaultCurveMax)
					Entity(playerVehicle).state:set('defaultCurveMin', defaultCurveMin)
					Entity(playerVehicle).state:set('defaultTractionLoss', defaultTractionLoss)

					SetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fTractionCurveMax',
						defaultCurveMax - Config.ClassMod[class] / 4 * Config.WheelMod[wheelflag])
					SetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fTractionCurveMin',
						defaultCurveMin - Config.ClassMod[class] / 4 * Config.WheelMod[wheelflag])
					SetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fLowSpeedTractionLossMult',
						defaultTractionLoss + Config.ClassMod[class] * Config.WheelMod[wheelflag])

					ModifyVehicleTopSpeed(playerVehicle, 1.0)

					Entity(playerVehicle).state:set('noGrip', true)

					Wait(100)
				else
					-- Do not apply effect, let thread sleep
					Wait(100)
				end
			end
		else
			-- Let thread sleep.
			Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(1500)

		playerPed = PlayerPedId()
		playerVehicle = GetVehiclePedIsIn(playerPed, false)
		playerDriver = (playerVehicle and playerVehicle ~= 0) and GetPedInVehicleSeat(playerVehicle, -1) == playerPed or nil
		vehicleModel = (playerVehicle and playerVehicle ~= 0) and GetEntityModel(playerVehicle) or nil
		vehicleClass = (playerVehicle and playerVehicle ~= 0) and GetVehicleClass(playerVehicle) or nil
		surfaceMaterial = (playerVehicle and playerVehicle ~= 0) and GetVehicleWheelSurfaceMaterial(playerVehicle, 1) or nil
	end
end)
