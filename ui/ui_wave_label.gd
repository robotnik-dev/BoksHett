extends Label
class_name UIWaveLabel

func _ready() -> void:
	Signals.wave_changed.connect(_on_wave_changed)
	
	_on_wave_changed(1)

func _on_wave_changed(wave: int) -> void:
	text = "Wave: " + str(wave)
