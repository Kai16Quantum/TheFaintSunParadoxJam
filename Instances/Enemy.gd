extends GridInstance
class_name EnemyInstance

var talked = false
var target_instance = null
@export_multiline var first_player_spotted_text = ""
@export var first_player_spotted_word_unlock = ""
@export var initial_state : String = "Wander"

func ready():
	if initial_state == "": initial_state = "Idle"
	$AI.initial_state = initial_state
	$AI.initialize()

func after_walk():
	#Check if there are enemies there.
	pass

func dead_action():
	Global.unlock_word("DEAD")

func take_damage_action():
	$AI.take_damage()

func _on_shoot_button_pressed() -> void:
	EventBus.publish("tried_to_shoot", self)


func _on_shoot_button_mouse_entered() -> void:
	EventBus.publish("hovering_shot")

