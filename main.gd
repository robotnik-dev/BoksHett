extends Node

@export var ui_lobby: UILobby
@export var hud: CanvasLayer
@export var multiplayer_node: Multiplayer
@export var ui_pause_screen: UIPauseScreen
@export var world: Node

# TODO: add more levels
var level1_scene: PackedScene = preload("res://maps/level1.tscn")

func _ready() -> void:
	Signals.play_button_pressed.connect(_on_play_button_pressed)
	hud.hide()

func _on_play_button_pressed() -> void:
	# do nothing when no player is connected
	if not multiplayer_node.at_least_one_player_ready():
		return
	
	# for now hide the lobby
	ui_lobby.hide()
	# spawn level into the world
	var level1 = level1_scene.instantiate()
	world.add_child(level1)
	
	multiplayer_node.spawn_connected_players()
	hud.show()
