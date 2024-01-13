extends Node

signal current_combo_multiplier_changed(multiplier)

# look up dictionary for all upgrades {ComboMultiplier: Upgrade}
var upgrade_dictionary: Dictionary

var activated_upgrades: Array[Upgrade]

## derzeitige mult , kann fallen
var current_combo_multiplier: int = 0

## maximaler multplier erreicht in diesem run ( fällt nicht)
var max_combo_multiplier: int = 0

func _ready() -> void:
	Signals.enemy_died.connect(_on_enemy_died)

func _on_enemy_died(multiplier: int) -> void:
	current_combo_multiplier += 1
	current_combo_multiplier_changed.emit(current_combo_multiplier)
