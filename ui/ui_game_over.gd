extends Control
class_name UIGameOver

@export var button_container: HBoxContainer

func _ready() -> void:
	for c in button_container.get_children():
		c.ui_button_pressed.connect(_on_btn_pressed)

func _on_btn_pressed() -> void:
	queue_free()
