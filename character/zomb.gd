extends CharacterBody3D
class_name Enemy

@export var max_health: float = 2.0
@export var speed: float = 100.0
@export var attack_cooldown_time: float = 0.5
@export var damage: float = 1.0

var cooldown_timer: Timer

var player_in_reach: bool = false
var player_to_hit: Player

var current_health: float = 0.0:
	set(value):
		current_health = value
		if current_health <= 0:
			die()

func _ready() -> void:
	current_health = max_health
	# build timer
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = attack_cooldown_time
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)

func _physics_process(delta: float) -> void:
	
	var direction: Vector3 = Vector3.ZERO
	
	var player: Player = get_tree().get_first_node_in_group("player")
	direction = global_position.direction_to(player.global_position)
	
	if direction.length() > 0:
		rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP)
	
	velocity = direction.normalized() * speed * delta
	
	move_and_slide()
	
	# handle damage to player
	if player_in_reach:
		if not cooldown_timer.time_left > 0:
			# can make damage to player
			if player_to_hit:
				player.take_damage(damage)
				cooldown_timer.start()

func take_weapon_damage(damage: float) -> void:
	current_health -= damage

func die() -> void:
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	player_in_reach = true
	if body is Player:
		player_to_hit = body


func _on_hit_box_body_exited(body: Node3D) -> void:
	player_in_reach = false
	if body is Player:
		player_to_hit = null