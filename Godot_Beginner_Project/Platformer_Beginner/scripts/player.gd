extends CharacterBody2D
class_name Player #Defines player for use in other scripts

@export var gravity = 400
@export var speed = 125
@export var jump_force = 200

@onready var animated_sprite = $AnimatedSprite2D

var active = true

func _physics_process(delta):
	if is_on_floor() == false: #is_on_floor() built in function and detects if player is on a floor
		velocity.y += gravity * delta #gravity acceleration by time
		if velocity.y > 500: #caps gravity acceleration
			velocity.y = 500
	var direction = 0
	if active == true: #active is for making the player not move at the exit (removes checks for movement)
		if Input.is_action_just_pressed("jump") && is_on_floor():
			jump(jump_force)
	
		direction = Input.get_axis("move_left", "move_right") #returns -1 if left is pressed, 1 if right is pressed, 0 if none or is pressed
	if direction != 0:
		animated_sprite.flip_h = (direction == -1)
	velocity.x = direction * speed
	move_and_slide()
	
	update_animations(direction)
	
func jump(force):
	AudioPlayer.play_sfx("jump")
	velocity.y = -force

	
func update_animations(direction):
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
