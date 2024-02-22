extends Node3D
class_name WeaponSlot

signal current_weapon_changed(new_weapon_name: String, new_max_ammo: int, new_current_ammo: int)
signal ammo_changed(new_value: int)

var equiped_weapon: Weapon:
	set(value):
		equiped_weapon = value
		
		current_weapon_changed.emit(
			equiped_weapon.display_name,
			equiped_weapon.max_ammo,
			equiped_weapon.current_ammo
		)

var weapon_idx = 0:
	set(value):
		# get_child_count return number from 1 to max so deshalb die - 1
		# get_child(idx) needs from 0 to max - 1
		var maximum = get_child_count() - 1
		# under 0 -> go to maximum
		if value < 0:
			weapon_idx = maximum
		# over maximum -> go to 0
		elif value > maximum:
			weapon_idx = 0
		else:
			weapon_idx = value

var player: Player

func _ready() -> void:
	#add_ammo_or_weapon(Weapon.WeaponType.PISTOL)
	#equiped_weapon = get_child(0)
	#equip_weapon()
	player = owner
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(player._get_input_action("next_weapon")):
		next()
	elif event.is_action_pressed(player._get_input_action("previous_weapon")):
		previous()

func shoot() -> void:
	equiped_weapon.shoot()
	ammo_changed.emit(equiped_weapon.current_ammo)

func next() -> void:
	weapon_idx += 1
	equip_weapon()

func previous() -> void:
	weapon_idx -= 1
	equip_weapon()

func equip_weapon() -> void:
	equiped_weapon.hide()
	equiped_weapon = get_child(weapon_idx)
	equiped_weapon.show()

func add_ammo_or_weapon(weapon_type: Weapon.WeaponType) -> void:
	# add ammo if weapon exists
	for weapon in get_children():
		weapon = weapon as Weapon
		if weapon.weapon_type == weapon_type:
			weapon.replenish_ammo()
			ammo_changed.emit(equiped_weapon.current_ammo)
			return
	
	# when no weapon of this type exists
	var weapon_scene: PackedScene = PlayerInfo.all_weapons_on_disk.get(weapon_type)
	if not weapon_scene:
		printerr("not implemented error: forgot to implement weapon: " + str(weapon_type))
		return
	
	var new_weapon = weapon_scene.instantiate()
	add_child(new_weapon)
	new_weapon.hide()


@warning_ignore("unused_parameter")
func _on_child_entered_tree(node: Node) -> void:
	# sorting of weapons
	for child in get_children():
		var weapon = child as Weapon
		var key = Weapon.WeaponType.find_key(weapon.weapon_type)
		var idx = Weapon.WeaponType.get(key)
		move_child.call_deferred(child, idx)
