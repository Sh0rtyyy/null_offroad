Config = {}

-------------------------------------------------------------------------------------------
--                             ____          ________                     __             --
--                ____  __  __/ / /   ____  / __/ __/________  ____ _____/ /             --
--               / __ \/ / / / / /   / __ \/ /_/ /_/ ___/ __ \/ __ `/ __  /              --
--              / / / / /_/ / / /   / /_/ / __/ __/ /  / /_/ / /_/ / /_/ /               --
--             /_/ /_/\__,_/_/_/____\____/_/ /_/ /_/   \____/\__,_/\__,_/                --
--               v1.2.0       /_____/           Made by Nullified                        --
-------------------------------------------------------------------------------------------

--[[ General Information & Required variables
Welcome to the configuration section of null_offroad, the variables below should not be edited unless
you know what you are doing. If you edit them and something breaks it is your own fault. The configuration
options are explained well and you should be able to easily configure the script. Please send me a message
if anything goes wrong or if you have questions about the configuration of the script. 
--]]

-- Example: Config.BypassVehicles = { 'adder', 'tezeract' }: will bypass the class check.
Config.BypassVehicles = {}

-- The list of possible vehicle classes can be found here: https://docs.fivem.net/natives/?_0x29439776AAA00A62
Config.BypassVehicleClasses = { 9 }

-- Material types that should not cause any grip loss. You can find these numbers in the debugger.
Config.Roads = { 1, 4, 3, 7, 181, 15, 13, 55, 68, 69, 12, 31, 36, 35, 173, 64 }

Config.ClassMod = {
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
}

Config.WheelMod = {
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
}