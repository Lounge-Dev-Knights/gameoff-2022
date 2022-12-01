extends CanvasLayer


func _on_Button_mouse_entered() -> void:
	SoundEngine.play_sound("MenuButtonHoverSound")


func _on_Button_pressed() -> void:
	SoundEngine.play_sound("MenuButtonSound")
	SceneLoader.goto_scene("res://Titlescreen.tscn")
