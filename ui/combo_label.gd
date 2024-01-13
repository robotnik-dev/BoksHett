extends Label


func _ready() -> void:
	Upgrades.current_combo_multiplier_changed.connect(_on_multiplier_change)


func _on_multiplier_change(multiplier: int) -> void:
	text = "x" + str(multiplier)
