extends CharacterBody2D

const SHOVEL_COOLDOWN = 1

var dead = false

# Scene references
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var player: CharacterBody2D = %Player
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	sprite.visible = false
	collision.disabled = true


func _physics_process(delta: float) -> void:
	if dead or player == null:
		return

	global_position = player.global_position

	if Input.is_action_just_pressed("dig"):
		print("dig!")
		sprite.visible = true
		collision.disabled = false
		animation_player.play("Dig")
		await get_tree().create_timer(SHOVEL_COOLDOWN).timeout
		collision.disabled = true
		sprite.visible = false

func call_powerup():
	print("Powerup!")
	if player:
		player.doubleJump_powerup()

func reset():
	_ready()
