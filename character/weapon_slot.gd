extends Node3D
class_name WeaponSlot

var equiped_weapon: Weapon
var weapon_idx = 0

func _ready() -> void:
	equiped_weapon = get_child(weapon_idx)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("next_weapon"):
		next()
	elif event.is_action_pressed("previous_weapon"):
		previous()

func shoot() -> void:
	equiped_weapon.shoot()

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
