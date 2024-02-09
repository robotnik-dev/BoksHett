extends Node3D
class_name Weapon

@export_subgroup("SystemRelevant")
@export var weapon_type: WeaponType = WeaponType.PISTOL:
	set(value):
		weapon_type = value
		var key = WeaponType.find_key(weapon_type)
		if key:
			display_name = str(key)

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
	SMG,
	SHOTGUN
}

var current_ammo: int = 0
var display_name: String
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
	
	apply_activated_upgrades()
	
	self.weapon_type = weapon_type

## virtual
func shoot() -> void:
	pass

func apply_upgrade(upgrade: Upgrade) -> void:
	add_child(upgrade)
	upgrade.setup(self)

## called when weapon is added to the weaponslot
func apply_activated_upgrades() -> void:
	# loop through all upgrades on PointSystem Global
	for upgrade in PointSystem.all_upgrades:
		# select only with same weapon type
		if upgrade.weapon_type == weapon_type:
			# if display name from upgrade in activated_upgrades then:
			if upgrade.display_name in PointSystem.activated_upgrades:
				# add child and setup
				add_child(upgrade.duplicate())
				upgrade.setup(self)

func replenish_ammo() -> void:
	current_ammo = max_ammo
