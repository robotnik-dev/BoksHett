extends MeshInstance3D
class_name EnemySpawner

signal all_enemies_dead

var zomb_scene: PackedScene = preload("res://character/zomb.tscn")
var boss_scene: PackedScene = preload("res://character/boss.tscn")

var zombs_spawned: Array[Enemy]
var zombs_alive: Array[Enemy]
var zombs_to_be_spawned: int
var zomb_delay_timer = Timer.new()

var bosses_spawned: Array[Enemy]
var bosses_alive: Array[Enemy]
var bosses_to_be_spawned: int
var boss_delay_timer = Timer.new()

func _ready() -> void:
	add_child(zomb_delay_timer)
	add_child(boss_delay_timer)

func setup(spawn_position) -> void:
	global_position = spawn_position

## gets called from level scene
func start_wave(amount_of_zombs: int, amount_of_bosses: int) -> void:
	# add timer for spawn delay because they get over one another when
	# spawning immediately
	# evtl. random spawn position in radius
	# spawn each enemy
	if amount_of_zombs == 0 and amount_of_bosses == 0:
		if zombs_alive.is_empty() and bosses_alive.is_empty():
			all_enemies_dead.emit()
		return
	
	zombs_spawned.clear()
	bosses_spawned.clear()
	
	zombs_to_be_spawned = amount_of_zombs
	bosses_to_be_spawned = amount_of_bosses
	
	zomb_delay_timer.stop()
	zomb_delay_timer.wait_time = 0.5
	zomb_delay_timer.one_shot = false
	if not zomb_delay_timer.timeout.is_connected(spawn_zomb):
		zomb_delay_timer.timeout.connect(spawn_zomb)
	zomb_delay_timer.start()
	
	boss_delay_timer.stop()
	boss_delay_timer.wait_time = 3.0
	boss_delay_timer.one_shot = false
	if not boss_delay_timer.timeout.is_connected(spawn_boss):
		boss_delay_timer.timeout.connect(spawn_boss)
	boss_delay_timer.start()

func spawn_zomb() -> void:
	if zombs_to_be_spawned == zombs_spawned.size():
		zomb_delay_timer.stop()
		return
	var zomb = zomb_scene.instantiate()
	add_child(zomb)
	zombs_spawned.append(zomb)
	zombs_alive.append(zomb)
	#print("ENEMY SPAWNER: " + name)
	#print("ZOMBS ALIVE: " + str(zombs_alive.size()))
	zomb.died.connect(
		func(): zombs_alive.erase(zomb); _check_all_enemies_dead()
	)

func spawn_boss() -> void:
	if bosses_to_be_spawned == bosses_spawned.size():
		boss_delay_timer.stop()
		return
	var boss = boss_scene.instantiate()
	add_child(boss)
	bosses_spawned.append(boss)
	bosses_alive.append(boss)
	#print("ENEMY SPAWNER: " + name)
	#print("BOSSES ALIVE: " + str(bosses_alive.size()))
	boss.died.connect(
		func(): bosses_alive.erase(boss); _check_all_enemies_dead()
	)

func _check_all_enemies_dead() -> void:
	#print("CHECK ALL DEAD")
	#print("BOSSES ALIVE: " + str(bosses_alive.size()))
	#print("ZOMBS ALIVE: " + str(zombs_alive.size()))
	
	if zombs_alive.is_empty() and bosses_alive.is_empty():
		zombs_spawned.clear()
		bosses_spawned.clear()
		all_enemies_dead.emit()
