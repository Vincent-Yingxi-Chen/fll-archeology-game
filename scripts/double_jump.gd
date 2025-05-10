extends Area2D

var dug := false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node):
	print("Detected ", body.name)
	if body.name == "Shovel" and dug == false or body.name == "shovel" and dug == false:  # Check if the body that entered has the name "Player"
		animation_player.play("dug")
		body.call_powerup()
		print("touched")
		dug = true
	else:
		pass
