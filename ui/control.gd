# StartMenu.gd
extends Control

# Cambia la ruta si tu nivel se llama distinto
const LEVEL_PATH := "res://level/level.tscn"

func _ready() -> void:
	# Buscar el botón por su nombre y conectar la señal
	var btn := $"CenterContainer/VBoxContainer/Button"
	btn.pressed.connect(_on_start_pressed)

func _on_start_pressed() -> void:
	if ResourceLoader.exists(LEVEL_PATH):
		get_tree().change_scene_to_file(LEVEL_PATH) # Godot 4
		# En Godot 3.x sería: get_tree().change_scene(LEVEL_PATH)
	else:
		push_error("No se encontró la escena de nivel en: %s" % LEVEL_PATH)


func _on_button_pressed() -> void:
	pass # Replace with function body.
