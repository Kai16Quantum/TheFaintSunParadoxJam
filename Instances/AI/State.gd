extends Node
class_name State

signal transitioned_state
@onready var parent = get_parent().get_parent() #ILLEGAL BUSINESS!!! :)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> void:
	pass

func walk():
	pass

func enter():
	pass

func exit():
	pass
