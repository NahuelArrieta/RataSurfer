extends Node

# Variables de configuración
var music_volume: float = 0.5      # Level/MusicPlayer
var sfx_volume: float = 0.5        # Level/AudioStreamPlayer

# Guardar en disco
func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.save("user://settings.cfg")

# Cargar desde disco
func load_settings() -> void:
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		if config.has_section_key("audio", "music_volume"):
			music_volume = float(config.get_value("audio", "music_volume"))
		if config.has_section_key("audio", "sfx_volume"):
			sfx_volume = float(config.get_value("audio", "sfx_volume"))

# Helper
func get_volume(type: String) -> float:
	match type:
		"music": return music_volume
		"sfx": return sfx_volume
		_: return 1.0

# Aplicar volúmenes
func apply_volumes() -> void:
	var root = get_tree().get_root()
	
	var music_bus = AudioServer.get_bus_index("Music")
	var sfx_bus = AudioServer.get_bus_index("SFX")
	
	if music_bus:
		AudioServer.set_bus_volume_db(music_bus, clamp(linear_to_db(music_volume), -40.0, 0.0))
	
	if sfx_bus:
		AudioServer.set_bus_volume_db(sfx_bus, clamp(linear_to_db(sfx_volume), -40.0, 0.0))
	
