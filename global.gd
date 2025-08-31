# Global.gd
extends Node

# A custom signal that other scripts can connect to.
signal player_died

# A function to handle changing the scene.
func change_to_game_over():
	# Make sure the file path is correct for your project!
	get_tree().change_scene_to_file("res://ui/GameOver.tscn")
