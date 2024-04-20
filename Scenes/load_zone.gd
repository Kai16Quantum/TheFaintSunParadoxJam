extends Area2D

@export var trigger_direction : Vector2i = Vector2i(1,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	EventBus.publish("move_to_room_direction", trigger_direction)
