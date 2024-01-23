extends Node3D
class_name Weapon

@export_subgroup("SystemRelevant")
@export var weapon_type: WeaponType = WeaponType.PISTOL

@export_subgroup("WeaponProperties")
@export var max_ammo: int = 0
@export var cooldown_time: float = 1.0:
	set(value):
		cooldown_time = value
		if cooldown_timer:
			cooldown_timer.wait_time = cooldown_time

@export var damage: float = 1.0


enum WeaponType {
	PISTOL,
	SMG
}

var current_ammo: int = 0

var cooldown_timer: Timer

func _ready() -> void:
	# build timer
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = cooldown_time
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
	#cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	replenish_ammo()
	
	# add to group for point system to find this Node
	add_to_group(WeaponType.find_key(weapon_type))

## virtual
func shoot() -> void:
	pass

func replenish_ammo() -> void:
	current_ammo = max_ammo
