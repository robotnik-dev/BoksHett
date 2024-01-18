extends Node
class_name Multiplayer

signal all_player_dead


@export var player_spawns: Array[Node3D]

const PLAYER_LIES_HELPLESS_ON_FLOOR_TIME: float = 3.0
const PLAYER_RESPAWN_TIME: float = 8.0

var player_scene: PackedScene = preload("res://character/player.tscn")

var max_player_number: int = 4

var players_alive: Array[Player]
# {Player: device_id}
var players_connected: Dictionary


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventMouseButton or event is InputEventKey:
		return
	# do nothing if 5th player joins
	if event.device == max_player_number:
		return
	
	# check if player wtih device number is already in play -> return
	for player in players_connected.keys():
		if event.device + 1 == player.player:
			return
	
	## debug
	add_player_device(event.device)
	
	## create new player
	#var new_player: Player = player_scene.instantiate()
	#add_child(new_player)
	## assign player new device number
	#new_player.player = event.device + 1
	#new_player.global_position = player_spawns[new_player.player - 1].global_position
	#players_connected[new_player] = event.device
	##players_connected.append(new_player)
	#players_alive.append(new_player)
	#
	## handle player death
	#new_player.health_depleted.connect(_on_player_health_depleted.bind(new_player))

func _on_player_health_depleted(dying_player: Player) -> void:
	if not dying_player in players_alive:
		return
	
	# play death anim egal ob alle tod sind
	dying_player.die()
	players_alive.erase(dying_player)
	
	# two possible outcomes
	if players_alive.is_empty():
		# 1. all dead -> game over
		all_player_dead.emit()
	
	#else:
	# 2. just one dead -> call respawn (with timer)
	var tween  = get_tree().create_tween()
	tween.tween_callback(remove_player_from_world.bind(dying_player)).set_delay(PLAYER_LIES_HELPLESS_ON_FLOOR_TIME)
	
	var tween2  = get_tree().create_tween()
	tween2.tween_callback(respawn.bind(dying_player)).set_delay(PLAYER_RESPAWN_TIME)

## for UI 
func add_player_device(device_id: int) -> void:
	Signals.new_player_device_added.emit(device_id)

func spawn(device_id: int) -> void:
	# instance player object
	# add_child(player)
	# setup player (device id, global position, etc)
	# update player_alive
	# connect to signals
	pass

## gets called after x seconds
func remove_player_from_world(player: Player) -> void:
	player.queue_free()

## gets called after remove_player_from_world
func respawn(player: Player) -> void:
	pass

