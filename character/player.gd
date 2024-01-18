extends CharacterBody3D
class_name Player

signal health_depleted

@export var player: int = 1
@export var color: Color
@export var speed: float = 0.0
@export var max_health: float = 10.0
var current_health: float = 0.0:
	set(value):
		current_health = value
		if current_health <= 0:
			health_depleted.emit()

@onready var weapon_slot: WeaponSlot = $WeaponSlot

func _ready() -> void:
	current_health = max_health
	$MeshInstance3D2.material_override.albedo_color = color

func _physics_process(delta: float) -> void:
	
	var direction: Vector3 = Vector3.ZERO
	
	if Input.get_action_strength(_get_input_action("move_right")):
		direction.x = 1.0
	if Input.get_action_strength(_get_input_action("move_left")):
		direction.x = -1.0
	if Input.get_action_strength(_get_input_action("move_down")):
		direction.z = 1.0
	if Input.get_action_strength(_get_input_action("move_up")):
		direction.z = -1.0
	
	if direction.length() > 0:
		rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP)
	
	velocity = direction.normalized() * speed * delta
	
	move_and_slide()
	
	if Input.is_action_pressed(_get_input_action("shoot")):
		weapon_slot.shoot()

func ammopack_collected(weapon_type: Weapon.WeaponType) -> void:
	weapon_slot.add_ammo_or_weapon(weapon_type)

func take_damage(damage: float) -> void:
	current_health -= damage

## gets called from parent (multiplayer)
func die() -> void:
	# play death anim
	# etc.
	print("player lies helpless on floor")

func _get_input_action(original: String) -> String:
	return original + str(player)
