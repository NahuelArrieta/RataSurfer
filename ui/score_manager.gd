extends Node

signal score_updated(new_score: int)
signal high_score_updated(new_high_score: int)

var current_score: int = 0
var high_score: int = 0
var score_per_second: int = 10  # Puntos por segundo de supervivencia
var time_elapsed: float = 0.0

const SAVE_FILE = "user://high_score.save"

func _ready():
	load_high_score()

func _process(delta: float) -> void:
	# Sumar tiempo transcurrido
	time_elapsed += delta
	
	# Calcular score basado en tiempo (puntos por segundo)
	var new_score = int(time_elapsed * score_per_second)
	
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
	time_elapsed = 0.0
	current_score = 0
	score_updated.emit(current_score)

func get_current_score() -> int:
	return current_score

func get_high_score() -> int:
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
