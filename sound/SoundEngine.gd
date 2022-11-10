extends Node

const POOL_SIZE = 8

const sounds = {
	#"EntCreak": {
	#	"stream": preload("res://audio/effects/CREAK_Wood_Hollow_Deep_Smooth_mono.wav"),
	#	"volume": 0
	#},
	"MenuButtonSound": {
		"stream": preload("res://sound/bug_buzz.wav"),
		"volume": -20
		},
	"MenuButtonHoverSound": {
		"stream": preload("res://sound/bug_buzz_bass.wav"),
		"volume": -40
		},
	"El_Walk": {
		"stream": preload("res://sound/music/Al'phant-walking.ogg"),
		"volume": -25
		},
}



# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(POOL_SIZE):
		var player = AudioStreamPlayer.new()
		player.bus = "Sound"
		add_child(player)


func _get_idle_player():
	for player in get_children():
		if not (player as AudioStreamPlayer).playing:
			return player

func play_sound(sound_name: String, audio_player = null):
	if audio_player == null:
		audio_player = _get_idle_player()
	
	if audio_player != null:
		var sound = sounds[sound_name]
		audio_player.stream = sound["stream"]
		audio_player.volume_db = sound["volume"]
		audio_player.play()
