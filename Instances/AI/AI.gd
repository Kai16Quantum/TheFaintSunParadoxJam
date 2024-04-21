extends Node

var initial_state : String = "Wander"
var states = {}
var current_state : State = null

func initialize():
	for child in get_children():
		states[child.name] = child
		child.transitioned_state.connect(on_transtioned_state)
	if initial_state:
		
		states[initial_state].enter()
		current_state = states[initial_state]
	
func enter():
	var parent = get_parent().get_parent()
	parent.talk(parent.first_player_spotted_text)

func take_damage():
	current_state.take_damage()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)

func on_transtioned_state(state, new_state_name):
	if state != current_state:
		return
	var new_state = states.get(new_state_name)
	if !new_state:
		return
	current_state.exit()
	new_state.enter()
	current_state = new_state


func _on_walk_timeout() -> void:
	current_state.walk()
