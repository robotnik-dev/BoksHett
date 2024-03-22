extends Control
class_name UILobby

@export var player_boxes: Array[UIPlayerBox]

func _ready() -> void:
	Signals.show_connected_player_with.connect(_on_new_device_connected)

## device_id: 0-3
func _on_new_device_connected(device_id: int) -> void:
	player_boxes[device_id].show_player()
