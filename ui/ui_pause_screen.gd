extends Control
class_name UIPauseScreen

func _ready() -> void:
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		#is_paused = !is_paused
		#ui_pause_screen.visible = is_paused
		# TODO: check if game state is in game is running mode(global GameState script)
		if get_tree().paused:
			hide()
			get_tree().paused = false
		else:
			show()
			get_tree().paused = true
