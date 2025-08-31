extends Node

func _ready():
	print("Ejemplo de uso del minijuego de equilibrio")
	print("Presiona ENTER para lanzar el minijuego")
	print("Presiona E para lanzar programáticamente")

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		launch_minigame_programmatically()

func launch_minigame_programmatically():
	var balance_manager = get_node_or_null("../BalanceEventManager")
	if balance_manager:
		balance_manager.launch_minigame()
	else:
		print("BalanceEventManager no encontrado")

func connect_to_minigame_events():
	var balance_manager = get_node_or_null("../BalanceEventManager")
	if balance_manager:
		balance_manager.minigame_requested.connect(_on_minigame_requested)
		balance_manager.minigame_completed.connect(_on_minigame_completed)

func _on_minigame_requested():
	print("Minijuego solicitado desde otro script")

func _on_minigame_completed(success: bool):
	if success:
		print("¡Minijuego completado desde otro script!")
	else:
		print("Minijuego fallido desde otro script")
