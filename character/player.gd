extends CharacterBody3D
class_name Player

@export var speed: float = 0.0
@export var max_health: float = 10.0
var current_health: float = 0.0:
	set(value):
		current_health = value
		if current_health <= 0:
			die()

@onready var weapon_slot: WeaponSlot = $WeaponSlot

func _ready() -> void:
	current_health = max_health


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_cancel"):
		#PlayerInfo.activate_weapon(Weapon.WeaponType.SMG)

func _physics_process(delta: float) -> void:
	
	var direction: Vector3 = Vector3.ZERO
	
	if Input.get_action_strength("move_right"):
		direction.x = 1.0
	if Input.get_action_strength("move_left"):
		direction.x = -1.0
	if Input.get_action_strength("move_down"):
		direction.z = 1.0
	if Input.get_action_strength("move_up"):
		direction.z = -1.0
	
	if direction.length() > 0:
		rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP)
	
	velocity = direction.normalized() * speed * delta
	
	move_and_slide()
	
	if Input.is_action_pressed("shoot"):
		weapon_slot.shoot()

func ammopack_collected(weapon_type: Weapon.WeaponType) -> void:
	weapon_slot.add_ammo_or_weapon(weapon_type)

func take_damage(damage: float) -> void:
	current_health -= damage

func die() -> void:
	queue_free()
