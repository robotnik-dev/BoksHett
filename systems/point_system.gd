extends Node

signal current_combo_multiplier_changed(multiplier: int)
signal current_points_changed(points: int)
signal multiplier_decrease_time_changed(decrease_time: float)

# look up dictionary for all upgrades {ComboMultiplier: Upgrade}
var lut_upgrades: LUTUpgrades = preload("res://resources/first_upgrade_lut.tres")

var activated_upgrades: Array[String]
var all_upgrades: Array[Upgrade]

## derzeitige mult , kann fallen
var current_combo_multiplier: int = 1:
	set(value):
		current_combo_multiplier = clampi(value, 1, value)
		multiplier_decrease_time = _calculate_new_decrease_time(current_combo_multiplier)
		current_combo_multiplier_changed.emit(current_combo_multiplier)
		multiplier_decrease_time_changed.emit(multiplier_decrease_time)
		
		
		#FIXME: system change: player that get respawned own all upgrades but not all weapons
		# so adding them to the weapons dont work if they do not own them yet (respawn delete all weapon)
		# check for new upgrade
		var upgrade_name = lut_upgrades.upgrade_dictionary.get(current_combo_multiplier)
		
		if upgrade_name:
			# check if already activated
			if upgrade_name in activated_upgrades:
				return
			
			# TODO: only weapon upgrades, make weapons also work
			var weapon_upgrade_res
			var is_weapon_upgrade: bool = false
			for class_dict in ProjectSettings.get_global_class_list():
				if class_dict.get("class") == upgrade_name:
					# is weapon upgrade_name
					weapon_upgrade_res = load(class_dict.get("path"))
					is_weapon_upgrade = true
			
			# only when weapon upgrade
			if is_weapon_upgrade:
				# if weapon_upgrade:
				# all weapons from all player
				for weapon in get_tree().get_nodes_in_group(Weapon.WeaponType.find_key(weapon_upgrade_res.new().weapon_type)):
					var new_weapon_upgrade = weapon_upgrade_res.new()
					weapon.apply_upgrade(new_weapon_upgrade)
					# FIXME es wird gerade  sehr oft hinzugefügt (mind. 4x)
					activated_upgrades.append(new_weapon_upgrade.display_name)
			
			# when weapon
			elif not is_weapon_upgrade:
				 # TODO
				# where dowe do ths f*cking shit
				# Weapon as child to all players
				# Weapons to actiavted_weapon, see Player_Info.gd
				pass

## maximaler multplier erreicht in diesem run ( fällt nicht)
var max_combo_multiplier: int = 0

var current_points: int = 0

## in seconds
var multiplier_decrease_time: float = 3.0

func _ready() -> void:
	Signals.enemy_died.connect(_on_enemy_died)
	
	add_all_upgrades_to_list()

## called only once
func add_all_upgrades_to_list() -> void:
	for key in lut_upgrades.upgrade_dictionary.keys():
		var value = lut_upgrades.upgrade_dictionary.get(key)
		for class_dict in ProjectSettings.get_global_class_list():
			# when weapon upgrade
			if class_dict.get("class") == value:
				var weapon_upgrade = load(class_dict.get("path")).new()
				all_upgrades.append(weapon_upgrade)
				# FIXME: is not pretty
				add_child(weapon_upgrade)

func _on_enemy_died() -> void:
	# first: get points with old multiplier
	current_points += 100 * current_combo_multiplier
	# raise combo multiplier
	current_combo_multiplier += 1
	# other stuff
	current_points_changed.emit(current_points)

func _calculate_new_decrease_time(_current_combo_multiplier: int) -> float:
	return 3 * pow(exp(1), -(1.0/40.0) * _current_combo_multiplier)
