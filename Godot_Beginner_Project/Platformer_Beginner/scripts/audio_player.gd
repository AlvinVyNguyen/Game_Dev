extends Node

var hurt = preload("res://assets/audio/hurt.wav")
var jump = preload("res://assets/audio/jump.wav")

func play_sfx(sfx_name: String):
	var stream = null
	if sfx_name == "hurt":
		stream = hurt
	elif sfx_name == "jump":
		stream = jump
	else:
		print("Invalid sfx name")
		return
	
	var asp = AudioStreamPlayer.new() #creates a new audio stream player
	asp.stream = stream
	asp.name = "SFX"
	
	add_child(asp)
	asp.play()
	
	await asp.finished #node/signal finished, waits for sound to finish
	asp.queue_free() #delets asp's created after sound finishes
