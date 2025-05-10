extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name.to_lower() == "shovel" or body.name.to_lower() == "player":
		GameManager.load_level(GameManager.current_level + 1)
		if body.has_method("reset"):
			body.reset()
