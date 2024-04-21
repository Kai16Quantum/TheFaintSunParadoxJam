extends State

func enter():
	$Timer.start()

func take_damage():
	parent.sleep = false
	transitioned_state.emit(self, "Follow")

func _on_timer_timeout() -> void:
	parent.change_sprite("Dead")
