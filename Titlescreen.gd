extends CenterContainer


var levels = [
	preload("res://levels/Testlevel.tscn"),
	preload("res://levels/Level_1.tscn"),
	preload("res://levels/Level_2.tscn"),
	preload("res://levels/Level_3.tscn"),
	preload("res://levels/Level_4.tscn"),
]


func _ready():
	for level in levels:
		var button = Button.new()
		button.text = (level.resource_path as String).get_file().get_basename()
		button.connect("pressed", get_tree(), "change_scene_to", [level])
		$VBoxContainer.add_child(button)


