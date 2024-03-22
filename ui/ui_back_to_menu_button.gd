extends Button
class_name UIBackToMenuButton

signal ui_button_pressed

func _on_pressed() -> void:
	get_tree().paused = false
	Signals.back_to_menu_pressed.emit()
	ui_button_pressed.emit()
