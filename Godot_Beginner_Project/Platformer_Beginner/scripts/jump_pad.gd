extends Area2D

@export var jump_force = 300;

@onready var animated_sprite = $AnimatedSprite2D


func _on_body_entered(body):
	if body is Player: #Must define player class in player script
		animated_sprite.play("jump")
		body.jump(jump_force)
