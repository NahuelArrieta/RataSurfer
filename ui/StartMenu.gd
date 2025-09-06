extends Control

# ------------------ CONSTANTES ------------------
const LEVEL_PATH := "res://cutscenes/MainCutscene.tscn"
const OPTIONS_PATH := "res://ui/OptionsMenu.tscn"
const HOVER_SCALE := Vector2(1.1, 1.1)
const NORMAL_SCALE := Vector2(1.0, 1.0)
const BTN_ANIM_TIME := 0.18
const ENTRY_FADE_TIME := 0.25
const ENTRY_SCALE_TIME := 0.55
const EXIT_SCALE_TIME := 0.45
const EXIT_FADE_TIME := 0.30

# ------------------ NODOS ------------------
@onready var title_label: TextureRect = $VBoxContainer/Label
@onready var start_button: TextureButton = $VBoxContainer/Button
@onready var options_button: TextureButton = $VBoxContainer/Button2
@onready var menu_player: AudioStreamPlayer = $"MenuPlayer"
@onready var vbox: VBoxContainer = $VBoxContainer
#@onready var margin: MarginContainer = $"HBoxContainer/MarginContainer"

func _ready() -> void:
	# 🔊 Cargar y aplicar settings
	Settings.load_settings()
	Settings.apply_volumes()

	# Ajustar margen superior para bajar el bloque (título + botones)
	#margin.add_theme_constant_override("margin_top", 220) # 🔽 bajá este valor para más espacio

	# Esperamos un frame para asegurar tamaños
	await get_tree().process_frame

	# Establecemos pivotes solo en los botones
	start_button.pivot_offset = start_button.size * 0.5
	options_button.pivot_offset = options_button.size * 0.5

	# Conexión de señales
	start_button.mouse_entered.connect(_on_button_hover.bind(start_button))
	start_button.mouse_exited.connect(_on_button_exit.bind(start_button))
	options_button.mouse_entered.connect(_on_button_hover.bind(options_button))
	options_button.mouse_exited.connect(_on_button_exit.bind(options_button))

	# Animación inicial
	_play_entry_animation()

# ------------------ ANIMACIÓN DE ENTRADA ------------------
func _play_entry_animation() -> void:
	vbox.scale = Vector2(0.01, 0.01)
	vbox.modulate.a = 0.0

	var t := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).bind_node(vbox)
	t.tween_property(vbox, "modulate:a", 1.0, ENTRY_FADE_TIME)
	t.tween_property(vbox, "scale", NORMAL_SCALE, ENTRY_SCALE_TIME)
	t.tween_property(vbox, "scale", NORMAL_SCALE * 1.03, 0.08)
	t.tween_property(vbox, "scale", NORMAL_SCALE, 0.08)

# ------------------ EFECTO DE HOVER ------------------
func _on_button_hover(btn: Button) -> void:
	var t := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).bind_node(btn)
	t.tween_property(btn, "scale", HOVER_SCALE, BTN_ANIM_TIME)
	t.parallel().tween_property(btn, "modulate", Color(1.1, 1.1, 1.1), BTN_ANIM_TIME)

func _on_button_exit(btn: Button) -> void:
	var t := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).bind_node(btn)
	t.tween_property(btn, "scale", NORMAL_SCALE, BTN_ANIM_TIME)
	t.parallel().tween_property(btn, "modulate", Color.WHITE, BTN_ANIM_TIME)

# ------------------ HANDLERS ------------------
func _on_start_pressed() -> void:
	await _play_exit_and_change(LEVEL_PATH)

func _on_options_pressed() -> void:
	await _play_exit_and_change(OPTIONS_PATH)

# ------------------ UTILS ------------------
func _play_exit_and_change(path: String) -> void:
	var t := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN).bind_node(vbox)
	t.tween_property(vbox, "scale", Vector2(0.01, 0.01), EXIT_SCALE_TIME)
	t.parallel().tween_property(vbox, "modulate:a", 0.0, EXIT_FADE_TIME)

	await t.finished

	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)
	else:
		push_error("No se encontró la escena en: %s" % path)
