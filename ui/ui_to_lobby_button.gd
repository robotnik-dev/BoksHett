extends Button
class_name UIToLobbyButton

func _on_pressed() -> void:
	Signals.to_lobby_pressed.emit()
