extends Button
class_name UIRestartButton

signal ui_button_pressed

func _on_pressed() -> void:
	get_tree().paused = false
	Signals.restart_level_pressed.emit()
	ui_button_pressed.emit()
