extends Area2D

@onready var animation = $AnimatedSprite2D

func animate():
	animation.play("pressed")
