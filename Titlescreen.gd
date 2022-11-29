extends CenterContainer


var levels = [
	"res://levels/Testlevel.tscn",
	"res://levels/Level_1.tscn",
	"res://levels/Level_2.tscn",
	"res://levels/Level_3.tscn",
	"res://levels/Level_4.tscn",
]


func _ready():
	for level in levels:
		var button = Button.new()
		button.text = level.get_file().get_basename()
		button.connect("pressed", SceneLoader, "goto_scene", [level])
		$VBoxContainer.add_child(button)






func _on_Play_pressed() -> void:
	var next_level = levels.pop_front()
	SceneLoader.goto_scene(next_level, {"following_levels": levels})
