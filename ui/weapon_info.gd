extends Label3D

@export var weapon_slot: WeaponSlot

var display_max_ammo: int
var display_ammo: int
var display_weapon_name: String

func _ready() -> void:
	weapon_slot.ammo_changed.connect(_on_ammo_changed)
	weapon_slot.current_weapon_changed.connect(_on_weapon_changed)
	weapon_slot
	_set_display_name()
	

func _on_ammo_changed(new_ammo: int) -> void:
	display_ammo = new_ammo
	_set_display_name()

func _on_weapon_changed(weapon_name: String, new_max_ammo: int, new_current_ammo: int) -> void:
	display_weapon_name = weapon_name
	display_max_ammo = new_max_ammo
	display_ammo = new_current_ammo
	_set_display_name()

func _set_display_name() -> void:
	text = display_weapon_name + ":" + " [ " + str(display_ammo) + " / " + str(display_max_ammo) + " ] "
