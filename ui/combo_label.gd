extends MarginContainer

@export var combo_multiplier: Label
@export var progress: ProgressBar

var multiplier: int

var tween: Tween

func _ready() -> void:
	PointSystem.current_combo_multiplier_changed.connect(_on_multiplier_change)
	PointSystem.multiplier_decrease_time_changed.connect(_on_decrease_time_changed)


func _on_multiplier_change(_multiplier: int) -> void:
	multiplier = _multiplier
	combo_multiplier.text = "x" + str(multiplier)


func _on_decrease_time_changed(decrease_time: float) -> void:
	if tween:
		tween.kill()
	
	progress.value = progress.max_value
	if multiplier == 1:
		return
	
	tween = create_tween()
	tween.tween_property(progress, "value", 0.0, decrease_time)
	tween.finished.connect(_on_tween_finished)


func _on_tween_finished() -> void:
	PointSystem.current_combo_multiplier -= 1
