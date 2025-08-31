extends Node3D

func _ready():
	print("Nivel iniciado")
	# Verificar que el ScoreManager esté disponible
	var score_manager = get_node_or_null("/root/ScoreManager")
	if score_manager:
		print("✅ ScoreManager encontrado en el nivel")
	else:
		print("❌ ScoreManager NO encontrado en el nivel")
	
	# Agregar el gestor de eventos del minijuego de equilibrio
	var balance_manager = preload("res://ui/balance_event_manager.gd").new()
	add_child(balance_manager)
	
	# Conectar señales del minijuego
	balance_manager.minigame_completed.connect(_on_balance_minigame_completed)
	Global.player_died.connect(on_player_died)

	
func _input(event):
	# Presionar T para mostrar información del score (para pruebas)
	if event is InputEventKey and event.pressed and event.keycode == KEY_T:
		var score_manager = get_node_or_null("/root/ScoreManager")
		if score_manager:
			print("Score actual: ", score_manager.get_current_score())
			print("High score: ", score_manager.get_high_score())
		else:
			print("ScoreManager no disponible")

func _on_balance_minigame_completed(success: bool):
	if success:
		print("🎉 ¡Minijuego completado exitosamente!")
		# Aquí puedes agregar recompensas, efectos, etc.
	else:
		print("💥 Minijuego fallido")
		# Aquí puedes agregar penalizaciones, efectos, etc.
		
func on_player_died():
	# The global script will handle the scene change.
	Global.change_to_game_over()
