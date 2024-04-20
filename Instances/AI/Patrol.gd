extends State

@export var patrol_points_relative = []

var patrol_timer = 0.0
var current_patrol_point = 0
var order = 1

func enter():
	patrol_timer = 0

func process(delta):
	if patrol_timer == 0:
		patrol_timer += randf_range(5,8)
		var next_tile = parent.starting_tile+get_next_patrol_point()
		parent.move_to_tile(next_tile)
	patrol_timer = max(patrol_timer-delta,0)

func get_next_patrol_point():
	if len(patrol_points_relative) > 0:
		if current_patrol_point >= len(patrol_points_relative)-1:
			order = -1
		if current_patrol_point <= 0:
			order = 1
		current_patrol_point = current_patrol_point+order
	return patrol_points_relative[current_patrol_point]


func _on_check_if_player_timer_timeout() -> void:
	var player_array = parent.get_instances_in_group_area("Player")
	if len(player_array) > 0:
		transitioned_state.emit(self, "Follow")
		parent.target_instance = player_array[0]
