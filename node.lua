MQTT_BROKER = "c-beam.cbrp3.c-base.org" 
MQTT_PORT = 1883 
MQTT_CLIENTID = "klotuer" 
MQTT_USERID = "" 
MQTT_PASSWD = ""

function start_wifi()
	wifi.setmode(wifi.STATION)
	wifi.sta.config("c-base-botnet", "shrokosht")
	wifi.sta.getip()
end

function make_something_appear()
	client = mqtt.Client(MQTT_CLIENTID, 120, MQTT_USERID, MQTT_PASSWD)

	client:connect(MQTT_BROKER, MQTT_PORT, 0, function(conn)
		client:publish("motd", "I am a tweet", 0, 0, function(conn) end)
	end)
end

start_wifi()
make_something_appear()