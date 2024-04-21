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
		EventBus.publish("ending_cinematic",self)
		for instance in get_tree().get_nodes_in_group("Enemy"):
			instance.process_mode = Node.PROCESS_MODE_DISABLED
	elif area.get_parent().is_in_group("Enemy"):
		area.get_parent().take_damage(10);

func show_score():
	$Score.text = "[center]After [color=lime]%d time loops[/color], you've finally come to the realization that there's
	not a safe way out of the ship.[/center]" % Global.restart_count
	$Score.visible = true
	
	var missing_words = len(Global.alien_word_list)-len(Global.unlocked_alien_word_list)
	$Words.text = "[center]You understood the words:\n"+str(Global.unlocked_alien_word_list)+"\n[color=crimson]%d words
	remained without meaning.[/color][/center]" % missing_words
	
	

func reset_game():
	get_tree().reload_current_scene()
