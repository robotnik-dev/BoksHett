extends Node
class_name Multiplayer

@export var player_spawns: Array[Node3D]

var player_scene: PackedScene = preload("res://character/player.tscn")

var max_player_number: int = 4

var current_players: Array[Player]


func _input(event: InputEvent) -> void:
	# do nothing if 5th player joins
	if event.device == max_player_number:
		return
	
	# check if player wtih device number is already in play -> return
	for player in current_players:
		if event.device + 1 == player.player:
			return
	
	# create new player
	var new_player: Player = player_scene.instantiate()
	add_child(new_player)
	# assign player new device number
	new_player.player = event.device + 1
	new_player.global_position = player_spawns[new_player.player - 1].global_position
	current_players.append(new_player)
