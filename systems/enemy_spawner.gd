extends MeshInstance3D
class_name EnemySpawner

var zomb_scene: PackedScene = preload("res://character/zomb.tscn")

@onready var spawn_timer: Timer = $SpawnTimer

func spawn_zomb() -> void:
	var zomb = zomb_scene.instantiate()
	add_child(zomb)

func _on_spawn_timer_timeout() -> void:
	spawn_zomb()
