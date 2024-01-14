extends Node

var possible_weapons: Array[Weapon.WeaponType]
var activated_weapons: Array[Weapon.WeaponType]

# {WeaponType: PackedScene}
var all_weapons_on_disk: Dictionary = {
	Weapon.WeaponType.PISTOL: preload("res://weapons/pistol.tscn"),
	Weapon.WeaponType.SMG: preload("res://weapons/smg.tscn")
}

func _ready() -> void:
	for weapon_type in Weapon.WeaponType.values():
		possible_weapons.append(weapon_type)
	
	activated_weapons.append(Weapon.WeaponType.PISTOL)

## schaltet waffe frei
func activate_weapon(weapon_type: Weapon.WeaponType) -> void:
	if not is_weapon_activated(weapon_type):
		activated_weapons.append(weapon_type)

func is_weapon_activated(weapon_type: Weapon.WeaponType) -> bool:
	return weapon_type in activated_weapons

func get_random_from_activated_weapons() -> Weapon.WeaponType:
	return activated_weapons.pick_random()
