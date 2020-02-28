extends Node2D

var server_paused = false
onready var node_load = get_node("/root/App/UI/HBoxContainer/Load")

var colour_red = Color(1,0,0)
var colour_yellow = Color(1,1,0)
var colour_green = Color(0,1,0)
var colour_blue = Color(0,0,1)

# Seconds between sync with server
var sync_interval = 10
# Delay to start server and runing time
var cron_sync = 2
# If server not responding resend delay
var retry_interval = 2


onready var socket = PacketPeerUDP.new()

var IP_SERVER =  "davidgossvpn.duckdns.org"
var PORT_SERVER = 4242
var PORT_CLIENT = 4243



# time out server if no response
var count_send = 0
var send_trys = 3

var server_message = "check"

func _ready():
	start_client()
	
func _process(delta):
	if not server_paused:
		if not cron_sync <= 0:
			cron_sync -= delta
		else:
			if socket.is_listening():
				socket.set_dest_address(IP_SERVER, PORT_SERVER)
				var staging = server_message
				var package = staging.to_ascii()
				socket.put_packet(package)
				print("send!")
				# time out
				count_send += 1
				cron_sync += 0.5
				if count_send == send_trys:
					print_debug("Server not responding after %d tries" % send_trys)
					cron_sync = retry_interval 
					count_send = 0
					node_load.modulate = colour_blue

		if socket.get_available_packet_count() > 0:
			var array_bytes = socket.get_packet()
			print("msg from server: " + array_bytes.get_string_from_ascii())
			time_check(array_bytes.get_string_from_ascii())
			count_send = 0
			
			

func time_check(server_time):
	print("checking server time")
	if server_time.is_valid_integer():
		server_time = int(server_time)
		if Save.dict_save["save_time"] != server_time:
			if Save.dict_save["save_time"] > server_time:
				print("server needs to update")
				server_message = to_json(Save.dict_save)
				cron_sync = 0
				node_load.modulate = colour_blue
			else:
				print("Client need to update")
				cron_sync = 0
				server_message = "send"
				cron_sync = 0
				node_load.modulate = colour_yellow
		else:
			print("server and client is up to date")
			cron_sync = sync_interval
			server_message = "check"
			node_load.modulate = colour_green
	else:
		print("updating from server") 
		update_from_server(server_time)
		cron_sync = 0

func update_server():
	print("updateing server")
	cron_sync = 0
	server_message = to_json(Save.dict_save)

func update_from_server(server_data):
	var dict_client = Save.dict_save
	var dict_server = parse_json(server_data)
	
	for i in dict_client.keys():
		if not dict_server.has(i):
			print("client has a new node skip and update it later")
			continue
		dict_client[i] = dict_server[i]
	Save.dict_save = dict_client
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
