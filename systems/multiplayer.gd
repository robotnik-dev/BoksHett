extends Node
class_name Multiplayer

signal all_player_dead

const PLAYER_LIES_HELPLESS_ON_FLOOR_TIME: float = 3.0
const PLAYER_RESPAWN_TIME: float = 8.0

var player_scene: PackedScene = preload("res://character/player.tscn")

var max_player_number: int = 4

var players_alive: Array[Player]
var all_tweens_active: Array

# {device_id: player_id}
var players_connected: Dictionary

# FIXME: deprecated when game state 
var in_lobby: bool = false:
	set(value):
		in_lobby = value
		change_to_lobby()

var current_level: int = 1

func _ready() -> void:
	# connect to signal from level
	Signals.level_starts.connect(_on_level_start)

# FIXME: deprecated when game state
func change_to_lobby() -> void:
	for c in get_children():
		c.queue_free()
	for device_id in players_connected.keys():
		Signals.show_connected_player_with.emit(device_id)

func _on_level_start(level: int) -> void:
	current_level = level

func _input(event: InputEvent) -> void:
	# when not in lobby, return
	# TODO: game state in lobby
	if not in_lobby:
		return
	
	## ignore mouse
	if event is InputEventMouseMotion or event is InputEventMouseButton or event is InputEventKey:
		return
	
	# do nothing if 5th player joins
	if event.device == max_player_number:
		return
	
	# check if player wtih device number is already connected -> return
	#var this_device_connected: bool = false
	for device_id in players_connected.keys():
		if event.device == device_id:
			return
			#this_device_connected = true
	
	#if this_device_connected:
		#return
	
	add_player_device(event.device)

func at_least_one_player_ready() -> bool:
	return !players_connected.is_empty()

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
		# stop all tween timers
		for tween in all_tweens_active:
			tween.kill()
		all_tweens_active.clear()
		all_player_dead.emit()
	
	else:
		# 2. just one dead -> call respawn (with timer)
		var tween  = get_tree().create_tween()
		tween.tween_callback(remove_player_from_world.bind(dying_player)).set_delay(PLAYER_LIES_HELPLESS_ON_FLOOR_TIME)
		tween.finished.connect(func(): all_tweens_active.erase(tween))
		all_tweens_active.append(tween)
		
		var tween2  = get_tree().create_tween()
		tween2.tween_callback(spawn.bind(dying_player.id)).set_delay(PLAYER_RESPAWN_TIME)
		tween2.finished.connect(func(): all_tweens_active.erase(tween2))
		all_tweens_active.append(tween2)

## only called when in lobby
func add_player_device(device_id: int) -> void:
	# signal that new device added
	Signals.show_connected_player_with.emit(device_id)
	
	# create link in dict to player_id
	players_connected[device_id] = device_id + 1

## create the real object in the world
func spawn(player_id: int) -> void:
	# instance player object
	var new_player: Player = player_scene.instantiate()
	add_child(new_player)
	
	# setup player (device id, global position, etc)
	# assign the 'id' property of the player
	
	# FIXME: maybe race contion with initialization order wth level???
	var data = Database.waves_databases[current_level - 1].get_array()
	var spawn_position: Vector3
	for item in data:
		if item.name == "setup":
			var spawn_positions: Array = item.player_spawner_positions
			spawn_position = spawn_positions[player_id - 1]
	
	new_player.setup(player_id, spawn_position)
	
	# update player_alive
	players_alive.append(new_player)
	
	# connect to signals
	new_player.health_depleted.connect(_on_player_health_depleted.bind(new_player), CONNECT_ONE_SHOT)

## gets called after x seconds
func remove_player_from_world(player: Player) -> void:
	players_alive.erase(player)
	player.queue_free()
