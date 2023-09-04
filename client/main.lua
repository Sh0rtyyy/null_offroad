local playerPed, playerVehicle, playerDriver, vehicleClass, vehicleModel, surfaceMaterial = nil, nil, nil, nil, nil, nil
local offroadVehicles = {}

RegisterNetEvent(clientEvent('receiveUpdate'), function(vehicleList)
	offroadVehicles = vehicleList
end)

RegisterNetEvent(clientEvent('toggleDebug'), function()
	LocalPlayer.state:set('debuggingOffroad', not LocalPlayer.state['debuggingOffroad'])
end)


--[[local Config.ClassMod = {
    [0]= 1.31, -- Compacts 
    [1] = 1.21, --Sedans
    [2] = 1.01, --SUVs
    [3] = 2.51, --Coupes
    [4] = 2.201, --Muscle
    [5] = 2.81, --Sports Classics
    [6] = 2.51, --Sports
    [7] = 3.51, --Super  
    [8] = 1.51, --Motorcycles  
    [9] = 0, --Off-road
    [10] = 0, --Industrial
    [11] = 0, --Utility
    [12] = 5.21, --Vans  
    [13] = 0, --Cycles  
    [14] = 0, --Boats  
    [15] = 0, --Helicopters  
    [16] = 0, --Planes  
    [17] = 0, --Service  
    [18] = 0.21, --Emergency  
    [19] = 0, --Military  
    [20] = 0.21, --Commercial  
    [21] = 0 --Trains  
}]]

--[[local Config.WheelMod = {
	[-1] = 1.91, --Stock
    [0] = 1.31, --Sport 
    [1] = 2.00, --Muscle
    [2] = 1.81, --Lowrider
    [3] = 0.50, --SUV
    [4] = -1.001, --Offroad
    [5] = 1.75, --Tuner
    [6] = 1.61, --Bike Wheels
    [7] = 1.91, --High Eend  
    [8] = 1.21, --Bennys Original  
    [9] = 0, --Bennys Bespoke 
    [10] = 0, --Open Wheel
    [11] = 0, --Street
    [12] = 2.21, --Track  
}]]

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
