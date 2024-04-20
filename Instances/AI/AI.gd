extends Node

@export var initial_state : State
var states = {}
var current_state : State = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		states[child.name] = child
		child.transitioned_state.connect(on_transtioned_state)
	if initial_state:
		initial_state.enter()
		current_state = initial_state

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
