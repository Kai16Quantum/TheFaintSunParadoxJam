extends Area2D
class_name Interactable

@export_multiline var interaction_text = ""
@export var interaction_audio : AudioStream = null
@export var enemy : bool = false
@export var unlock_word = ""
@export var one_shot_dialogue = true 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact(player_node):
	activate(player_node)
	if interaction_text != "":
		EventBus.publish("show_text", [[interaction_text],interaction_audio, enemy])
	if unlock_word:
		Global.unlock_word(unlock_word)
	if one_shot_dialogue:
		queue_free()

func activate(player_node):
	pass

func _on_area_entered(area: Area2D) -> void:
	EventBus.publish("show_interactable", self)


func _on_area_exited(area: Area2D) -> void:
	EventBus.publish("hide_interactable", self)
