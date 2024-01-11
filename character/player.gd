extends CharacterBody3D

@export var speed: float = 0.0

@onready var weapon_slot: Node3D = $WeaponSlot


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
		if weapon_slot.get_child_count() > 0:
			weapon_slot.get_child(0).shoot()
