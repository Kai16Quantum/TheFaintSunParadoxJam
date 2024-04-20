extends GridInstance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func after_walk():
	#Check if there are enemies there.
	pass


func _on_check_if_player_timer_timeout() -> void:
	var player_array = get_instances_in_group_area("Player")
	if len(player_array) > 0:
		move_to_tile(player_array[0].my_tile_position)


func _on_shoot_button_pressed() -> void:
	take_damage(100)
