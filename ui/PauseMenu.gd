extends Control

# ------------------ CONSTANTES ------------------
const MAIN_MENU_PATH := "res://ui/StartMenu.tscn"

const BTN_HOVER_SCALE := Vector2(1.1, 1.1)
const BTN_NORMAL_SCALE := Vector2(1.0, 1.0)
const BTN_ANIM_TIME := 0.18

const ENTRY_FADE_TIME := 0.25
const ENTRY_SCALE_TIME := 0.55
const EXIT_SCALE_TIME := 0.45
const EXIT_FADE_TIME := 0.30

# ------------------ NODOS ------------------
@onready var center_container: Control = $VBoxContainer
@onready var resume_button: TextureButton = $VBoxContainer/PlayButton
@onready var main_menu_button: TextureButton = $VBoxContainer/ExitButton


# ------------------ READY ------------------
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

	# Conectar señales
	resume_button.pressed.connect(_on_resume_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)

	resume_button.mouse_entered.connect(_on_button_hover.bind(resume_button))
	resume_button.mouse_exited.connect(_on_button_exit.bind(resume_button))
	main_menu_button.mouse_entered.connect(_on_button_hover.bind(main_menu_button))
	main_menu_button.mouse_exited.connect(_on_button_exit.bind(main_menu_button))

	# Esperar un frame para calcular pivotes
	await get_tree().process_frame
	_set_pivots_to_center()


# ------------------ INPUT ------------------
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		print(">>> Escape detectado <<<")
		_toggle_pause()


# ------------------ PAUSA / RESUME ------------------
func _toggle_pause() -> void:
	if get_tree().paused:
		_resume_game()
	else:
		_pause_game()

func _pause_game() -> void:
	get_tree().paused = true
	visible = true
	_play_entry_animation()

func _resume_game() -> void:
	await _play_exit_animation()
	visible = false
	get_tree().paused = false


# ------------------ ANIMACIONES ------------------
func _play_entry_animation() -> void:
	center_container.scale = Vector2(0.01, 0.01)
	center_container.modulate.a = 0.0

	var t := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).bind_node(center_container)
	t.tween_property(center_container, "modulate:a", 1.0, ENTRY_FADE_TIME)
	t.tween_property(center_container, "scale", Vector2.ONE, ENTRY_SCALE_TIME)
	t.tween_property(center_container, "scale", Vector2.ONE * 1.03, 0.08)
	t.tween_property(center_container, "scale", Vector2.ONE, 0.08)

func _play_exit_animation() -> Signal:
	var t := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD).bind_node(center_container)
	t.tween_property(center_container, "scale", Vector2(0.01, 0.01), EXIT_SCALE_TIME)
	t.parallel().tween_property(center_container, "modulate:a", 0.0, EXIT_FADE_TIME)
	return t.finished


# ------------------ EFECTO BOTONES ------------------
func _on_button_hover(btn: Button) -> void:
	var t := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).bind_node(btn)
	t.tween_property(btn, "scale", BTN_HOVER_SCALE, BTN_ANIM_TIME)
	t.parallel().tween_property(btn, "modulate", Color(1.1, 1.1, 1.1), BTN_ANIM_TIME)

func _on_button_exit(btn: Button) -> void:
	var t := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).bind_node(btn)
	t.tween_property(btn, "scale", BTN_NORMAL_SCALE, BTN_ANIM_TIME)
	t.parallel().tween_property(btn, "modulate", Color.WHITE, BTN_ANIM_TIME)


# ------------------ HANDLERS ------------------
func _on_resume_pressed() -> void:
	_resume_game()

func _on_main_menu_pressed() -> void:
	await _play_exit_animation()
	get_tree().paused = false

	if ResourceLoader.exists(MAIN_MENU_PATH):
		get_tree().change_scene_to_file(MAIN_MENU_PATH)
	else:
		push_error("No se encontró la escena de menú en: %s" % MAIN_MENU_PATH)


# ------------------ UTILS ------------------
func _set_pivots_to_center() -> void:
	center_container.pivot_offset = center_container.size * 0.5
	resume_button.pivot_offset = resume_button.size * 0.5
	main_menu_button.pivot_offset = main_menu_button.size * 0.5
