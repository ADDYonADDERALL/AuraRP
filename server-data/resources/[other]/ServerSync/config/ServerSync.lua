--#####################################################################################################################
--#                                         ServerSync Main Config Options                                            #
--#####################################################################################################################
    -- Enable Debug output to the console window
    ss_show_console_output = false

    -- Enable Weather Syncing between all Players? Options: true or false
    ss_enable_weather_sync = true

    -- Enable Time Syncing between all Players? Options: true or false
    ss_enable_time_sync = true

    -- Enable Dynamic Wind Speed Syncing between all Players? Options: true or false
    -- Note: Disabling this option will turn all wind effects in your server OFF (i.e. no wind movement at all).
    ss_enable_wind_sync = true
    
--#####################################################################################################################
--#                                           ServerSync WEATHER Options                                              #
--#####################################################################################################################

-- Enable Dynamic (changing) weather for the players? Options: true or false
ss_enable_dynamic_weather = false

-- Default weather type for when the resource starts
-- Options: EXTRASUNNY, CLEAR, NEUTRAL, SMOG, FOGGY, OVERCAST, CLOUDS, CLEARING, 
-- Options: RAIN, THUNDER, SNOW, BLIZZARD, SNOWLIGHT, XMAS, HALLOWEEN
ss_default_weather = "XMAS"   

-- Weather timer (in minutes) between dynamic weather changes (Default: 10minutes)
ss_weather_timer = 30

ss_reduce_rain_chance = true

-- Weather timeout for rain (in minutes). This means it can only rain once every X minutes - Default: 60 minutes)
ss_rain_timeout = 300

-- Weather transitions are configured here, pay attention to the example.
-- Example: ["CurrentWeather"] = {"Next Possible Weather 1", "Next Possible Weather 2"}
-- Note: Default config only uses fairly 'clear' weather options to stay away from foggy environment effects.
ss_weather_Transition = {
	["EXTRASUNNY"] = {"CLEAR","SMOG"},
	["SMOG"]       = {"CLEAR","CLEARING","OVERCAST","CLOUDS","EXTRASUNNY"},
	["CLEAR"]      = {"CLOUDS","EXTRASUNNY","CLEARING","SMOG","OVERCAST"},
	["CLOUDS"]     = {"CLEAR","SMOG","CLEARING","OVERCAST"},
	["OVERCAST"]   = {"CLEAR","CLOUDS","SMOG","CLEARING","THUNDER"},
	["THUNDER"]    = {"OVERCAST"}, -- Always rotate away from Thunder, as it's annoying
	["CLEARING"]   = {"CLEAR","CLOUDS","OVERCAST","SMOG"},
	["RAIN"]		= {"RAIN"},
	["SNOW"]       = {"SNOW","SNOWLIGHT"},  -- Usually used for events - never changes and has to be manually set via /weather command
    ["SNOWLIGHT"]  = {"SNOW","SNOWLIGHT"},  -- Usually used for events - never changes and has to be manually set via /weather command
	["BLIZZARD"]   = {"BLIZZARD"},          -- Usually used for events - never changes and has to be manually set via /weather command
	["XMAS"]       = {"XMAS"},              -- Usually used for events - never changes and has to be manually set via /weather command
    ["HALLOWEEN"]  = {"HALLOWEEN"}          -- Usually used for events - never changes and has to be manually set via /weather command
}

--#####################################################################################################################
--#                                            ServerSync WIND Options                                                #
--#####################################################################################################################


-- Wind Speed maximum. Default: Max = 2.00
ss_wind_speed_max = 10.00

-- Effectiveness of Current Weather Wind Speed. 
-- Default for Extrasunny is 0.5. This means that the max wind speed above is multiplied by 0.5 to get 1.0 wind speed
ss_wind_speed_Mult = {
    ["EXTRASUNNY"] = 0.2 * ss_wind_speed_max,
    ["SMOG"]       = 0.1 * ss_wind_speed_max,
	["CLEAR"]      = 0.3 * ss_wind_speed_max,
	["CLOUDS"]     = 0.1 * ss_wind_speed_max,
	["OVERCAST"]   = 0.7 * ss_wind_speed_max,
	["THUNDER"]    = 1.0 * ss_wind_speed_max,
	["CLEARING"]   = 0.7 * ss_wind_speed_max,
	["SNOW"]       = 0.6 * ss_wind_speed_max,
    ["SNOWLIGHT"]  = 0.4 * ss_wind_speed_max,
	["BLIZZARD"]   = 0.8 * ss_wind_speed_max,
	["XMAS"]       = 0.4 * ss_wind_speed_max,
    ["HALLOWEEN"]  = 0.8 * ss_wind_speed_max
}

--#####################################################################################################################
--#                               ServerSync DAY/NIGHT TIME Speed Options                                             #
--#####################################################################################################################

-- Lower then 1 = Longer, Higher then 1 = faster.  0.25 would be 4x slower then GTA time. 2.0 would be half as long as default GTA
ss_night_time_speed_mult = 1.0
ss_day_time_speed_mult = 0.25
