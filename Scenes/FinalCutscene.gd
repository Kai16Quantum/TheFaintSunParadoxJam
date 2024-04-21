extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		$AnimationPlayer.play("Ending")
		for instance in get_tree().get_nodes_in_group("Enemy"):
			instance.process_mode = Node.PROCESS_MODE_DISABLED
	elif area.get_parent().is_in_group("Enemy"):
		area.get_parent().take_damage(10);

func show_score():
	$Score.text = "After %d time loops, you've finally come to the realization that there's
	not a way out of here." % Global.restart_count
	$Score.visible = true
	
	$Words.text = "You understand the words:\n"+str(Global.unlocked_alien_word_list)

	

func reset_game():
	pass
