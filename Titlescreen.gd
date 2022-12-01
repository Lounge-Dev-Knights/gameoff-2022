extends CenterContainer


var levels = [
	"res://levels/Level 1.tscn",
	"res://levels/Level 2.tscn",
	"res://levels/Level 3.tscn",
	"res://levels/Level 4.tscn",
	"res://levels/Level 5.tscn",
	"res://levels/Level 6.tscn",
	"res://levels/Level 7.tscn",
]


func _ready():
	for level in levels:
		var button = Button.new()
		button.text = level.get_file().get_basename()
		button.connect("pressed", SceneLoader, "goto_scene", [level, {"following_levels": []}])
		$VBoxContainer.add_child(button)






func _on_Play_pressed() -> void:
	var next_level = levels.pop_front()
	SceneLoader.goto_scene(next_level, {"following_levels": levels})
