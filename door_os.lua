-- AUTHOR: Katharina 'spacekookie' SABEL
-- LICENSE: AGPL v3.0
-- NOTE: This is the core file for the twitter door. It will be run on launch
-- and also initialise other stuff to make sure that it can be talked to for maintanence
-- and upgrades, etc.


WIFI_NET_ID = "c-base-botnet"
WIFI_NET_PW = "shrokosht"

-- Start the wifi
function start_wifi()
	wifi.setmode(wifi.STATION)
	wifi.sta.config(WIFI_NET_ID,WIFI_NET_PW)
	wifi.sta.getip()
end

-- Start the wifi before doing anything else
start_wifi()

-- Add extra code below to do stuff

require 'door_handle.lua' -- Run the file that handles the actual door handles

-- TODO: Add something to bootstrap other functions to the door hook