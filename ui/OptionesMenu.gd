extends Control

# ------------------ CONSTANTES ------------------
const START_MENU_PATH := "res://ui/StartMenu.tscn"

# ------------------ NODOS ------------------
@onready var music_slider: HSlider = $VBoxContainer/MusicSlider
@onready var sfx_slider: HSlider   = $VBoxContainer/SfxSlider
@onready var back_button: TextureButton   = $VBoxContainer/BackButton

func _ready() -> void:
	# 🔊 Cargar valores guardados
	Settings.load_settings()

	print("=== INIT OPTIONS MENU ===")
	print("Music:", Settings.music_volume)
	print("SFX:", Settings.sfx_volume)

	# Inicializar sliders con valores de Settings
	music_slider.value = Settings.music_volume * 100
	sfx_slider.value   = Settings.sfx_volume   * 100

	# Aplicar los volúmenes al cargar
	Settings.apply_volumes()

	# Hover del botón
	back_button.mouse_entered.connect(_on_button_hover.bind(back_button))
	back_button.mouse_exited.connect(_on_button_exit.bind(back_button))

	await get_tree().process_frame
	_set_pivots_to_center()

# ------------------ HANDLERS ------------------
func _on_back_pressed() -> void:
	if ResourceLoader.exists(START_MENU_PATH):
		get_tree().change_scene_to_file(START_MENU_PATH)
	else:
		push_error("No se encontró StartMenu en: %s" % START_MENU_PATH)

func _on_music_slider_changed(value: float) -> void:
	Settings.music_volume = value / 100.0
	Settings.save_settings()
	Settings.apply_volumes()

func _on_sfx_slider_changed(value: float) -> void:
	Settings.sfx_volume = value / 100.0
	Settings.save_settings()
	Settings.apply_volumes()

func _on_menu_slider_changed(value: float) -> void:
	Settings.menu_volume = value / 100.0
	Settings.save_settings()
	Settings.apply_volumes()

# ------------------ EFECTO BOTONES ------------------
const BTN_HOVER_SCALE := Vector2(1.1, 1.1)
const BTN_NORMAL_SCALE := Vector2(1.0, 1.0)
const BTN_ANIM_TIME := 0.18

func _on_button_hover(btn: TextureButton) -> void:
	var t := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).bind_node(btn)
	t.tween_property(btn, "scale", BTN_HOVER_SCALE, BTN_ANIM_TIME)
	t.parallel().tween_property(btn, "modulate", Color(1.1, 1.1, 1.1), BTN_ANIM_TIME)

func _on_button_exit(btn: TextureButton) -> void:
	var t := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).bind_node(btn)
	t.tween_property(btn, "scale", BTN_NORMAL_SCALE, BTN_ANIM_TIME)
	t.parallel().tween_property(btn, "modulate", Color.WHITE, BTN_ANIM_TIME)

# ------------------ UTILS ------------------
func _set_pivots_to_center() -> void:
	back_button.pivot_offset = back_button.size * 0.5
