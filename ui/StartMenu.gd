extends Control

# ------------------ CONSTANTES ------------------
const LEVEL_PATH := "res://level/level.tscn"   			# Ruta de la escena de nivel
const OPTIONS_PATH := "res://ui/OptionsMenu.tscn"      	# Ruta de la escena de opciones
const HOVER_SCALE := Vector2(1.1, 1.1)         			# Escala al hacer hover
const NORMAL_SCALE := Vector2(1.0, 1.0)        			# Escala normal
const BTN_ANIM_TIME := 0.18                    			# Duración hover animación
const ENTRY_FADE_TIME := 0.25
const ENTRY_SCALE_TIME := 0.55
const EXIT_SCALE_TIME := 0.45
const EXIT_FADE_TIME := 0.30

# ------------------ NODOS ------------------
@onready var center_container: Control = $"CenterContainer"
@onready var title_label: Label = $"CenterContainer/VBoxContainer/Label"
@onready var start_button: Button = $"CenterContainer/VBoxContainer/Button"
@onready var options_button: Button = $"CenterContainer/VBoxContainer/Button2"

func _ready() -> void:
	# Esperamos un frame para asegurarnos de que los nodos ya tienen tamaño real
	await get_tree().process_frame
	
	# Establecemos los pivotes en el centro
	center_container.pivot_offset = center_container.size * 0.5
	start_button.pivot_offset = start_button.size * 0.5
	options_button.pivot_offset = options_button.size * 0.5

	# Conexión de señales
	start_button.mouse_entered.connect(_on_button_hover)
	start_button.mouse_exited.connect(_on_button_exit)
	options_button.mouse_entered.connect(_on_button_hover.bind(options_button))
	options_button.mouse_exited.connect(_on_button_exit.bind(options_button))

	# Animación inicial
	_play_entry_animation()


# ------------------ ANIMACIÓN DE ENTRADA ------------------
func _play_entry_animation() -> void:
	center_container.scale = Vector2(0.01, 0.01)
	center_container.modulate.a = 0.0

	var t := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).bind_node(center_container)

	t.tween_property(center_container, "modulate:a", 1.0, ENTRY_FADE_TIME)
	t.tween_property(center_container, "scale", NORMAL_SCALE, ENTRY_SCALE_TIME)
	t.tween_property(center_container, "scale", NORMAL_SCALE * 1.03, 0.08)
	t.tween_property(center_container, "scale", NORMAL_SCALE, 0.08)


# ------------------ EFECTO DE HOVER DEL BOTÓN ------------------
func _on_button_hover() -> void:
	var t := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).bind_node(start_button)
	t.tween_property(start_button, "scale", HOVER_SCALE, BTN_ANIM_TIME)
	t.parallel().tween_property(start_button, "modulate", Color(1.1, 1.1, 1.1), BTN_ANIM_TIME)

func _on_button_exit() -> void:
	var t := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).bind_node(start_button)
	t.tween_property(start_button, "scale", NORMAL_SCALE, BTN_ANIM_TIME)
	t.parallel().tween_property(start_button, "modulate", Color.WHITE, BTN_ANIM_TIME)


# ------------------ HANDLERS ------------------
func _on_start_pressed() -> void:
	await _play_exit_and_change(LEVEL_PATH)

func _on_options_pressed() -> void:
	await _play_exit_and_change(OPTIONS_PATH)


# ------------------ UTILS ------------------
func _play_exit_and_change(path: String) -> void:
	var t := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN).bind_node(center_container)
	t.tween_property(center_container, "scale", Vector2(0.01, 0.01), EXIT_SCALE_TIME)
	t.parallel().tween_property(center_container, "modulate:a", 0.0, EXIT_FADE_TIME)

	await t.finished

	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)
	else:
		push_error("No se encontró la escena en: %s" % path)
