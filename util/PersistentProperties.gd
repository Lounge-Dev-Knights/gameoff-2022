extends Node


# file where the properties will be stored
var filepath: String = "user://persistent_properties.json"
var storage_type: String = "json"


###
# define settings and (if needed) setters/getters
# CUSTOMIZE HERE
# var main_volume: float = 1 setget _set_main_volume


####
# define setters an getters below
# Example: set the volume of the Audiobus, every time the volume property is set
# CUSTOMIZE HERE

# set volume on AudioServer
# func _set_main_volume(new_value: float) -> void:
# AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(new_value))
# 	master_volume = new_value

###
###


var save_timer: Timer

# load settings from file
func _enter_tree() -> void:
	var save_file: File = File.new()
	if save_file.file_exists(filepath):
		var error: int = save_file.open(filepath, File.READ)
		
		if error == OK:
			var save_dict
			if storage_type == "json":
				var save_text: String = save_file.get_as_text()
				save_dict = parse_json(save_text)
			elif storage_type == "dat":
				save_dict = save_file.get_var(true)
			else:
				printerr("Unknown storage type: %" % storage_type)
				return
			
			if save_dict is Dictionary:
				for key in save_dict.keys():
					set(key, save_dict[key])
			else:
				var backup_filename = filepath + ".bak"
				printerr("Settings file could not be parsed. Content (%s) is copied to %s." % [save_file, backup_filename])
				
				# backup settings file, to recover if important settings should not be overwritten with default
				var dir = Directory.new()
				var copy_error = dir.copy(filepath, backup_filename)
				if copy_error != OK:
					printerr("File copied. Reason: %d" % copy_error)
		else:
			printerr("File couldn't be opened. Reason: %d" % error)
			
	# if settings-file doesn't exist yet, make sure every setter is called once anyway
	else:
		for property in _get_properties_to_persist():
			set(property, get(property))
	
	save_timer = Timer.new()
	add_child(save_timer)
	save_timer.connect("timeout", self, "persist_data")
	save_timer.start(20)


# save settings before game is closed
func _exit_tree() -> void:
	persist_data()

func persist_data() -> void:
	print("save %s" % filepath)
	
	var settings_file: File = File.new()
	# TODO: handle file errors
	var error: int = settings_file.open(filepath, File.WRITE)
	
	if error == OK:
		var save_dict: Dictionary = {}
		
		# collect properties that should be persisted
		for property in _get_properties_to_persist():
			save_dict[property] = get(property)
		
		if storage_type == "json":
			settings_file.store_line(to_json(save_dict))
			
		elif storage_type == "dat":
			settings_file.store_var(save_dict, true)
		else:
			printerr("Unknown storage type: %" % storage_type)
			return
	else:
		printerr("Settings file couldn't be written. Reason: %d" % error)


# get properties that should be persisted
# this works by checking for the usage flag PROPERTY_USAGE_SCRIPT_VARIABLE
# which will be set for all defined "var" in this file
func _get_properties_to_persist() -> Array:
	var properties_to_persist: Array = []
	
	for property in get_property_list():
		if property["usage"] == PROPERTY_USAGE_SCRIPT_VARIABLE:
			properties_to_persist.append(property["name"])
	
	return properties_to_persist


func reset() -> void:
	var dir = Directory.new()
	dir.remove(filepath)
	var clean_instance = get_script().new()
	clean_instance.name = name
	for prop in _get_properties_to_persist():
		set(prop, clean_instance.get(prop))
	
