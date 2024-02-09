extends Node3D
class_name Level

@export var enemy_spawner: EnemySpawner

func _ready() -> void:
	enemy_spawner.start_waves()
