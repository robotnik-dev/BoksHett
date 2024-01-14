extends Upgrade
class_name PistolFastFire

func _ready() -> void:
	display_name = "Pistol: Fast Fire"
	weapon_type = Weapon.WeaponType.PISTOL

func setup(_weapon: Weapon) -> void:
	weapon = _weapon
	apply()

func apply() -> void:
	weapon.cooldown_time = 0.5
