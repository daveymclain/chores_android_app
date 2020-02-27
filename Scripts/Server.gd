extends Node2D

var server_paused = false
onready var node_load = get_node("/root/App/UI/HBoxContainer/Load")
var colour_red = Color(1,0,0)
var colour_yellow = Color(1,1,0)
var colour_green = Color(0,1,0)
var colour_blue = Color(0,0,1)
# Seconds between sync with server
var sync_interval = 10
var cron_sync = 2
var done = false
onready var socket = PacketPeerUDP.new()
var IP_SERVER =  "davidgossvpn.duckdns.org"
var PORT_SERVER = 4242
var PORT_CLIENT = 4243

var cron_send = 2

var server_contact = false

# time out server if no response
var count_send = 0

var server_message = "check"

func _ready():
	start_client()
	
func _process(delta):
	if not server_paused:
		if cron_sync > 0:
			cron_sync -= delta
		if cron_sync <= 0:
			server_contact = true
		if server_contact:
			if cron_send > 0:
				cron_send -= delta	
			if cron_send <= 0:
				if socket.is_listening():
					socket.set_dest_address(IP_SERVER, PORT_SERVER)
					var staging = server_message
					var package = staging.to_ascii()
					socket.put_packet(package)
					
					print_debug("send!")
					count_send += 1
					if count_send == 3:
						print_debug("Server not responding after %d tries" % 3)
						server_contact = false
						cron_sync = sync_interval 
						count_send = 0
						node_load.modulate = colour_blue
					cron_send = 3
	
		if socket.get_available_packet_count() > 0:
			cron_sync = sync_interval
			var array_bytes = socket.get_packet()
			print_debug("msg from server: " + array_bytes.get_string_from_ascii())
			time_check(array_bytes.get_string_from_ascii())
			server_contact = false
			

func time_check(server_time):
	print("checking server time")
	if server_time.is_valid_integer():
		server_time = int(server_time)
		if Save.dict_save["save_time"] != server_time:
			if Save.dict_save["save_time"] > server_time:
				print("server needs to update")
				server_message = to_json(Save.dict_save)
				cron_sync = 1
				node_load.modulate = colour_blue
			else:
				print("Client need to update")
				server_message = "send"
				cron_sync = 1
				node_load.modulate = colour_yellow
		else:
			print("server and client is up to date")
			server_message = "check"
			node_load.modulate = colour_green
	else:
		print("updating from server") 
		Save.dict_save = parse_json(server_time)
		var save_nodes = get_tree().get_nodes_in_group("Persist")

		for i in save_nodes:
		# the saved nodes are returned as strings. convert them back into node objects
			Save.dict_save[i.node_number]["node"] = i
		server_message = "check"

	
func start_client():
	if (socket.listen(PORT_CLIENT, "*") != OK):
		print_debug("Error listening on port: " + str(PORT_CLIENT) + " in server: " + IP_SERVER)
	else:
		print_debug("Listening on port: " + str(PORT_CLIENT) + " in server: " + IP_SERVER)

func _exit_tree():
	socket.close()
