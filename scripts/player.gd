extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const DASH_SPEED = 500.0
const DASH_DURATION = 0.2
const DASH_COOLDOWN = 0.25
const SHOVEL_COOLDOWN = 1.0
const SLOWMO_DURATION = 2.0
const SLOWMO_SPEED = 0.8

var doubleJump = false
var dash = false
var jumps = 0
var can_dash = true
var is_dashing = false
var dash_timer = 0.0
var dead = false
var is_attacking = false

# Dig system
var current_dig_spot: Area2D = null  # Stores the dig_spot we are near

# Scene references
@export var double_jump_scene: PackedScene

# Node references
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func doubleJump_powerup():
	doubleJump = true

func dash_powerup():
	dash = true

func death():
	dead = true
	
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Jumping
	if not dead:
		if not doubleJump:
			if Input.is_action_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY
		else:
			if Input.is_action_just_pressed("jump"):
				if is_on_floor():
					velocity.y = JUMP_VELOCITY
					jumps = 0
				elif jumps < 1:
					velocity.y = JUMP_VELOCITY
					jumps += 1
	# Dashing
	if can_dash and Input.is_action_just_pressed("dash") and not is_dashing and dash:
		animated_sprite.play("dash")
		start_dash()

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			velocity.x = 0
			can_dash = false
			await get_tree().create_timer(DASH_COOLDOWN).timeout
			can_dash = true 

	# Movement
	var direction = Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		Engine.time_scale = 1

	if Input.is_action_just_pressed("attack"):
		#bow.visible = true
		#await get_tree().create_timer(DASH_COOLDOWN).timeout
		#bow.visible = false
		pass
	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Animations
	if dead:
		animated_sprite.play("death")
	else:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			if velocity.y < 0:
				animated_sprite.play("jump")
			elif velocity.y > 0:
				animated_sprite.play("fall")

	# Horizontal movement
	if dead == false:
		if direction:
			velocity.x = DASH_SPEED * direction if is_dashing else direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()

func start_dash():
	if dead == false:
		is_dashing = true
		dash_timer = DASH_DURATION
		var direction := Input.get_axis("move_left", "move_right")
		velocity.x = DASH_SPEED * direction
		animated_sprite.play("dash")
		Engine.time_scale = SLOWMO_SPEED
		await get_tree().create_timer(SLOWMO_DURATION).timeout
		Engine.time_scale = 1
	else:
		return
