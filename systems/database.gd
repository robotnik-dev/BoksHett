extends Node

# global singleton to acces ingame the database

var waves_databases: Array[TextDatabase]

func _ready() -> void:
	# TODO: smart way
	for i in range(1, 3):
		var wave_database = TextDatabase.new()
		# valid means optional
		wave_database.add_valid_property("enemy_spawner_positions")
		wave_database.add_valid_property("player_spawner_positions")
		
		# default means default
		wave_database.add_default_property("enemies", [], false)
		wave_database.add_default_property("boss", [], false)
		# raise time for completion with every level
		wave_database.add_default_property("time_for_completion", i * 20.0, false)
		
		# mandatory
		
		wave_database.load_from_path("res://data/level/level" + str((i-1) + 1) + "waves.cfg")
		
		waves_databases.append(wave_database)
