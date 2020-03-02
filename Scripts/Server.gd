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

var send_key_list = []
var send_key_list_count = 0

onready var socket = PacketPeerUDP.new()

var IP_SERVER =   "davidgossvpn.duckdns.org" # "192.168.0.213" #
var PORT_SERVER = 4242
var PORT_CLIENT = 4243



# time out server if no response
var count_send = 0
var send_trys = 3

var server_message = {"message": "check"}

func _ready():
	start_client()
	
func _process(delta):
	if not server_paused:
		if not cron_sync <= 0:
			cron_sync -= delta
		else:
			if socket.is_listening():
				socket.set_dest_address(IP_SERVER, PORT_SERVER)
				var staging = to_json(server_message)
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
#			/time_check(array_bytes.get_string_from_ascii())
			check_server_sync(array_bytes.get_string_from_ascii())
			count_send = 0


func check_server_sync(server_dict):
	print(server_dict)
	server_dict = parse_json(server_dict)
	print(server_dict)
	var message_from_server = server_dict["message"]
	if message_from_server == "sending":
		update_from_server(server_dict)
	if message_from_server == "check":
		var server_time = int(server_dict["data"])
		var client_save_time = Save.dict_save["save_time"]
		
		if client_save_time == server_time:
			print("server and client is upto date")
			cron_sync = sync_interval
			server_message = {"message" : "check"}
			node_load.modulate = colour_green
			
		elif client_save_time > server_time:
			print("server is out of date")
			if len(send_key_list) == 0:
				send_key_list = dict_key_list(Save.dict_save)
			if send_key_list_count <= len(send_key_list)-1:
				var send_key = send_key_list[send_key_list_count]
				var data = Save.dict_save[send_key]
				send_key_list_count += 1
				server_message = {"message" : "update", "key" : send_key, "data": data}
			else:
				send_key_list_count = 0
			cron_sync = 0
			node_load.modulate = colour_blue
			
		elif client_save_time < server_time:
			print("Client is out of date")
			var client_dict = Save.dict_save
			if len(send_key_list) == 0:
				print("making list")
				print("list length = ")
				send_key_list = dict_key_list(client_dict)
			if send_key_list_count <= len(send_key_list):
				print(send_key_list_count)
				var send_key = send_key_list[send_key_list_count]
				send_key_list_count += 1
				server_message = {"message" : "send", "key" : send_key, "data": client_dict[send_key]}
				cron_sync = 0
				node_load.modulate = colour_yellow
			else:
				print("Finished sending update to server")
				send_key_list_count = 0
				server_message = {"message" : "check"}
			cron_sync = 0
		


func update_from_server(server_data):
	print("updating from server...")
	var client_dict = Save.dict_save
	var key_check = server_data["key"]
	if not key_check == "save_time":
		for i in client_dict[key_check].keys():
			if i == "node" or i == "name":
				continue
			print("update key = ",i)
			client_dict[key_check][i] = server_data["data"][i]
	else:
		client_dict[key_check] = server_data["data"]
	Save.dict_save = client_dict
	if len(send_key_list) == 0:
		print("making list")
		print("list length = ")
		send_key_list = dict_key_list(client_dict)
	if send_key_list_count <= len(send_key_list)-1:
		print(send_key_list_count)
		var send_key = send_key_list[send_key_list_count]
		send_key_list_count += 1
		server_message = {"message" : "send", "key" : send_key}
		cron_sync = 0
		node_load.modulate = colour_yellow
	else:
		print("finished updating from server")
		send_key_list_count = 0
		server_message = {"message" : "check"}


func dict_key_list(dict):
	var list = []
	for i in dict:
		if i == "save_time":
			continue
		list.append(i)
	list.append("save_time")
	return list

func update_server():
	cron_sync = 0

func start_client():
	if (socket.listen(PORT_CLIENT, "*") != OK):
		print_debug("Error listening on port: " + str(PORT_CLIENT) + " in server: " + IP_SERVER)
	else:
		print_debug("Listening on port: " + str(PORT_CLIENT) + " in server: " + IP_SERVER)

func _exit_tree():
	socket.close()
