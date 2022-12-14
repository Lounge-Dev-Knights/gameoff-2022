extends Node


var preloaded_scenes = {
	"res://Titlescreen.tscn": preload("res://Titlescreen.tscn"),
	# "res://scenes/level_editor/CustomLevelsManager.tscn": preload("res://scenes/level_editor/CustomLevelsManager.tscn"),
	# "res://scenes/level_editor/LevelEditor.tscn": preload("res://scenes/level_editor/LevelEditor.tscn"),
	# "res://scenes/title_screen/TitleScreen.tscn": preload("res://scenes/title_screen/TitleScreen.tscn"),
}


var current_scene = null


var transition_scene := preload("res://SceneTransition.tscn").instance()

func _ready() -> void:
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
	add_child(transition_scene)

func goto_scene(path: String, properties: Dictionary = {}) -> void:
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	
	transition_scene.get_node("AnimationPlayer").play("close")
	#SoundEngine.play_sound("Close")
	
	yield(transition_scene.get_node("AnimationPlayer"), "animation_finished")

	call_deferred("_deferred_goto_scene", path, properties)
	
	
	if "following_levels" in properties:
		transition_scene.floor_number = len(properties["following_levels"]) + 1
	else:
		transition_scene.floor_number = 0
		
	yield(transition_scene, "floor_reached")
	SoundEngine.play_sound("Ding")
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	transition_scene.get_node("AnimationPlayer").play("open")



func _deferred_goto_scene(path: String, properties: Dictionary) -> void:
	# It is now safe to remove the current scene
	# Load the new scene.
	
	var s: Resource
	
	if preloaded_scenes.has(path):
		s = preloaded_scenes[path]
	else:
		s = ResourceLoader.load(path)
	
	var old_scene = current_scene
	
	# Instance the new scene.
	current_scene = s.instance()
	
	for property in properties.keys():
		current_scene.set(property, properties[property])

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	
	old_scene.free()
