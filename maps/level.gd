extends Node3D
class_name Level

@export var enemy_spawner_container: Node3D
@export var level: int

var enemy_spawner_scene: PackedScene = preload("res://systems/enemy_spawner.tscn")

func _ready() -> void:
	var data = Database.waves_databases[level - 1].get_array()
	
	var enemy_spawner_positions: Array
	for item in data:
		if item.name == "setup":
			enemy_spawner_positions = item.enemy_spawner_positions
			break
	
	# spawn enemy spawner
	var enemy_spawners: Array[EnemySpawner] = []
	for spawn_position in enemy_spawner_positions:
		var enemy_spawner: EnemySpawner = enemy_spawner_scene.instantiate()
		enemy_spawner_container.add_child(enemy_spawner)
		enemy_spawner.setup(spawn_position)
		enemy_spawners.append(enemy_spawner)
	
	start_waves(enemy_spawners)
	
	Signals.level_starts.emit(level)

func start_waves(enemy_spawners) -> void:
	for spawner in enemy_spawners:
		spawner.start_waves()
