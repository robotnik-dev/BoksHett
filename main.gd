extends Node

@export var gui: CanvasLayer
@export var hud: CanvasLayer
@export var multiplayer_node: Multiplayer
@export var ui_pause_screen: UIPauseScreen
@export var world: Node
@export var main_menu: UIMainMenu

# TODO: add more levels
var level1_scene: PackedScene = preload("res://maps/level1.tscn")
var game_over_scene: PackedScene = preload("res://ui/ui_game_over.tscn")
var lobby_scene: PackedScene = preload("res://ui/ui_lobby.tscn")

func _ready() -> void:
	Signals.play_button_pressed.connect(_on_play_button_pressed)
	Signals.back_to_menu_pressed.connect(_on_back_to_menu)
	Signals.restart_level_pressed.connect(_on_restart_level)
	Signals.to_lobby_pressed.connect(_on_to_lobby_pressed)
	Signals.level_won.connect(_on_level_won)
	multiplayer_node.all_player_dead.connect(_on_all_player_dead)
	hud.hide()
	main_menu.show()

func _on_back_to_menu() -> void:
	for c in world.get_children():
		c.queue_free()
	
	main_menu.show()

func _on_to_lobby_pressed() -> void:
	main_menu.hide()
	var lobby = lobby_scene.instantiate()
	gui.add_child(lobby)
	# FIXME: depracated when Gamestate
	multiplayer_node.in_lobby = true

func _on_restart_level() -> void:
	print("_on_restart_level")

func _on_level_won() -> void:
	get_tree().paused = true
	hud.hide()
	# show game over screen
	var game_over = game_over_scene.instantiate()
	# TODO: give game over screen stats to show in setup function
	gui.add_child(game_over)

func _on_all_player_dead() -> void:
	get_tree().paused = true
	hud.hide()
	# show game over screen
	var game_over = game_over_scene.instantiate()
	# TODO: give game over screen stats to show in setup function
	gui.add_child(game_over)

func _on_play_button_pressed() -> void:
	# do nothing when no player is connected
	if not multiplayer_node.at_least_one_player_ready():
		return
	
	# remove lobby
	for c in gui.get_children():
		if c is UILobby:
			c.queue_free()
	# spawn level into the world
	var level1 = level1_scene.instantiate()
	world.add_child(level1)
	
	multiplayer_node.spawn_connected_players()
	hud.show()
