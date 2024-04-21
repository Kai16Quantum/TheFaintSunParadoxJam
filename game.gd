extends Node2D

var WorldScene = preload("res://World.tscn")
var World = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.subscribe("ending_cinematic", self, "on_ending_cinematic")
	EventBus.subscribe("reset_loop", self, "on_reset_loop")
	#World = WorldScene.instantiate()
	#add_child(World)
	#$GameMusic.play()
	#World.play_intro()
	#$Camera2D2.queue_free()
	#
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_intro_finished_intro() -> void:
	$GameIntro/Fade.show()
	$AnimationPlayer.play("Begin")
	remove_child($Intro)
	$GameMusic.play()
	
	pass

func on_reset_loop(flags):
	$RestartTimer.start()
	

func reset_world():
	Global.restart_count += 1
	remove_child(World)
	World.queue_free()
	World = WorldScene.instantiate()
	add_child(World)
	World.play_intro()
	World.get_node("Other/Intro").speed_scale = 4.0

func spawn_game_world():
	World = WorldScene.instantiate()
	add_child(World)

func play_game_intro():
	World.play_intro()
	$Camera2D2.queue_free()


func _on_restart_timer_timeout() -> void:
	reset_world()

func on_ending_cinematic(flags):
	$GameMusic.stream = load("res://Assets/Music/Loneliness.mp3")
	$GameMusic.play()
