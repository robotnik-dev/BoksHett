extends Node3D
class_name AmmoPack

## wid von zomb oder gegner gedropt und ist zufällige waffe oder ammo aus liste

var weapon_type: Weapon.WeaponType

# wird von außen von uns aufgerufen
func setup(_weapon_type: Weapon.WeaponType, _global_position: Vector3) -> void:
	weapon_type = _weapon_type
	global_position = _global_position

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		body.ammopack_collected(weapon_type)
		queue_free()
