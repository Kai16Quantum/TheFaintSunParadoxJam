extends Node2D

@export var VoiceFile: AudioStream
@export var text_string_array : Array[String]
@export var UniqueName : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if UniqueName in Global.used_dialogues:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		#Let's roll!!! Why the fuck didnt make this code inheritable I've written this more times than I'd like to admiT!!
		#gamejam things ????
		Global.use_dialogue(UniqueName)
		EventBus.publish("show_text", [text_string_array,VoiceFile,false])
		queue_free()
