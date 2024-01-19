extends Button




func _on_pressed() -> void:
	Signals.play_button_pressed.emit()
