extends Node3D
class_name Weapon

@export var max_ammo: int = 0
@export var cooldown_time: float = 1.0
@export var damage: float = 1.0
@export var raycast: bool = true
@export var _range: float = 0.0

var current_ammo: int = 0
var raycast_node: RayCast3D
var cooldown_timer: Timer

func _ready() -> void:
	if raycast:
		raycast_node = $RayCast3D
	
	# build timer
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = cooldown_time
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
	#cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	current_ammo = max_ammo
	
	raycast_node.target_position.y = -_range

func shoot() -> void:
	# check if cooldown is on
	if cooldown_timer.time_left > 0:
		#print("cooldown active")
		return
	
	# check ammo
	if current_ammo <= 0:
		print("no ammo")
		# in the same frequency as cooldown timer (NO SPAM)
		return
	
	print("shoot")
	# reduce ammo
	current_ammo -= 1
	# start cooldown
	cooldown_timer.start()
	
	
	# muzzle fire
	# sound
	
	# spawn projectile (raycast or not)
	if raycast_node:
		if raycast_node.is_colliding():
			var colliding_object = raycast_node.get_collider()
			if colliding_object.has_method("take_weapon_damage"):
				colliding_object.take_weapon_damage(damage)

#func _on_cooldown_timer_timeout() -> void:
	#pass
