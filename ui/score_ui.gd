extends Control

@onready var score_label: RichTextLabel = $VBoxContainer/ScoreLabel
@onready var high_score_label: Label = $VBoxContainer/HighScoreLabel

var score_manager: Node
var is_multiplier_on := false

func _ready():
	# Esperar un frame para asegurar que el autoload esté disponible
	await get_tree().process_frame
	
	# Buscar el score manager en el árbol de escena
	score_manager = get_node_or_null("/root/ScoreManager")
	ScoreManager.reset_score()
	
	if score_manager:
		score_manager.score_updated.connect(_on_score_updated)
		score_manager.high_score_updated.connect(_on_high_score_updated)
		
		# Mostrar valores iniciales
		update_score_display(score_manager.get_current_score())
		update_high_score_display(score_manager.get_high_score())
		
func _on_score_updated(new_score: float):
	update_score_display(new_score)

func _on_high_score_updated(new_high_score: float):
	update_high_score_display(new_high_score)

func update_score_display(score: float):
	if score_label and not is_multiplier_on:
		score_label.text = "Score: " + str(int(score))
	elif score_label and is_multiplier_on:
		score_label.text = "[shake rate=30.0 level=15 connected=1][color=ff3333]Score: " + str(int(score)) + "[/color][/shake]"

func update_high_score_display(high_score: float):
	if high_score_label:
		high_score_label.text = "High Score: " + str(int(high_score))


func _on_player_started_sliding() -> void:
	is_multiplier_on = true


func _on_player_stopped_sliding() -> void:
	is_multiplier_on = false
