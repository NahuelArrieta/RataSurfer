extends Node

# Variables de configuración
var music_volume: float = 0.8      # Level/MusicPlayer
var sfx_volume: float = 0.8        # Level/AudioStreamPlayer
var menu_volume: float = 0.8       # StartMenu/MenuPlayer

# Guardar en disco
func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.set_value("audio", "menu_volume", menu_volume)
	config.save("user://settings.cfg")

# Cargar desde disco
func load_settings() -> void:
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		if config.has_section_key("audio", "music_volume"):
			music_volume = float(config.get_value("audio", "music_volume"))
		if config.has_section_key("audio", "sfx_volume"):
			sfx_volume = float(config.get_value("audio", "sfx_volume"))
		if config.has_section_key("audio", "menu_volume"):
			menu_volume = float(config.get_value("audio", "menu_volume"))

# Helper
func get_volume(type: String) -> float:
	match type:
		"music": return music_volume
		"sfx": return sfx_volume
		"menu": return menu_volume
		_: return 1.0

# Aplicar volúmenes
func apply_volumes() -> void:
	var root = get_tree().get_root()

	var music_player = root.get_node_or_null("/root/Level/MusicPlayer")
	var sfx_player = root.get_node_or_null("/root/Level/AudioStreamPlayer")
	var menu_player = root.get_node_or_null("/root/StartMenu/MenuPlayer")

	if music_player:
		music_player.volume_db = clamp(linear_to_db(music_volume), -40.0, 0.0)
		print("🎵 MusicPlayer aplicado:", music_player.volume_db)

	if sfx_player:
		sfx_player.volume_db = clamp(linear_to_db(sfx_volume), -40.0, 0.0)
		print("🔊 SFX aplicado:", sfx_player.volume_db)

	if menu_player:
		menu_player.volume_db = clamp(linear_to_db(menu_volume), -40.0, 0.0)
		print("📀 MenuPlayer aplicado:", menu_player.volume_db)
