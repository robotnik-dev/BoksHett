extends Label



func _ready() -> void:
	PointSystem.current_points_changed.connect(_on_points_change)


func _on_points_change(points: int) -> void:
	var new_text: String = str(points)
	text = new_text.lpad(12, "0")
