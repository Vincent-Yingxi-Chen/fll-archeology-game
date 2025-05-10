extends Node

var current_level = 0
var level_paths = [
	"res://scenes/level1.tscn",
	"res://scenes/level_2.tscn"
]


func load_level(index):
	if index < level_paths.size():
		var level_scene = load(level_paths[index])
		if level_scene == null:
			print("❌ Failed to load scene at: ", level_paths[index])
			return

		var level_instance = level_scene.instantiate()

		var root = get_tree().root
		for child in root.get_children():
			if child != self:
				root.remove_child(child)
				child.queue_free()

		root.add_child(level_instance)
		current_level = index
