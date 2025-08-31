extends Control

@onready var score_label: Label = $VBoxContainer/ScoreLabel
@onready var high_score_label: Label = $VBoxContainer/HighScoreLabel

var score_manager: Node

func _ready():
	# Esperar un frame para asegurar que el autoload esté disponible
	await get_tree().process_frame
	
	# Buscar el score manager en el árbol de escena
	score_manager = get_node_or_null("/root/ScoreManager")
	
	if score_manager:
		score_manager.score_updated.connect(_on_score_updated)
		score_manager.high_score_updated.connect(_on_high_score_updated)
		
		# Mostrar valores iniciales
		update_score_display(score_manager.get_current_score())
		update_high_score_display(score_manager.get_high_score())
		
func _on_score_updated(new_score: int):
	update_score_display(new_score)

func _on_high_score_updated(new_high_score: int):
	update_high_score_display(new_high_score)

func update_score_display(score: int):
	if score_label:
		score_label.text = "Score: " + str(score)

func update_high_score_display(high_score: int):
	if high_score_label:
		high_score_label.text = "High Score: " + str(high_score)
