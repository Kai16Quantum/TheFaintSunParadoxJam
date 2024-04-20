extends State


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_check_if_player_timer_timeout() -> void:
	var random_result = randi_range(0,100)
	if random_result > 80:
		transitioned_state.emit(self, "Wander")
		return

	var player_array = parent.get_instances_in_group_area("Player")
	if len(player_array) > 0:
		transitioned_state.emit(self, "Follow")
		parent.target_instance = player_array[0]
