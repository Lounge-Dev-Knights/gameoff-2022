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
	"Cocktail_drop": {
		"stream": preload("res://sound/Drop.ogg"),
		"volume": -20
		},
	"Cocktail_move": {
		"stream": preload("res://sound/Glass_move.ogg"),
		"volume": -20
		},
	"Cocktail_done": {
		"stream": preload("res://sound/Shake.ogg"),
		"volume": -20
		},
	"Bug1": {
		"stream": preload("res://sound/bug_buzz.wav"),
		"volume": -20
		},
	"Bug2": {
		"stream": preload("res://sound/bug_buzz_bass.wav"),
		"volume": -20
		},
	"Bug3": {
		"stream": preload("res://sound/bug_buzz_high.wav"),
		"volume": -20
		},
	"Bug4": {
		"stream": preload("res://sound/bug_buzz_low.wav"),
		"volume": -20
		},
	"PERFECT": {
		"stream": preload("res://sound/EXCLAMATION_Smurf_Yay_mono.wav"),
		"volume": -20
		},
	"GREAT": {
		"stream": preload("res://sound/bug_buzz_bass.wav"),
		"volume": -20
		},
	"NICE": {
		"stream": preload("res://sound/bug_buzz_high.wav"),
		"volume": -20
		},
	"OK": {
		"stream": preload("res://sound/ORCH_Grunt_Short_01_mono.wav"),
		"volume": -20
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
