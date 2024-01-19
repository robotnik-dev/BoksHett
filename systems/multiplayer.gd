extends Node
class_name Multiplayer

signal all_player_dead


@export var player_spawns: Array[Node3D]

const PLAYER_LIES_HELPLESS_ON_FLOOR_TIME: float = 3.0
const PLAYER_RESPAWN_TIME: float = 8.0

var player_scene: PackedScene = preload("res://character/player.tscn")

var max_player_number: int = 4

var players_alive: Array[Player]

# {device_id: player_id}
var players_connected: Dictionary

var in_lobby: bool = true:
	set(value):
		in_lobby = value

func _input(event: InputEvent) -> void:
	# when not in lobby, return
	if not in_lobby:
		return
	
	## ignore mouse
	if event is InputEventMouseMotion or event is InputEventMouseButton or event is InputEventKey:
		return
	
	# do nothing if 5th player joins
	if event.device == max_player_number:
		return
	
	# check if player wtih device number is already connected -> return
	for device_id in players_connected.keys():
		if event.device == device_id:
			print("device already connected")
			return
	
	add_player_device(event.device)

func spawn_connected_players() -> void:
	in_lobby = false
	
	for player_id in players_connected.values():
		spawn(player_id)

func _on_player_health_depleted(dying_player: Player) -> void:
	if not dying_player in players_alive:
		return
	
	# play death anim egal ob alle tod sind
	dying_player.die()
	players_alive.erase(dying_player)
	
	# two possible outcomes
	# FIXME: what happens if close to another dying
	if players_alive.is_empty():
		# 1. all dead -> game over
		print("GAME OVER")
		all_player_dead.emit()
	
	else:
		# 2. just one dead -> call respawn (with timer)
		var tween  = get_tree().create_tween()
		tween.tween_callback(remove_player_from_world.bind(dying_player)).set_delay(PLAYER_LIES_HELPLESS_ON_FLOOR_TIME)
		
		var tween2  = get_tree().create_tween()
		tween2.tween_callback(spawn.bind(dying_player.id)).set_delay(PLAYER_RESPAWN_TIME)

## only called when in lobby
func add_player_device(device_id: int) -> void:
	print("add device number: " + str(device_id))
	# signal that new device added
	Signals.new_player_device_added.emit(device_id)
	
	# create link in dict to player_id
	players_connected[device_id] = device_id + 1

## create the real object in the world
func spawn(player_id: int) -> void:
	print("spawn player with player_id: " +str(player_id))
	# instance player object
	var new_player: Player = player_scene.instantiate()
	add_child(new_player)
	
	# setup player (device id, global position, etc)
	# assign the 'id' property of the player
	new_player.setup(player_id, player_spawns[player_id - 1].global_position)
	
	# update player_alive
	players_alive.append(new_player)
	
	# connect to signals
	new_player.health_depleted.connect(_on_player_health_depleted.bind(new_player), CONNECT_ONE_SHOT)

## gets called after x seconds
func remove_player_from_world(player: Player) -> void:
	players_alive.erase(player)
	player.queue_free()
