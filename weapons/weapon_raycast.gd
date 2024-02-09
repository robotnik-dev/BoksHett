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

## TODO: impl
@export var number_of_shots_fired: int = 1
## TODO: impl
@export var pierce: int = 1
@export_range(0.0, 180.0, 1.0) var shooting_angle: float

func _ready() -> void:
	super._ready()
	_range = _range

func shoot() -> void:
	# check if cooldown is on
	if cooldown_timer.time_left > 0:
		return
	
	# check ammo
	if current_ammo <= 0:
		#print("no ammo")
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
		# turn raycast to shooting angle
		raycast.rotation_degrees.y = randf_range(-shooting_angle, shooting_angle)
		
		if raycast.is_colliding():
			var colliding_object = raycast.get_collider()
			# test if it is already dead
			if colliding_object:
				if colliding_object.has_method("take_damage"):
					colliding_object.take_damage(damage)
		
				var final_destination = raycast.to_local(colliding_object.global_position)
				Line3D.line(raycast, raycast.position, final_destination, Color(0.61898851394653, 0, 0), -1)
	
		else:
			var final_destination = raycast.target_position
			Line3D.line(raycast, raycast.position, final_destination, Color(0.61898851394653, 0, 0), -1)
