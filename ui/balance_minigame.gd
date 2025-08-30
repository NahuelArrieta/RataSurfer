extends Control

# Señales
signal success
signal fail

# Nodos
@onready var main_bar: ProgressBar = $MainBar
@onready var active_zone: Control = $MainBar/ActiveZone
@onready var icon: Control = $MainBar/Icon
@onready var balance_bar: ProgressBar = $BalanceBar

# Parámetros configurables
@export var bar_width: int = 400
@export var bar_height: int = 30
@export var icon_size: int = 20
@export var icon_speed: float = 550.0  
@export var active_zone_width: float = 0.3  
@export var balance_required: int = 2
@export var max_fails: int = 2 

# Variables
var icon_direction: int = 1  
var icon_position: float = 0.0
var balance_progress: int = 0
var fail_count: int = 0
var is_active: bool = true

func _ready():
	setup_ui()
	start_minigame()

func _input(event):
	if not is_active:
		return
		
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		check_balance()

func setup_ui():
	# Barra principal
	main_bar.custom_minimum_size = Vector2(bar_width, bar_height)
	main_bar.max_value = bar_width
	
	# Zona activa (merge)
	var zone_width = bar_width * active_zone_width
	var zone_start = (bar_width - zone_width) / 2
	active_zone.custom_minimum_size = Vector2(zone_width, bar_height)
	active_zone.position.x = zone_start
	
	# Icono del medio
	icon.custom_minimum_size = Vector2(icon_size, icon_size)
	icon_position = bar_width / 2
	update_icon_position()
	
	balance_bar.max_value = balance_required
	balance_bar.value = 0

func start_minigame():
	is_active = true
	balance_progress = 0
	fail_count = 0
	balance_bar.value = 0
	icon_position = bar_width / 2
	update_icon_position()

func _process(delta):
	if not is_active:
		return
		
	# Mover ícono
	icon_position += icon_speed * delta * icon_direction
	
	# Rebote en bordes
	if icon_position <= 0 or icon_position >= bar_width:
		icon_direction *= -1
		icon_position = clamp(icon_position, 0, bar_width)
	
	update_icon_position()

func update_icon_position():
	icon.position.x = icon_position - icon_size / 2

func check_balance():
	var icon_center = icon_position
	var zone_start = active_zone.position.x
	var zone_end = zone_start + active_zone.custom_minimum_size.x
	
	if icon_center >= zone_start and icon_center <= zone_end:
		
		balance_progress += 1
		balance_bar.value = balance_progress
		print("¡Acierto! Balance: ", balance_progress, "/", balance_required)
		
		if balance_progress >= balance_required:
			on_success()
	else:
		
		fail_count += 1
		print("Fallo! Errores: ", fail_count, "/", max_fails)
		
		if fail_count >= max_fails:
			on_fail()

func on_success():
	is_active = false
	success.emit()
	hide()

func on_fail():
	is_active = false
	fail.emit()
	hide()

func set_parameters(new_bar_width: int, new_icon_speed: float, new_zone_width: float):
	bar_width = new_bar_width
	icon_speed = new_icon_speed
	active_zone_width = new_zone_width
	setup_ui()

func reset_minigame():
	show()
	start_minigame()
