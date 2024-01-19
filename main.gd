extends Node

@export var ui_lobby: UILobby
@export var hud: CanvasLayer
@export var enemy_spawner: EnemySpawner
@export var multiplayer_node: Multiplayer

func _ready() -> void:
	Signals.play_button_pressed.connect(_on_play_button_pressed)
	hud.hide()

func _on_play_button_pressed() -> void:
	## for now hide the lobby
	ui_lobby.hide()
	enemy_spawner.start_waves()
	multiplayer_node.spawn_connected_players()
	hud.show()
