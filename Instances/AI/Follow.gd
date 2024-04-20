extends State

func enter():
	parent.get_node("Walk").start()

func process(delta):
	var dist = (parent.target_instance.my_tile_position-parent.my_tile_position).length_squared()
	if dist > 50:
		transitioned_state.emit(self, "Idle")

func walk():
	parent.move_to_tile(parent.target_instance.my_tile_position)
