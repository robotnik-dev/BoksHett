extends CharacterBody3D
class_name Enemy

@export var max_health: float = 2.0
var current_health: float = 0.0:
	set(value):
		current_health = value
		if current_health <= 0:
			die()

func _ready() -> void:
	current_health = max_health

func take_weapon_damage(damage: float) -> void:
	current_health -= damage

func die() -> void:
	queue_free()
