extends PanelContainer
class_name UIPlayerBox

@export var connect_controller_to_play_button: Button
@export var player_name_label: Label
@export var remove_button: Button
@export var container: VBoxContainer


func show_player() -> void:
	container.show()
	connect_controller_to_play_button.hide()

