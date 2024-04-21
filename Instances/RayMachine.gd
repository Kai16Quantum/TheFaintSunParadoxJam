extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.subscribe("keycard_collected", self, "on_key_card_collected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	var inst = area.get_parent()
	if inst.is_in_group("Player"):
		inst.take_damage(100)

func on_key_card_collected(flags):
	queue_free()
