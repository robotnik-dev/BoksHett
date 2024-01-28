extends Weapon
class_name WeaponRaycast

@export_subgroup("RaycastSpecifics")
@export var raycast_nodes: Array[RayCast3D]
@export var _range: float = 0.0:
	set(value):
		_range = value
		if raycast_nodes:
			for raycast in raycast_nodes:
				raycast.target_position.y = -_range

func _ready() -> void:
	super._ready()
	_range = _range

func shoot() -> void:
	# check if cooldown is on
	if cooldown_timer.time_left > 0:
		return
	
	# check ammo
	if current_ammo <= 0:
		print("no ammo")
		# in the same frequency as cooldown timer (NO SPAM)
		return
	
	# reduce ammo
	current_ammo -= 1
	# start cooldown
	cooldown_timer.start()
	
	# muzzle fire
	# sound
	
	# spawn projectile (raycast or not)
	for raycast in raycast_nodes:
		if raycast.is_colliding():
			var colliding_object = raycast.get_collider()
			if colliding_object.has_method("take_damage"):
				colliding_object.take_damage(damage)
		
			var final_destination = raycast.to_local(colliding_object.global_position)
			Line3D.line(raycast, raycast.position, final_destination, Color(0.61898851394653, 0, 0), -1)
	
		else:
			var final_destination = raycast.target_position
			Line3D.line(raycast, raycast.position, final_destination, Color(0.61898851394653, 0, 0), -1)
