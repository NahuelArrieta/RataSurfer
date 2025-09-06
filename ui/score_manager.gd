extends Node

signal score_updated(new_score: float)
signal high_score_updated(new_high_score: float)

var current_score: float = 0
var high_score: float = 0
var new_score := 0.0
var score_per_second: int = 10  # Puntos por segundo de supervivencia
var score_multiplier := 1

const SAVE_FILE = "user://high_score.save"

func _ready():
	load_high_score()

func _process(delta: float) -> void:
	
	# Calcular score basado en tiempo (puntos por segundo)
	new_score += delta * score_per_second * score_multiplier
	
	# Solo actualizar si el score cambió
	if new_score != current_score:
		current_score = new_score
		score_updated.emit(current_score)
		
		# Verificar si es un nuevo high score
		if current_score > high_score:
			high_score = current_score
			save_high_score()
			high_score_updated.emit(high_score)

func reset_score() -> void:
	current_score = 0
	new_score = 0
	score_multiplier = 1
	score_updated.emit(current_score)

func get_current_score() -> float:
	return current_score

func get_high_score() -> float:
	return high_score

func save_high_score() -> void:
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_var(high_score)
		file.close()

func load_high_score() -> void:
	if FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		if file:
			high_score = file.get_var()
			file.close()
			high_score_updated.emit(high_score)
