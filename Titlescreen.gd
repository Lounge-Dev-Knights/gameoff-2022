extends CenterContainer


var levels = [
	"res://levels/Tutorial.tscn",
	"res://levels/Level 1.tscn",
	"res://levels/Level 2.tscn",
	"res://levels/Level 3.tscn",
	"res://levels/Level 4.tscn",
	"res://levels/Level 5.tscn",
	"res://levels/Level 6.tscn",
	"res://levels/Level 7.tscn",
	"res://levels/Level 8.tscn",
]

onready var total_cost = $CanvasLayer/Cost


func _ready():
	total_cost.text = str("Total cost of damage: $%d" % Scores.total_cost)
	
	for level in levels:
		var button = Button.new()
		button.text = level.get_file().get_basename()
		button.connect("mouse_entered", self, "_on_Play_mouse_entered")
		button.connect("pressed", SoundEngine, "play_sound", ["MenuButtonSound"])
		button.connect("pressed", SceneLoader, "goto_scene", [level, {"following_levels": []}])
		$CanvasLayer/VBoxContainer.add_child(button)


func _on_Play_pressed() -> void:
	SoundEngine.play_sound("MenuButtonSound")
	var next_level = levels.pop_front()
	SceneLoader.goto_scene(next_level, {"following_levels": levels})


func _on_Play_mouse_entered() -> void:
	SoundEngine.play_sound("MenuButtonHoverSound")
