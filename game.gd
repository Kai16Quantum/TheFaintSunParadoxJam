extends Node2D

var WorldScene = preload("res://World.tscn")
var World = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_intro_finished_intro() -> void:
	$GameIntro/Fade.show()
	$AnimationPlayer.play("Begin")
	remove_child($Intro)
	World = WorldScene.instantiate()
	add_child(World)
	$GameMusic.play()
	$Camera2D2.queue_free()

func play_game_intro():
	World.play_intro()
