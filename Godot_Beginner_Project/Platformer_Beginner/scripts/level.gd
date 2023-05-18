extends Node2D

@export var next_level: PackedScene = null
@export var is_final_level: bool = false #can turn this option on for the final level

@onready var start = $Start
@onready var exit = $Exit
@onready var death_zone = $Deathzone

@onready var hud = $UILayer/HUD
@onready var ui_layer = $UILayer

var player = null

@export var level_time = 5 #how many secs to finish levels

var timer_node = null
var time_left #how many secs are left

var win = false;

func _ready():
	player = get_tree().get_first_node_in_group("player") #gets the first node that has the group player
	if player != null: #doubles check for player
		player.global_position = start.get_spawn_pos()
	var traps = get_tree().get_nodes_in_group("traps") #returns an array thats filled with nodes tagged with groups "traps"
	for trap in traps:
		#trap.connect("touched_player", _on_trap_touched_player)
		trap.touched_player.connect(_on_trap_touched_player) #new way to write the line above
		
	exit.body_entered.connect(_on_exit_body_entered)
	death_zone.body_entered.connect(_on_deathzone_body_entered) #connects deathzone body entered signal
	
	
	time_left = level_time
	hud.set_time_label(time_left)
	
	timer_node = Timer.new() #creates a new timer node and stores it in timer node variable
	timer_node.name = "Level Timer" #changes name of timer node
	timer_node.wait_time = 1 #every 1 sec
	timer_node.timeout.connect(_on_level_timer_timeout) #every sec, will call this function/connect
	add_child(timer_node) #adds it as a child of the level scene
	timer_node.start()
	
#	var cshape = CollisionShape2D.new() /this is how you make nodes in scripts
#	add_child(cshape)

func _on_level_timer_timeout():
	if win == false:
		time_left -= 1
		hud.set_time_label(time_left)
		if time_left < 0:
			AudioPlayer.play_sfx("hurt")
			reset_player()
			time_left = level_time
			hud.set_time_label(time_left) #prints time here or else it shows -1

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func _on_deathzone_body_entered(body):
	AudioPlayer.play_sfx("hurt")
	reset_player()
	
func _on_trap_touched_player():
	AudioPlayer.play_sfx("hurt")
	reset_player()

func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()

func _on_exit_body_entered(body):
	if body is Player: #Player is a group
		if is_final_level || (next_level != null):
			exit.animate()
			player.active = false #sets active to false for player script to cancel movement
			win = true #cancels timer in func above if player wins
			await get_tree().create_timer(1.5).timeout
			if is_final_level:
				ui_layer.show_win_screen(true)
			else:
				get_tree().change_scene_to_packed(next_level)
		
