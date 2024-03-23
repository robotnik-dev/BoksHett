extends Node

signal enemy_died
signal show_connected_player_with(device_id: int)
signal level_starts(level: int)
signal wave_changed(wave: int)
signal level_won

# UI
signal play_button_pressed
signal restart_level_pressed
signal back_to_menu_pressed
signal to_lobby_pressed
