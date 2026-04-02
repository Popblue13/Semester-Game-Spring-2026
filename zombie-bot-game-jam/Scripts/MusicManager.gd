extends Node

var player: AudioStreamPlayer
var current_theme: String = ""

var theme_paths := {
	"factory": preload("uid://bqygckabhwqwb"),
	"lab": preload("uid://v8aw5he8dp82"),
	# add these later when they exist:
	# "courtyard": "res://audio/music/courtyard_theme.ogg",
	"silo": preload("uid://bpjawa0xoacel"),
	# "boss": "res://audio/music/boss_theme.ogg",
}

func _ready():
	player = AudioStreamPlayer.new()
	add_child(player)
	player.bus = "Master" # or "Music" if you made a music bus

func play_theme(theme_name: String):
	theme_name = theme_name.to_lower()

	if current_theme == theme_name and player.playing:
		return

	if not theme_paths.has(theme_name):
		push_warning("Theme not found: " + theme_name)
		return

	var stream: AudioStream = theme_paths[theme_name]

	current_theme = theme_name
	player.stream = stream
	player.play()

func stop_theme():
	player.stop()
	current_theme = ""

func get_current_theme() -> String:
	return current_theme
