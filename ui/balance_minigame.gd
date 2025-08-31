extends Control

# Señales
signal success
signal fail
	
# Nodos
@onready var main_bar: ColorRect = $MainBar
@onready var active_zone: Control = $MainBar/ActiveZone
@onready var icon: Control = $MainBar/Icon
@onready var balance_bar: ProgressBar = $BalanceBar

# Parámetros configurables
@export var bar_width: int = 400
@export var bar_height: int = 30
@export var icon_size: int = 20
@export var zone_speed: float = 350.0  # Velocidad de movimiento de la zona activa
@export var icon_speed: float = 450.0   # Velocidad de movimiento del ícono
@export var active_zone_width: float = 0.3  
@export var time_required: float = 2.0  # Tiempo requerido sobre el ícono (segundos)
@export var time_to_fail: float = 2.0   # Tiempo fuera de la zona para perder (segundos)

# Variables
var zone_position: float = 0.0
var zone_direction: int = -1  # -1 = izquierda, 1 = derecha
var icon_position: float = 0.0
var icon_direction: int = 1   # Dirección del ícono
var time_on_icon: float = 0.0
var time_outside_zone: float = 0.0
var is_active: bool = true
var space_pressed: bool = false
var was_in_zone: bool = false  # Para detectar cambios de estado

func _ready():
	setup_ui()
	start_minigame()

func _input(event):
	if not is_active:
		return
		
	if event is InputEventKey and event.keycode == KEY_SPACE:
		if event.pressed:
			space_pressed = true
		else:
			space_pressed = false

func setup_ui():
	# Barra principal (ColorRect)
	main_bar.custom_minimum_size = Vector2(bar_width, bar_height)
	
	# Zona activa
	var zone_width = bar_width * active_zone_width
	active_zone.custom_minimum_size = Vector2(zone_width, bar_height)
	zone_position = (bar_width - zone_width) / 2  # Centrar inicialmente
	update_zone_position()
	
	# Icono del medio (con movimiento aleatorio)
	icon.custom_minimum_size = Vector2(icon_size, icon_size)
	icon_position = bar_width / 2  # Centrar inicialmente
	update_icon_position()
	
	# Barra de equilibrio
	balance_bar.max_value = time_required
	balance_bar.value = 0

func start_minigame():
	is_active = true
	time_on_icon = 0.0
	time_outside_zone = 0.0
	balance_bar.value = 0
	space_pressed = false
	was_in_zone = false
	
	# Posicionar zona activa al inicio
	var zone_width = bar_width * active_zone_width
	zone_position = (bar_width - zone_width) / 2
	update_zone_position()
	
	# Posicionar ícono al centro
	icon_position = bar_width / 2
	icon_direction = 1 if randf() > 0.5 else -1  # Dirección aleatoria inicial
	update_icon_position()

func _process(delta):
	if not is_active:
		return
		
	# Mover zona activa basado en input
	if space_pressed:
		zone_direction = 1  # Mover hacia la derecha
	else:
		zone_direction = -1  # Mover hacia la izquierda
	
	zone_position += zone_speed * delta * zone_direction
	
	# Limitar zona activa dentro de la barra
	var zone_width = bar_width * active_zone_width
	zone_position = clamp(zone_position, 0, bar_width - zone_width)
	
	# Mover ícono de forma aleatoria
	move_icon_randomly(delta)
	
	update_zone_position()
	update_icon_position()
	check_balance(delta)

func move_icon_randomly(delta):
	# Mover ícono
	icon_position += icon_speed * delta * icon_direction
	
	# Rebotar en los bordes
	if icon_position <= icon_size / 2 or icon_position >= bar_width - icon_size / 2:
		icon_direction *= -1
		icon_position = clamp(icon_position, icon_size / 2, bar_width - icon_size / 2)
		
		# Ocasionalmente cambiar dirección aleatoriamente
		if randf() < 0.3:  # 30% de probabilidad
			icon_direction *= -1

func update_zone_position():
	active_zone.position.x = zone_position

func update_icon_position():
	icon.position.x = icon_position - icon_size / 2

func check_balance(delta):
	var icon_center = icon_position
	var zone_start = zone_position
	var zone_end = zone_position + active_zone.custom_minimum_size.x
	var is_in_zone = (icon_center >= zone_start and icon_center <= zone_end)
	
	# Detectar cambio de estado (entrar/salir de la zona)
	if is_in_zone != was_in_zone:
		if is_in_zone:
			print("Entró a la zona activa - Contadores pausados/reanudados")
		else:
			print("Salió de la zona activa - Contadores pausados/reanudados")
		was_in_zone = is_in_zone
	
	# Verificar si la zona activa está sobre el ícono
	if is_in_zone:
		# Zona activa sobre el ícono
		time_on_icon += delta
		# NO resetear time_outside_zone - se mantiene acumulativo
		balance_bar.value = time_on_icon
		
		print("Tiempo en la zona: ", time_on_icon, "/", time_required)
		
		if time_on_icon >= time_required:
			on_success()
	else:
		# Zona activa fuera del ícono
		time_outside_zone += delta
		# NO resetear time_on_icon - se mantiene acumulativo
		balance_bar.value = time_on_icon  # Mantener el progreso visual
		
		print("Tiempo fuera de la zona: ", time_outside_zone, "/", time_to_fail)
		
		if time_outside_zone >= time_to_fail:
			on_fail()

func on_success():
	print("¡Minijuego completado con éxito!")
	is_active = false
	success.emit()
	hide()

func on_fail():
	print("Minijuego fallido - 2 segundos acumulados fuera de la zona")
	is_active = false
	fail.emit()
	hide()

# Funciones públicas para configuración externa
func set_parameters(new_bar_width: int, new_zone_speed: float, new_zone_width: float):
	bar_width = new_bar_width
	zone_speed = new_zone_speed
	active_zone_width = new_zone_width
	setup_ui()

func reset_minigame():
	show()
	start_minigame()
