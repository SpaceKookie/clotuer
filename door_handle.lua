-- AUTHOR: Katharina 'spacekookie' SABEL
-- LICENSE: AGPL v3.0
-- NOTE: This file handles

-- Some constants to deal with stuff
PIN_OUT = 0
PIN_IN = 2

-- Some MQTT variables
MQTT_BROKER = "c-beam.cbrp3.c-base.org" 
MQTT_PORT = 1883 
MQTT_CLIENTID = "clotuer" 
MQTT_USERID = "" 
MQTT_PASSWD = ""

-- Timeout times
DOOR_CLOSE_TIME = 60 -- Needs to be closed at least X seconds
SEND_TIMEOUT = 120

--  Door state handles
door_state = 0
door_last_closed = 0
last_transmission = 0
user_count = 0


-- Actually send a message to the server
function send_tweet(data)
	client = mqtt.Client(MQTT_CLIENTID, 120, MQTT_USERID, MQTT_PASSWD)

	client:connect(MQTT_BROKER, MQTT_PORT, 0, function(conn) 
		client:publish("clotuer", "Timestamp: " .. data, 0, 0,  function(conn) end)
	end)
end


-- Define the GPIO outputs. The PIN_OUT is only there for debugging
function setup_gpio()
	gpio.mode(0, gpio.OUTPUT)
	gpio.mode(2, gpio.INPUT, gpio.PULLDOWN)
	gpio.mode(0, gpio.LOW)
end

-- Do some setup
setup_gpio()

-- Every 10ms check for door logic
tmr.alarm(0, 10, 1, function() 
		state = gpio.read(2)

		if(state == 1) then

			-- Write the debugging GPIO to high
			gpio.write(0, gpio.HIGH)

			-- If the door was JUST open
			if(door_state == 0) then
				door_last_closed = tmr.time()
				door_state = 1
			end
		else
			gpio.write(0, gpio.LOW)
			
			-- Triggers if the door was JUST closed
			if(door_state == 1) then
				
				-- Current time and delta of door closing
				current = tmr.time()
				closed_delta = current - door_last_closed
				broadcast_delta = current - last_transmission

				if(closed_delta >= DOOR_CLOSE_TIME) then
					
					if(broadcast_delta >= SEND_TIMEOUT) then
						last_transmission = current
						send_tweet(closed_delta)
					end
				end
			end
			door_state = 0
		end
	end)