extends State



func enter():
	parent.get_node("Walk").start()
	if !parent.talked && !parent.breakable_decor:
		parent.talked = true
		parent.talk(parent.first_player_spotted_text)
		if (parent.first_player_spotted_word_unlock != ""):
			Global.unlock_word(parent.first_player_spotted_word_unlock)

func process(delta):
	if parent.target_instance:
		var dist = (parent.target_instance.my_tile_position-parent.my_tile_position).length_squared()
		if dist > 50:
			transitioned_state.emit(self, "Idle")

func walk():
	if parent.target_instance:
		parent.move_to_tile(parent.target_instance.my_tile_position)
