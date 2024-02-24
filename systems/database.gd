extends Node

# global singleton to acces ingame the database

var waves_databases: Array[TextDatabase]

func _ready() -> void:
	
	# TODO: smart way
	for i in range(2):
		var new_db = TextDatabase.new()
		# here deafualt define
		new_db.add_valid_property("enemy_spawner_positions")
		new_db.add_valid_property("player_spawner_positions")
		
		new_db.add_default_property("enemies", [], false)
		new_db.add_default_property("boss", [], false)
		
		new_db.load_from_path("res://data/level/level" + str(i + 1) + "waves.cfg")
		
		waves_databases.append(new_db)


