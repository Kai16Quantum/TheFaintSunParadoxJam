extends State

var wander_timer = 0.0

func enter():
	wander_timer = 0

func process(delta):
	if wander_timer == 0:
		select_random_tile()
		wander_timer += 5
	wander_timer = max(wander_timer-delta,0)

func select_random_tile():
	parent.move_to_tile(parent.my_tile_position+Vector2i(randi_range(-7,7), randi_range(-2,2)))

func _on_check_if_player_timer_timeout() -> void:
	var player_array = parent.get_instances_in_group_area("Player")
	if len(player_array) > 0:
		transitioned_state.emit(self, "Follow")
		parent.target_instance = player_array[0]
