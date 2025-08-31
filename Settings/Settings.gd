extends Node

# Variables de configuración
var music_volume: float = 0.8   # 0.0 a 1.0
var sfx_volume: float = 0.8     # 0.0 a 1.0

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

# Helper para obtener volumen según tipo
func get_volume(type: String) -> float:
	match type:
		"music": return music_volume
		"sfx": return sfx_volume
		_: return 1.0
