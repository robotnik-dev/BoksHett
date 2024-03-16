extends Node3D
class_name Level

@export var enemy_spawner_container: Node3D
@export var level: int

var enemy_spawner_scene: PackedScene = preload("res://systems/enemy_spawner.tscn")

var enemy_spawners: Array[EnemySpawner] = []
var current_wave: int = 1
var timer = Timer.new()
var enemy_spawners_with_no_enemies_alive: Array[EnemySpawner] = []

func _ready() -> void:
	var data = Database.waves_databases[level - 1].get_array()
	
	var enemy_spawner_positions: Array
	for item in data:
		if item.name == "setup":
			enemy_spawner_positions = item.enemy_spawner_positions
			break
	
	# spawn enemy spawner
	for spawn_position in enemy_spawner_positions:
		var enemy_spawner: EnemySpawner = enemy_spawner_scene.instantiate()
		enemy_spawner_container.add_child(enemy_spawner)
		enemy_spawner.setup(spawn_position)
		enemy_spawners.append(enemy_spawner)
	
	# tell each enemy spawner that current wave should start with 
	# number of enemies spawning
	start_wave(current_wave)
	
	Signals.level_starts.emit(level)

func start_wave(wave: int) -> void:
	#print("WAVE STARTED: " + str(current_wave))
	var data = Database.waves_databases[level - 1].get_array()
	
	for item in data:
		if item.name == str(current_wave):
			
			var time_for_completion = item.time_for_completion as float
			
			# setup timer
			if timer:
				if timer.timeout.is_connected(wave_ended):
					timer.timeout.disconnect(wave_ended)
				
				for child in get_children():
					if child is Timer:
						child.queue_free()
			
			timer = Timer.new()
			timer.wait_time = time_for_completion
			timer.one_shot = true
			add_child(timer)
			timer.timeout.connect(wave_ended.bind(current_wave))
			timer.start()
			
			# setup enemies
			# tell each enemy_spawner how many enemies and bosses
			var idx = 0
			var enemies = item.enemies as Array
			var bosses = item.boss as Array
			for enemy_spawner in enemy_spawners:
				var amount_of_enemies = enemies[idx]
				var amount_of_bosses = 0
				if not bosses.is_empty():
					amount_of_bosses = bosses[idx]
				if not enemy_spawner.all_enemies_dead.is_connected(_on_spawner_all_dead):
					enemy_spawner.all_enemies_dead.connect(_on_spawner_all_dead.bind(enemy_spawner))
				enemy_spawner.start_wave(amount_of_enemies, amount_of_bosses)
				
				idx += 1
	

func _on_spawner_all_dead(enemy_spawner: EnemySpawner) -> void:
	#print("SPAWNER: " + enemy_spawner.name + " NO ALIVE")
	enemy_spawners_with_no_enemies_alive.append(enemy_spawner)
	#print("enemy_spawners_with_no_enemies_alive: " + str(enemy_spawners_with_no_enemies_alive))
	
	# check if this functions got called number of times equal
	# number of enemy_spawenr
	# then definitely all dead
	if enemy_spawners.size() == enemy_spawners_with_no_enemies_alive.size():
		# no enmies alive
		wave_ended(current_wave)

## gets called if time is over or enemies dead
## two ways to start new wave
## 1. all enemies dead
## 2. time over
func wave_ended(wave: int) -> void:
	enemy_spawners_with_no_enemies_alive.clear()
	#print("WAVE ENDED: " + str(wave))
	# TODO: other stuff
	# stop current timer
	timer.stop()
	
	# at the end, current_wave += 1
	current_wave += 1
	
	# start new wave if current_wave is not maximum wave
	# and is not triggered through timer
	start_wave(current_wave)
	
	# else:
	# TODO: WIN
