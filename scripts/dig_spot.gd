extends Area2D

func _ready() -> void:
	pass

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.current_dig_spot = self
		

func _on_body_exited(body: Node) -> void:
	if body.name == "Player":
		body.current_dig_spot = null
