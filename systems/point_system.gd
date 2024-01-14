extends Node

signal current_combo_multiplier_changed(multiplier: int)
signal current_points_changed(points: int)
signal multiplier_decrease_time_changed(decrease_time: float)

# look up dictionary for all upgrades {ComboMultiplier: Upgrade}
var lut_upgrades: LUTUpgrades = preload("res://resources/first_upgrade_lut.tres")

var activated_upgrades: Array[String]

## derzeitige mult , kann fallen
var current_combo_multiplier: int = 1:
	set(value):
		current_combo_multiplier = clampi(value, 1, value)
		multiplier_decrease_time = _calculate_new_decrease_time(current_combo_multiplier)
		current_combo_multiplier_changed.emit(current_combo_multiplier)
		multiplier_decrease_time_changed.emit(multiplier_decrease_time)
		
		# check for new upgrade
		var upgrade = lut_upgrades.upgrade_dictionary.get(current_combo_multiplier)
		if upgrade:
			# check if already activated
			if upgrade in activated_upgrades:
				print(upgrade + " already activated")
				return
			
			var weapon_upgrade
			for class_dict in ProjectSettings.get_global_class_list():
				if class_dict.get("class") == upgrade:
					weapon_upgrade = load(class_dict.get("path")).new()
			if weapon_upgrade:
				var weapon = get_tree().get_first_node_in_group(Weapon.WeaponType.find_key(weapon_upgrade.weapon_type))
				#weapon_upgrade.owner = weapon
				weapon.add_child(weapon_upgrade)
				weapon_upgrade.setup(weapon)
				activated_upgrades.append(upgrade)

## maximaler multplier erreicht in diesem run ( fällt nicht)
var max_combo_multiplier: int = 0

var current_points: int = 0

## in seconds
var multiplier_decrease_time: float = 3.0

func _ready() -> void:
	Signals.enemy_died.connect(_on_enemy_died)

func _on_enemy_died() -> void:
	# first: get points with old multiplier
	current_points += 100 * current_combo_multiplier
	# raise combo multiplier
	current_combo_multiplier += 1
	# other stuff
	current_points_changed.emit(current_points)

func _calculate_new_decrease_time(_current_combo_multiplier: int) -> float:
	return 3 * pow(exp(1), -(1.0/40.0) * _current_combo_multiplier)
