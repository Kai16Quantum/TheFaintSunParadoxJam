extends Area2D

@export_multiline var interaction_text = ""
@export_multiline var interaction_audio = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact():
	EventBus.publish("show_text", [interaction_text,interaction_audio])

func _on_area_entered(area: Area2D) -> void:
	EventBus.publish("show_interactable", self)


func _on_area_exited(area: Area2D) -> void:
	EventBus.publish("hide_interactable", self)
